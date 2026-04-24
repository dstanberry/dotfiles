#!/usr/bin/env python3
"""
context-waterline.py
====================
Claude Code hook that monitors context usage via the StatusLine bridge
and injects /compact instructions when water marks are crossed.

Fires on: Stop, UserPromptSubmit

Architecture
------------
This script does NOT estimate tokens from the transcript.
Instead it reads the state file written by context-statusline.py,
which receives REAL token counts from Claude Code's status bar engine.
This gives accurate readings rather than character-count approximations.

  context-statusline.py  ←→  $CLAUDE_CONFIG_DIR/context-status/{session}.json
                             ↑
                             context-waterline.py reads this

If the state file is absent or stale (>60s old), falls back to
transcript estimation so the hook still works even if the statusLine
script hasn't run yet.

Thresholds (env override or edit defaults below)
-------------------------------------------------
  CONTEXT_LOW_WATER_PCT    default 60   advisory notice
  CONTEXT_HIGH_WATER_PCT   default 80   inject /compact instruction
  CONTEXT_HARD_STOP_PCT    default 95   block prompt entirely (exit 2)

Behavior
--------
  < LOW_WATER_PCT         silent
  >= LOW_WATER_PCT        injects advisory: context filling, wrap up soon
  >= HIGH_WATER_PCT       injects direct /compact instruction to Claude
  >= HARD_STOP_PCT        exit 2 — blocks prompt, stderr message to Claude

The /compact instruction injected at high water:
  Claude reads it as part of the next prompt's context and will
  run /compact before proceeding with the user's request.
  This is the closest available mechanism to auto-firing /compact —
  hooks cannot invoke slash commands directly.

Warning suppression
-------------------
Each warning level re-fires only after usage climbs 5+ percentage
points since the last warning. Resets automatically after /compact
drops usage back below the low water mark.
"""

import sys
import os
import json
import math
import logging
import re
from pathlib import Path

# ─────────────────────────────────────────────
# Configuration
# ─────────────────────────────────────────────

LOW_WATER_PCT = int(os.environ.get("CONTEXT_LOW_WATER_PCT", "60"))
HIGH_WATER_PCT = int(os.environ.get("CONTEXT_HIGH_WATER_PCT", "80"))
HARD_STOP_PCT = int(os.environ.get("CONTEXT_HARD_STOP_PCT", "95"))

CONFIG_DIR = Path(
    os.environ.get("CLAUDE_CONFIG_DIR", str(Path.home() / ".config" / "ai" / "claude"))
)
STATE_DIR = CONFIG_DIR / "context-status"
WARN_STATE = CONFIG_DIR / "context-watermark-state.json"
LOG_FILE = Path(
    os.environ.get("CONTEXT_LOG_FILE", str(CONFIG_DIR / "context-watermark.log"))
)

# ─────────────────────────────────────────────
# Logging  (file only — stdout is Claude's context injection channel)
# ─────────────────────────────────────────────

LOG_FILE.parent.mkdir(parents=True, exist_ok=True)
logging.basicConfig(
    filename=str(LOG_FILE),
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s",
)
log = logging.getLogger("context-watermark")

# ─────────────────────────────────────────────
# Hook input
# ─────────────────────────────────────────────


def read_hook_input() -> dict:
    try:
        raw = sys.stdin.read()
        return json.loads(raw) if raw.strip() else {}
    except (json.JSONDecodeError, OSError):
        return {}


def resolve_session_id(hook_data: dict) -> str:
    """
    Extract session_id from hook payload.
    Primary:  hook_data["session_id"]
    Fallback: UUID stem of transcript_path filename
    Fails:    exits with error if neither is available — no silent
              fallback to a different session's data.
    """
    session_id = hook_data.get("session_id", "").strip()
    if session_id:
        return session_id

    # Try extracting UUID from transcript path: /.../.claude/projects/.../UUID.jsonl
    transcript_path = hook_data.get("transcript_path", "").strip()
    if transcript_path:
        stem = Path(transcript_path).stem
        if re.match(
            r"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$",
            stem,
            re.I,
        ):
            log.warning(f"session_id absent, extracted from transcript path: {stem}")
            return stem

    # Hard fail — no silent fallback
    log.error("No Claude Code unique identifier found. Skipping compaction warning.")
    print(
        "No Claude Code unique identifier found. Skipping compaction warning.",
        file=sys.stderr,
    )
    sys.exit(1)


# ─────────────────────────────────────────────
# Context reading — StatusLine bridge (primary)
# ─────────────────────────────────────────────


def read_statusline_state(session_id: str) -> tuple[int, int, int | None, str]:
    """
    Read the state file written by context-statusline.py.
    Returns (used_tokens, total_tokens, pct, source_description).

    Two files are checked:
      {session_id}.json      — current state, overwritten every statusline tick
      {session_id}.last.json — last-reported copy, never deleted

    If current file is missing but last file exists, the current file was
    deleted after being written. Report last known data with a warning source.
    If neither exists, session has not yet produced a statusline tick — zero
    is valid, stay silent.
    """
    state_file = STATE_DIR / f"{session_id}.json"
    last_state_file = STATE_DIR / f"{session_id}.last.json"

    if state_file.exists():
        source = "statusline"
        path = state_file
    elif last_state_file.exists():
        source = "statusline_last_known"
        path = last_state_file
        log.warning(
            f"[{session_id}] Current state file missing, using last-reported data. "
            f"State file may have been deleted."
        )
    else:
        # Neither file exists — session has not yet produced a statusline tick
        return 0, 0, None, f"state_file_missing:{session_id}"

    try:
        data = json.loads(path.read_text())
        used = int(data.get("used", 0))
        total = int(data.get("total", 0))
        pct = data.get("pct")

        if total == 0:
            return 0, 0, None, "state_zero_total"

        if total > 0 and source == "statusline":
            # Waterline owns the last-reported copy — written after a successful
            # read of the current state file. If the current file is later deleted,
            # the last.json remains as evidence it existed and what it contained.
            try:
                last_file = STATE_DIR / f"{session_id}.last.json"
                last_file.write_text(path.read_text())
            except OSError:
                pass

        return used, total, pct, source

    except (OSError, json.JSONDecodeError, ValueError) as e:
        log.debug(f"StatusLine state read error: {e}")
        return 0, 0, None, "state_read_error"


# ─────────────────────────────────────────────
# Context reading — transcript fallback
# ─────────────────────────────────────────────

# ─────────────────────────────────────────────
# Warning state persistence
# ─────────────────────────────────────────────


def load_warn_state(session_id: str) -> dict:
    try:
        if WARN_STATE.exists():
            return json.loads(WARN_STATE.read_text()).get(session_id, {})
    except (OSError, json.JSONDecodeError):
        pass
    return {}


def save_warn_state(session_id: str, state: dict):
    try:
        all_states: dict = {}
        if WARN_STATE.exists():
            try:
                all_states = json.loads(WARN_STATE.read_text())
            except (OSError, json.JSONDecodeError):
                pass
        all_states[session_id] = state
        if len(all_states) > 20:
            for old in sorted(all_states)[:-20]:
                del all_states[old]
        WARN_STATE.write_text(json.dumps(all_states, indent=2))
    except OSError as e:
        log.warning(f"Warn state save error: {e}")


# ─────────────────────────────────────────────
# Output
# ─────────────────────────────────────────────


def inject(message: str):
    """stdout → Claude Code injects this as context on UserPromptSubmit/Stop."""
    print(message, flush=True)


def hard_block(message: str):
    """exit 2 → rejects the prompt; stderr shown to Claude as error context."""
    print(message, file=sys.stderr, flush=True)
    sys.exit(2)


# ─────────────────────────────────────────────
# Main
# ─────────────────────────────────────────────


def main():
    hook_data = read_hook_input()
    session_id = resolve_session_id(hook_data)
    hook_event = hook_data.get("hook_event_name", "unknown")

    # ── Get token counts ─────────────────────────────────────────────────
    used, total, state_pct, source = read_statusline_state(session_id)

    if used == 0:
        log.debug(f"[{session_id}] No usage data (source={source}), skipping")
        sys.exit(0)

    # Prefer pct written directly from Claude Code's used_percentage field —
    # it includes output + system tokens, not just input tokens.
    # Fall back to recalculating only when pct was not recorded.
    if state_pct is not None:
        pct = min(100, int(state_pct))
    else:
        pct = min(100, math.floor((used / total) * 100))
    state = load_warn_state(session_id)
    last = state.get("last_warned_pct", 0)

    used_k = f"{used:,}"
    total_k = f"{total:,}"

    log.info(
        f"[{session_id}] event={hook_event} "
        f"{used_k}/{total_k} ({pct}%) "
        f"last_warned={last}% source={source}"
    )

    # ── Hard stop ────────────────────────────────────────────────────────
    if pct >= HARD_STOP_PCT:
        save_warn_state(session_id, {"last_warned_pct": pct})
        hard_block(
            f"⛔  CONTEXT CRITICAL — {pct}% used ({used_k} / {total_k} tokens)\n"
            f"This prompt has been blocked. You must run /compact before continuing.\n"
            f"Run /compact now, then resubmit your request."
        )

    # ── High water — inject /compact instruction ─────────────────────────
    elif pct >= HIGH_WATER_PCT:
        if pct >= last + 5 or last < HIGH_WATER_PCT:
            save_warn_state(session_id, {"last_warned_pct": pct})
            inject(
                f"[CONTEXT HOOK — HIGH WATER: {pct}% used, {used_k}/{total_k} tokens]\n"
                f"Before responding to the user's request below, run /compact to compress\n"
                f"conversation history. After /compact completes, then address the request.\n"
                f"Do not skip this step — context quality degrades above {HIGH_WATER_PCT}%."
            )
            log.warning(
                f"[{session_id}] HIGH WATER — /compact instruction injected at {pct}%"
            )

    # ── Low water — advisory only ────────────────────────────────────────
    elif pct >= LOW_WATER_PCT:
        if pct >= last + 5 or last < LOW_WATER_PCT:
            save_warn_state(session_id, {"last_warned_pct": pct})
            inject(
                f"[CONTEXT HOOK — LOW WATER: {pct}% used, {used_k}/{total_k} tokens]\n"
                f"Context is filling up. Consider finishing the current task soon\n"
                f"and running /compact or starting a new session."
            )
            log.info(f"[{session_id}] LOW WATER advisory at {pct}%")

    # ── Below low water — silent, reset if needed ────────────────────────
    else:
        if last >= LOW_WATER_PCT:
            # Context dropped (e.g. after /compact) — reset so warnings fire again
            save_warn_state(session_id, {"last_warned_pct": 0})
            log.info(
                f"[{session_id}] Context at {pct}% — warning state reset (was {last}%)"
            )

    sys.exit(0)


if __name__ == "__main__":
    main()
