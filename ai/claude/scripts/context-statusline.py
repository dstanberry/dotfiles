#!/usr/bin/env python3
"""
context-statusline.py
=====================
Claude Code statusLine script that renders all status bar fields
with a context waterline bar and color-coded threshold indicators.

Segment order: model | location | cost | rate limit | context

Output examples:
  Below low water:
    🤖 Sonnet 4.6 │ ⎇ main │ 💰 $0.85 (4.6K) │ 🚦 23% (47m) │ 💬 38% [████░░░░░░] 76K/200K

  At low water (60%+):
    🤖 Sonnet 4.6 │ ⎇ main │ 💰 $1.20 (8.1K) │ 🚦 31% (30m) │ ℹ️ 63% [██████░░░░] 126K/200K

  At high water (80%+):
    🤖 Sonnet 4.6 │ ⎇ main │ 💰 $1.80 (12K) │ 🚦 45% (15m) │ ⚠️ 82% [████████░░] 164K/200K

Side effect:
  Writes $CLAUDE_CONFIG_DIR/context-status/{session_id}.json so context-waterline.py
  can read accurate token counts without re-parsing stdin.
"""

import re
import sys
import json
import os
import subprocess
import time
import unicodedata
from pathlib import Path
from datetime import datetime

MAX_LINE_WIDTH = 78
SEP = " │ "

LOW_WATER_PCT = int(os.environ.get("CONTEXT_LOW_WATER_PCT", "60"))
HIGH_WATER_PCT = int(os.environ.get("CONTEXT_HIGH_WATER_PCT", "80"))
CONTEXT_BAR_WIDTH = 10
CONFIG_DIR = Path.home() / ".config" / "ai" / "claude"
STATE_DIR = Path(os.environ.get("CLAUDE_CONFIG_DIR", CONFIG_DIR)) / "context-status"
STATE_DIR.mkdir(parents=True, exist_ok=True)

# Matches all ANSI CSI escape sequences (e.g. \033[91m, \033[0m).
_ANSI_ESCAPE_RE = re.compile(r"\033\[[0-9;]*m")

# Flags shared by every git subprocess call in this file.
_GIT_FLAGS = ("-c", "core.fileMode=false", "-c", "advice.detachedHead=false")


def _char_cell_width(ch: str) -> int:
    """Return the number of terminal cells occupied by a single character.

    - East-Asian-width 'W' or 'F' → 2 cells.
    - Codepoints in 0x1F000–0x1FFFF (supplementary emoji plane, not yet
      universally tagged W/F in older Unicode tables) → 2 cells.
    - All other chars (including ambiguous 'A': │, ░, █, …) → 1 cell.
      Western terminals render ambiguous-width chars as narrow.
    """
    eaw = unicodedata.east_asian_width(ch)
    if eaw in ("W", "F"):
        return 2
    if 0x1F000 <= ord(ch) < 0x20000:
        return 2
    return 1


def visual_len(s: str) -> int:
    """Return the number of terminal cells occupied by *s*, excluding ANSI escapes.

    Scans the plain text (ANSI stripped) character by character. U+FE0F
    (Variation Selector-16) following a narrow base char forces emoji
    presentation and consumes no extra cell width — the pair is counted as
    2 cells total (base 1 + VS16 upgrade to 2) and both characters are
    consumed together.
    """
    plain = _ANSI_ESCAPE_RE.sub("", s)
    cells = 0
    i = 0
    while i < len(plain):
        ch = plain[i]
        next_ch = plain[i + 1] if i + 1 < len(plain) else ""
        if next_ch == "️":
            # VS16 upgrades an otherwise-narrow base to emoji presentation.
            # Count the pair as 2 cells and skip both characters.
            cells += max(2, _char_cell_width(ch))
            i += 2
        else:
            cells += _char_cell_width(ch)
            i += 1
    return cells


def fmt(n: int) -> str:
    if n >= 1_000_000:
        return f"{n//1_000_000}M"
    if n >= 1_000:
        return f"{n//1_000}K"
    return str(n)


def read_input() -> dict:
    try:
        raw = sys.stdin.read()
        return json.loads(raw) if raw.strip() else {}
    except (json.JSONDecodeError, OSError):
        return {}


def render_model(data: dict) -> str | None:
    name = data.get("model", {}).get("display_name", "")
    if not name:
        return None
    # Strip redundant context-size parentheticals such as "(1M context)" or
    # "(200K context)" — the gauge segment already shows the window size.
    name = re.sub(r"\s*\([^)]*context[^)]*\)\s*$", "", name).strip()
    return f"🤖 {name}"


def _git_branch(cwd: str) -> str | None:
    """Return the current git branch name or short SHA, or None if not in a repo."""
    commands = [
        ["git", *_GIT_FLAGS, "-C", cwd, "branch", "--show-current"],
        ["git", *_GIT_FLAGS, "-C", cwd, "rev-parse", "--short", "HEAD"],
    ]
    try:
        for cmd in commands:
            result = subprocess.run(cmd, capture_output=True, text=True)
            output = result.stdout.strip()
            if result.returncode == 0 and output:
                return output
    except (OSError, subprocess.SubprocessError):
        pass
    return None


def _relative_path(cwd: str) -> str:
    """Return a home-relative path string (e.g. '~/.config'), no truncation."""
    path = Path(cwd)
    try:
        return "~/" + str(path.relative_to(Path.home()))
    except ValueError:
        return str(path)


def _fit_path(path: str, budget: int) -> str:
    """
    Return a version of *path* that fits within *budget* visible codepoints.

    Truncation strategy (longest-tail first):
      1. Full path — if it fits, return as-is.
      2. Drop leading components one at a time, prefixing the remainder with
         '…/', keeping the longest tail that fits.
      3. If even '…/leaf' is too long, try the bare leaf (no prefix).
      4. If the bare leaf is still too long, end-truncate to budget-1 chars + '…'.
      5. Return '' (signal to drop the segment) when budget < 2.
    """
    if budget < 2:
        return ""
    if visual_len(path) <= budget:
        return path

    # Split on '/' while preserving the home-prefix form from _relative_path().
    stripped = path.removeprefix("~/")
    parts = stripped.split("/")
    leaf = parts[-1]

    # Try progressively shorter tails: drop one leading component per step.
    for drop in range(1, len(parts)):
        candidate = "…/" + "/".join(parts[drop:])
        if visual_len(candidate) <= budget:
            return candidate

    # Bare leaf (no '.../' prefix).
    if visual_len(leaf) <= budget:
        return leaf

    # End-truncate the leaf to fit.
    return leaf[: budget - 1] + "…"


def render_location(data: dict) -> str | None:
    """
    Render the workspace location segment.

    In a git repository: '⎇ <branch-or-sha>'
    Outside a repository: '📁 <home-relative path>'
    """
    cwd = data.get("workspace", {}).get("current_dir", "")
    if not cwd:
        return None

    branch = _git_branch(cwd)
    if branch is not None:
        return f"⎇ {branch}"
    return f"📁 {_relative_path(cwd)}"


def render_cost(data: dict) -> str | None:
    cost = data.get("cost", {}).get("total_cost_usd")
    if cost is None:
        return None
    cw = data.get("context_window", {})
    total_tokens = cw.get("total_input_tokens", 0) + cw.get("total_output_tokens", 0)
    token_str = f" ({fmt(total_tokens)})" if total_tokens > 0 else ""
    return f"💰 ${cost:.2f}{token_str}"


def render_rate_limit(data: dict) -> str | None:
    rl = data.get("rate_limits", {}).get("five_hour", {})
    pct = rl.get("used_percentage")
    if pct is None:
        return None

    resets_at = rl.get("resets_at")
    reset_str = ""
    try:
        secs_left = int(resets_at) - int(time.time())
        reset_str = f" ({secs_left // 60}m)" if secs_left > 0 else ""
    except (ValueError, TypeError):
        pass

    color = (
        "\033[91m"
        if pct >= HIGH_WATER_PCT
        else "\033[93m" if pct >= LOW_WATER_PCT else "\033[92m"
    )
    return f"🚦 {color}{pct:.0f}%{reset_str}\033[0m"


def render_context(data: dict, session_id: str) -> str | None:
    cw = data.get("context_window", {})
    pct = cw.get("used_percentage")
    total = cw.get("context_window_size") or cw.get("total", 0)

    if pct is None:
        return None
    pct = int(pct)

    used = (
        int((pct / 100) * total) if total else None
    )  # derives from pct × total, e.g. 78% × 200k = 156k

    # Write state file for context-waterline.py to read.
    if total and used is not None:
        try:
            (STATE_DIR / f"{session_id}.json").write_text(
                json.dumps(
                    {
                        "used": used,
                        "total": total,
                        "pct": pct,
                        "free": total - used,
                        "updated": datetime.now().isoformat(timespec="seconds"),
                    }
                )
            )
        except OSError:
            pass

    filled = int((pct / 100) * CONTEXT_BAR_WIDTH)
    empty = CONTEXT_BAR_WIDTH - filled
    bar_body = "█" * filled + "░" * empty

    thresholds = [
        (HIGH_WATER_PCT, "⚠️", "\033[91m"),
        (LOW_WATER_PCT, "ℹ️", "\033[93m"),
        (0, "💬", ""),
    ]
    icon, color = next(
        (icon, color) for threshold, icon, color in thresholds if pct >= threshold
    )
    bar = f"{color}{bar_body}\033[0m" if color else bar_body

    counts = f" {fmt(used)}/{fmt(total)}" if (used is not None and total) else ""
    return f"{icon} {pct}% [{bar}]{counts}"


def _truncate_location(seg: str, budget: int) -> str | None:
    """
    Return a truncated version of *seg* that fits within *budget* visible
    codepoints (excluding the icon prefix), or None to signal drop.

    Dispatch by icon:
      ⎇  branch  → simple end-truncation with ellipsis
      📁  path   → budget-aware longest-tail truncation via _fit_path
    """
    icon, _, text = seg.partition(" ")
    if visual_len(text) <= budget:
        return seg  # Already fits; nothing to do.

    if icon == "⎇":
        if budget < 2:
            return None
        return f"{icon} {text[:budget - 1]}…"

    # 📁 path — delegate to _fit_path (returns "" to signal drop).
    fitted = _fit_path(text, budget)
    return f"{icon} {fitted}" if fitted else None


def main() -> None:
    data = read_input()
    session_id = (
        data.get("session_id") or os.environ.get("CLAUDE_SESSION_ID") or "default"
    )

    segments: list[str] = []
    location_index: int | None = None
    for renderer in [
        render_model,
        render_location,
        render_cost,
        render_rate_limit,
        lambda d: render_context(d, session_id),
    ]:
        val = renderer(data)
        if not val:
            continue
        if renderer is render_location:
            location_index = len(segments)
        segments.append(val)

    line = SEP.join(segments)
    if visual_len(line) <= MAX_LINE_WIDTH or location_index is None:
        print(line, flush=True)
        return

    # Compute the character budget for the truncatable text inside the location
    # segment (icon + space excluded).
    other_segments = segments[:location_index] + segments[location_index + 1 :]
    other_width = visual_len(SEP.join(other_segments))
    sep_cost = len(SEP) * (1 if other_segments else 0)
    loc_seg = segments[location_index]
    icon = loc_seg.partition(" ")[0]
    # Derive prefix cost from the actual icon — both ⎇ and 📁 happen to be
    # 1 visible codepoint, but computing it explicitly avoids a buried assumption.
    icon_prefix_len = visual_len(icon) + 1  # +1 for the separating space
    budget = MAX_LINE_WIDTH - other_width - sep_cost - icon_prefix_len

    result = _truncate_location(loc_seg, budget)
    if result is None:
        segments.pop(location_index)
    else:
        segments[location_index] = result

    print(SEP.join(segments), flush=True)


if __name__ == "__main__":
    main()
