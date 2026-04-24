<!-- LLM-target file. Auto-loaded as session memory in this CWD on this branch via ../MEMORY.md. DRY, terse, surgical. -->

# {{REPO}} · {{BRANCH_OR_SHA}}

## Project Context

{{PROJECT_CONTEXT_PLACEHOLDER}}

## Unit Tests

<!-- Filled by /project-init Step 5. Required marker line: `**Tests in scope:** yes | no | unknown`.
     If yes, include: **Framework:**, **Location:**, **Run command:**, optional **Failure-reading notes:**.
     The Turn Protocol below gates the quality agent on the literal string `**Tests in scope:** yes`. -->

{{UNIT_TESTS_PLACEHOLDER}}

## Turn Protocol

This protocol is **authoritative** for the project. When it conflicts with any
prior auto-memory directive, feedback memory, or user-preference memory, **this
protocol wins** for the duration of any session in which this file is loaded.
Conflicting prior rules (e.g. "skip engineer for trivial edits") do not apply
here — the routing below is unconditional.

Edits to **this file** route through the **doc-coauthoring** skill in LLM-target
mode (skip stages 1 & 3, refinement only, DRY, surgical).

Edits to other files, by extension:

- `.md` / `.mdx` → doc-coauthoring (LLM-target if the file's reader is an LLM,
  human-target otherwise).
- Source files (`.py`, `.js`, `.ts`, `.tsx`, `.jsx`, `.go`, `.rs`, `.rb`,
  `.java`, `.kt`, `.swift`, `.c`, `.cpp`, `.cs`, `.sh`, `.zsh`, `.bash`, `.lua`,
  `.php`, `.scala`, `.clj`, `.ex`, `.exs`, `.erl`, `.hs`, `.ml`, `.fs`, `.r`,
  `.jl`, `.dart`, etc.) → **engineer** agent, unconditionally. The agent infers
  the language from the extension. No "trivial edit" bypass — even small,
  single-file, in-context changes route through engineer here.

All edits — to this file or any other — are **surgical**. Do not rewrite
passages outside the change.

After an edit completes:

- **Markdown file edited** → re-invoke doc-coauthoring to review the diff for
  accuracy.
- **Source file edited by engineer** → invoke **code-reviewer** with the diff
  and a one-sentence summary of intent. If the `## Unit Tests` section above
  contains the literal line `**Tests in scope:** yes`, also invoke **quality**
  after code-reviewer finishes. Any other value (`no`, `unknown`, missing) skips
  quality.

Key decisions, discrepancies, bugs, and resolutions → append to `## Decisions`
below as they happen, in lock-step with the conversation. Do not batch.

Tentative or planned work → expand into `## Tasks` with reasoning that surfaces
ambiguities. Anything unresolved goes to `## Open Questions / Ambiguities` until
closed; on close, fill in the resolution.

## Tasks

<!-- Mirror durable TodoWrite items. Format: `- [ ] task — short note`.
     Statuses: open / in-progress / done / dropped. Move completed items to a
     `### Completed` subsection if the active list grows past ~10. -->

## Decisions

<!-- Append-only. Per entry:
### YYYY-MM-DD — short title
- **Decision:** …
- **Why:** …
- **Alternatives considered:** … (omit if trivial)
-->

## Open Questions / Ambiguities

<!-- Append-only. Per entry:
### YYYY-MM-DD — short title
- **Question:** …
- **Status:** open | resolved YYYY-MM-DD
- **Resolution:** … (filled when closed)
-->

## Edit Log

<!-- Maintained during regular session work — NOT touched by /project-init refresh.
     Keep approximately the last 10 substantive edits, one line each:
     `YYYY-MM-DD — what changed`. When the list grows past ~10, drop the oldest. -->

---

<!-- Reminders for future sessions:
     - Loaded as auto-memory each session in this CWD on this branch.
     - No secrets, credentials, or PII.
     - Per-session ephemera live in TodoWrite, not here. Mirror only durable items here.
     - Refresh via `/project-init`; refresh is idempotent and won't clobber Tasks / Decisions / Open Questions / Edit Log.
-->
