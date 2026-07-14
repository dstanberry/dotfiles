#!/usr/bin/env python3
"""Deterministic lint for an LLM instruction file (SKILL.md or agent.md).

Checks the mechanical things LLM reviewers reliably miss:
  - frontmatter block is present and closed
  - `name:` is present and matches the parent directory name
  - `description:` is present and non-empty
  - body content is within budget, measured in WORDS (wrapping-invariant, so
    hard-wrapping prose to 80 columns does not trip it; physical line count is
    reported for information only)
  - referenced resource paths (references/, scripts/, assets/, agents/) exist

stdlib only — no PyYAML dependency (frontmatter is parsed minimally). Exit code
0 if all checks pass, 1 otherwise. Intended to be called from skill-forge.

Usage:
    python3 lint_skill.py <path-to-file> [--max-words N]
"""

import argparse
import re
import sys
from pathlib import Path

RESOURCE_RE = re.compile(r"(?:references|scripts|assets|agents)/[\w\-./]+")


def parse_frontmatter(text: str):
    """Return (frontmatter_dict, body_lines) or (None, all_lines)."""
    lines = text.splitlines()
    if not lines or lines[0].strip() != "---":
        return None, lines
    # Find the closing delimiter.
    for i in range(1, len(lines)):
        if lines[i].strip() == "---":
            fm_lines = lines[1:i]
            body_lines = lines[i + 1 :]
            break
    else:
        return None, lines

    fm = {}
    current_key = None
    for line in fm_lines:
        m = re.match(r"^([A-Za-z0-9_-]+):\s*(.*)$", line)
        if m:
            current_key = m.group(1)
            fm[current_key] = m.group(2).strip()
        elif current_key and line.strip():
            # Folded/continued scalar (e.g. description: >-) — append.
            fm[current_key] = (fm[current_key] + " " + line.strip()).strip()
    return fm, body_lines


def lint(path: Path, max_words: int):
    failures = []
    warnings = []

    if not path.is_file():
        return [f"file not found or not readable: {path}"], [], ""

    text = path.read_text(encoding="utf-8")
    fm, body_lines = parse_frontmatter(text)

    if fm is None:
        failures.append("no closed YAML frontmatter block (expected `---` ... `---`)")
        fm = {}

    # name present and matches directory
    name = fm.get("name", "").strip().strip("'\"")
    if not name:
        failures.append("frontmatter missing `name`")
    else:
        parent = path.parent.name
        # For agent files the parent may differ; only enforce for SKILL.md.
        if path.name == "SKILL.md" and name != parent:
            failures.append(
                f"`name` ({name!r}) does not match skill directory ({parent!r})"
            )

    # description present
    desc = fm.get("description", "").strip().strip("'\">-").strip()
    if not desc:
        failures.append("frontmatter missing `description`")
    elif len(desc) < 40:
        warnings.append("`description` is very short — weak triggering signal")

    # Content budget (body only), measured in words — wrapping-invariant, so
    # hard-wrapping prose to 80 cols does not trip it. Physical line count is
    # reported for information only, never as a failure, because it penalizes
    # line-wrapping without reflecting real context/token cost.
    body_words = sum(len(line.split()) for line in body_lines)
    if body_words > max_words:
        failures.append(
            f"body is ~{body_words} words (budget {max_words}); "
            "move detail into references/"
        )
    info = f"body: {len(body_lines)} physical lines, ~{body_words} words"

    # referenced resources exist
    skill_dir = path.parent
    seen = set()
    for ref in RESOURCE_RE.findall(text):
        ref = ref.rstrip(".,);:")
        if ref in seen:
            continue
        seen.add(ref)
        if not (skill_dir / ref).exists():
            warnings.append(f"referenced path does not exist: {ref}")

    return failures, warnings, info


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("path", type=Path, help="path to SKILL.md or agent .md")
    ap.add_argument(
        "--max-words",
        type=int,
        default=6500,
        help="body content budget in words (~500 lines of prose); "
        "wrapping-invariant, unlike a physical-line count",
    )
    args = ap.parse_args()

    failures, warnings, info = lint(args.path, args.max_words)
    if info:
        print(f"\N{INFORMATION SOURCE}  {info}")

    for w in warnings:
        print(f"\N{LARGE YELLOW CIRCLE} warning: {w}")
    for f in failures:
        print(f"\N{LARGE RED CIRCLE} fail: {f}")

    if failures:
        print(f"\nLINT FAILED ({len(failures)} error(s), {len(warnings)} warning(s))")
        sys.exit(1)
    print(f"\N{WHITE HEAVY CHECK MARK} lint passed ({len(warnings)} warning(s))")
    sys.exit(0)


if __name__ == "__main__":
    main()
