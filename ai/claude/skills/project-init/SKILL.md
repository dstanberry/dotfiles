---
name: project-init
description: >-
  Scaffold or refresh a project- and branch-specific session memory file that
  captures turn protocol, current task list, decisions log, and open ambiguities
  for the current git repo. The file is written to the session's auto-memory
  directory and indexed in MEMORY.md so it auto-loads on future sessions in the
  same CWD on the same branch. Trigger when the user types `/project-init`, asks
  to "set up this project/branch", "kick off work on this repo", "init project
  memory", "scaffold this workspace", "create a session memory file for this
  branch", or otherwise asks for branch-scoped persistent memory and turn
  protocol. Trigger eagerly when the user is starting fresh work in a repo and
  wants per-branch memory across sessions, even without naming the skill
  explicitly. Do NOT trigger on session open or on a fresh session by itself —
  this skill is opt-in.
---

# Project Init

Scaffold (or refresh) a per-branch memory file under the current session's
auto-memory directory and index it in `MEMORY.md` so it auto-loads on future
sessions in the same CWD on the same branch. Once the file is loaded, its **Turn
Protocol** section governs how subsequent edits are routed.

The skill is **opt-in**. It only fires on the slash command or close paraphrases
— never automatically at session start.

## Precedence

The Turn Protocol that this skill writes into the memory file is
**authoritative** for any project where it is installed. When it conflicts with
a prior auto-memory directive, feedback memory, or general preference (for
example, a feedback memory that says "skip engineer for trivial edits"), the
project's Turn Protocol wins for the duration of any session in which the file
is loaded.

The canonical precedence wording lives in **`assets/memory-template.md`** inside
the `## Turn Protocol` section — that paragraph (starting "This protocol is
**authoritative**…") is what gets written into user files. This `## Precedence`
section in SKILL.md is meta-documentation about why the skill behaves this way;
do not compare it against the template during drift detection. Drift detection
in Step 4b compares the user's file's `## Turn Protocol` against the template's
`## Turn Protocol`, nothing else.

On refresh (Step 4b), confirm the canonical precedence paragraph is present in
the user's file and surgically restore it if missing.

## What the user might pass on invocation

Any of these are optional:

- A signal that the project does or doesn't have unit tests (e.g. "Python
  project with pytest at `tests/unit`"). If absent, Step 5 resolves testing
  details (CLAUDE.md → light probe → questionnaire).
- Specific directives to fold into the Turn Protocol or Project Context.

The user does **not** supply a file name. The filename is always git-derived
(Step 2a). If git is unavailable or the CWD is not in a git repo, Step 1 aborts
loudly and nothing is written.

If the user said nothing extra, proceed with git-derived naming and ask only the
questions Step 5 actually needs.

## Step 0 — verify caller

Before doing anything, confirm the skill is running inside Claude Code. Invoke
`env-lookup` to resolve `$AI_CONFIG_DIR`.

- If `AI_CONFIG_DIR` is set and resolves to a non-empty path → proceed to Step 1.
- If `AI_CONFIG_DIR` is unset or empty → print exactly one line:
  `project-init requires Claude Code — skipping.`
  Then stop. Do not probe git, do not write any files, do not ask the user
  anything.

This guard exists because project-init depends on Claude Code's auto-memory
system (session memory files, MEMORY.md indexing). Those mechanisms are absent
in other environments that load the same skill set (e.g. GitHub Copilot CLI),
so running there would silently write files that nothing ever reads.

## Step 1 — probe git state once

One probe up front, in a single shell call. Capture all four values:

```bash
git rev-parse --show-toplevel 2>/dev/null     # repo_root  (worktree path)
git rev-parse --git-common-dir 2>/dev/null    # common_dir (real .git location, may be a bare repo)
git rev-parse --abbrev-ref HEAD 2>/dev/null   # branch     ("HEAD" if detached)
git rev-parse --short HEAD 2>/dev/null        # short_sha  (used when detached)
```

Outcomes:

- **In a git repo, on a named branch.** Step 2a derives the project name
  (worktree-aware — see below) and uses `branch`.
- **Detached HEAD** (`branch == "HEAD"` or empty). Project name as above; use
  `short_sha` instead of branch.
- **Not a git repo (or git missing)** — both `repo_root` and `common_dir` empty.
  **Abort loudly.** Tell the user verbatim: "/project-init requires a git
  repository. The current working directory is not inside one (or git is
  unavailable). No file was created and nothing was changed." Do not write
  anything. Do not ask for a fallback name. Stop.

## Step 2a — derive the filename (git available)

### Project name — worktree-aware

`basename(repo_root)` is wrong when the user is in a **worktree of a bare or
separate git directory**. In that case, `repo_root` is the worktree path (often
something like `~/.config` or `~/checkouts/foo-feature`), but the project's real
identity is the bare repo at `common_dir`. Multiple worktrees of the same bare
repo would otherwise produce different filenames even though they belong to the
same project.

```
if common_dir == "${repo_root}/.git" or common_dir == ".git":
    project_name = basename(repo_root)            # normal repo
else:
    name = basename(common_dir)
    if name.endswith(".git"):
        name = name[:-4]                          # strip ".git" suffix on bare repos
    project_name = name                            # worktree of a bare/separate repo
```

Examples:

- Normal repo `~/projects/myapp`
  (`common_dir == ~/projects/myapp/.git`) → `project_name = "myapp"`.
- Worktree at `~/.config` of bare repo at `~/repos/dotfiles`
  (`common_dir == ~/repos/dotfiles`) → `project_name = "dotfiles"`.
  **Not** `config`.
- Worktree of bare repo at `/srv/repos/myapp.git` → `project_name = "myapp"`
  (the `.git` suffix is stripped).

### Filename

```
filename = sanitize(project_name) + "-" + sanitize(branch_or_sha) + ".md"
```

Sanitization — the stem must match `^[A-Za-z0-9_-]+$`:

- Replace `/`, ` `, `.`, `\`, and any other non-`[A-Za-z0-9_-]` character with
  `-`.
- Collapse runs of `-` into one.
- Strip leading and trailing `-`.
- Cap stem length at 80 chars. If the combined stem exceeds 80, truncate the
  branch portion first, keeping its trailing characters (so the branch identity
  stays recognisable). If `project_name` alone exceeds 80, truncate it from the
  right and drop the branch portion; warn the user the project name was
  truncated.

Examples:

- Normal repo `~/projects/myapp`, branch `main` → `project_name=myapp` →
  `myapp-main.md`
- Normal repo `~/projects/myapp`, branch `feature/oauth-rewrite` →
  `myapp-feature-oauth-rewrite.md`
- Normal repo `~/projects/dotfiles`, detached at `abc1234` → `dotfiles-abc1234.md`
- Normal repo `~/projects/My App`, branch `bugfix/utf-8` →
  `project_name=My App → My-App` → `My-App-bugfix-utf-8.md`
- **Worktree** at `~/.config` of bare repo `~/repos/dotfiles`, branch `main` →
  `project_name=dotfiles` → `dotfiles-main.md` (not `config-main.md`)

If sanitization yields an empty stem (e.g. `project_name` is entirely
non-alphanumeric), abort loudly per Step 1's failure protocol — do not fall back
to a user-provided name. Tell the user the project name sanitises to empty and
ask them to rename the repo or worktree dir.

## Step 3 — locate the memory directory

The target dir is the directory that already holds the session's auto-memory
`MEMORY.md`. Identify it from the system prompt's auto-memory section — look for
the `Contents of <path>/MEMORY.md` line. That path is authoritative.

Fallback if the path isn't visible: derive from
`${CLAUDE_CONFIG_DIR:-$HOME/.config/ai/claude}/projects/<encoded-cwd>/memory/`,
where `<encoded-cwd>` is the current working directory with `/` and other
non-`[A-Za-z0-9_-]` characters replaced by `-`. Create the directory if missing.

### Subdirectory note (no blocking)

Auto-memory is keyed by **session CWD**, not by git root. If the session's CWD
differs from the git project root, **do not block** the user — proceed with
scaffolding and surface the implication in Step 7's final report so the user
understands the loading behavior. Do not pop a confirmation dialog. The CWD≠root
case is suboptimal (file only auto-loads from the exact CWD), not dangerous; the
user can re-run `/project-init` from the project root later if they want broader
auto-loading.

Record `cwd_is_git_root: true|false` and the actual `cwd` for use in Step 7.

## Step 4 — file existence branching

### Step 4a — file does not exist (fresh scaffold)

1. Read `assets/memory-template.md` from this skill's directory. If it can't be
   read (missing/permissions), abort and tell the user the skill is broken — do
   not attempt to reconstruct the template inline.
2. Substitute the header tokens (`{{REPO}}`, `{{BRANCH_OR_SHA}}`) using the git
   probe values from Step 1.
3. Write the substituted template to `<memory-dir>/<filename>` with the content
   placeholders (`{{PROJECT_CONTEXT_PLACEHOLDER}}`,
   `{{UNIT_TESTS_PLACEHOLDER}}`) intact — those are filled by prompt-engineer
   next.
4. Gather Step 5 inputs (testing details — light probe → confirmation, or
   questionnaire fallback).
5. Invoke prompt-engineer once per token — first for
   `{{PROJECT_CONTEXT_PLACEHOLDER}}`, then for `{{UNIT_TESTS_PLACEHOLDER}}` —
   see "Invoking prompt-engineer" below for the concrete contract per call. The
   `## Unit Tests` payload must produce the structured marker
   `**Tests in scope:** yes | no | unknown` (plus optional details). The Turn
   Protocol's quality-agent gate reads that marker.
6. Index the file in `MEMORY.md` (Step 6).

### Step 4b — file exists (refresh)

1. Read the existing file.
2. Compare its **Turn Protocol** section, including the **Precedence** paragraph
   at the top of that section, against the canonical block in
   `assets/memory-template.md` (string-equality, modulo leading/trailing
   whitespace and blank lines). If drifted, surgically update only the drifted
   lines via prompt-engineer (review mode). Do not rewrite passages that match.
3. **Do not re-ask Unit Tests on refresh.** Whatever value the section currently
   holds (`yes`, `no`, `unknown`) stays. If the section is entirely missing
   (file was hand-edited and lost it), surgically restore the heading + body
   `**Tests in scope:** unknown` via prompt-engineer (review mode). Do not run
   the light probe or questionnaire here — the user can update tests scope later
   by saying so.
4. **Do not touch** `Tasks`, `Decisions`, `Open Questions / Ambiguities`, or
   `Edit Log` on refresh. These sections are owned by regular session work and
   accumulate across runs.
5. If `MEMORY.md` doesn't already index this file, add the entry (Step 6).
6. Tell the user what changed in one or two sentences (or "no changes needed").
   Do not append the precedence note from Step 7 on refresh — that's only for
   fresh scaffolds.

## Step 5 — establish testing details (fresh scaffold only)

This step runs on **fresh scaffold (Step 4a) only**. Refresh (Step 4b) never
touches Unit Tests.

Decision tree, in order — stop at the first branch that produces an answer:

### 5.1 — User specified on invocation

Use those details verbatim. Skip to "Format the output" below.

### 5.2 — `CLAUDE.md` exists at git root

Read it. Extract: framework, test location, run command, failure-reading notes.
Quote the exact lines you relied on so the user can correct any mistake. Present
a one-shot confirmation:

> "From `CLAUDE.md`: tests appear to use `<framework>` at `<location>`, run
> command `<cmd>`. Confirm or correct?"

Wait for an explicit user reply. If they confirm or correct, proceed.

### 5.3 — Light filesystem probe at git root

Only when 5.1 and 5.2 didn't produce an answer. Probe these indicators
(read-only, time-bounded — single shell call):

- `pytest.ini`, `pyproject.toml` (look for `[tool.pytest]` or
  `[project] testpaths`), `setup.cfg` `[tool:pytest]`, `tox.ini`, `conftest.py`
  → pytest.
- `package.json` with a `scripts.test` entry → infer runner from the script
  (`jest`, `vitest`, `mocha`, `ava`, `npm test`).
- `jest.config.{js,ts,mjs,cjs,json}`, `vitest.config.{js,ts}` → that runner.
- `go.mod` plus any `**/*_test.go` → `go test ./...`.
- `Cargo.toml` plus a `tests/` directory → `cargo test`.
- `Gemfile` mentioning `rspec` → RSpec.
- `build.gradle{,.kts}` / `pom.xml` → Gradle/Maven test target.
- `composer.json` with `phpunit` → PHPUnit.
- `mix.exs` with `:ex_unit` → ExUnit.

If indicators are found, present findings to the user with a one-shot
confirmation:

> "Light probe found: `<indicator files>`. Looks like `<framework>` with tests
> at `<location>`. Run command guess: `<cmd>`. Confirm, correct, or say 'no
> tests' if these aren't actually wired up."

Wait for the user reply. Treat any of these responses as terminal:

- "confirm" / "yes" / "looks right" → record as-is.
- A correction → record the correction.
- "no tests" → record `**Tests in scope:** no`.

### 5.4 — Probe found nothing → ask once

A single message with all the parts in one go (do not chain five questions):

> "Light probe didn't find test infrastructure. Quick: does this project have
> unit tests? If yes, give me framework + test location + run command in one
> line. If no, just say 'no'."

Record whatever the user replies. If "no", record `**Tests in scope:** no`. If
yes, record the structured fields. If the user is unsure, record
`**Tests in scope:** unknown`.

### Format the output

Produce the structured marker that the Turn Protocol gates on, plus optional
details:

```
**Tests in scope:** yes
**Framework:** pytest
**Location:** tests/
**Run command:** pytest tests/
**Failure-reading notes:** (optional)
```

Or for projects without tests:

```
**Tests in scope:** no
```

Hand this to prompt-engineer as the source for the `{{UNIT_TESTS_PLACEHOLDER}}`
substitution in Step 4a item 5.

## Step 6 — index the file in MEMORY.md

If `<memory-dir>/MEMORY.md` does not exist, create it with this seed content
(single H1, blank line):

```
# Memory Index

```

Then append the index entry.

Use this format **unconditionally** — auto-memory needs file-link form to load
the file:

```
- [<repo> · <branch-or-sha>](<filename>) — session memory: turn protocol, tasks, decisions
```

Do not "match the existing style" of MEMORY.md if it uses a different form for
other entries — those entries serve different purposes (anchored sections within
MEMORY.md itself, etc.). project-init's entry is always file-link form so
auto-memory can resolve the link.

Idempotency rules:

- If the exact line already exists, leave it. No-op.
- If a line exists for the same `<filename>` but the description tail differs,
  edit that line surgically with the **Edit** tool — *not* prompt-engineer. A
  one-line index update is below the threshold for the refinement workflow.
- Never reorder unrelated lines.
- Never append duplicate entries (same `<filename>`).

## Step 7 — confirm

Report to the user, terse:

- The file path.
- Whether scaffolded fresh or refreshed (and a one-line summary of what changed
  if refreshed; "no changes needed" is fine).
- Where testing details came from (user / `CLAUDE.md` / light probe /
  questionnaire / `no tests`). On refresh, omit this — Unit Tests was not
  touched.
- Auto-load reminder: "Future sessions in `<cwd>` on `<branch-or-sha>` will load
  this file via auto-memory; its Turn Protocol governs edits from then on."
- **If `cwd_is_git_root: false`**, append: "FYI your CWD `<cwd>` is a
  subdirectory of git root `<root>`. This file will only auto-load when Claude
  Code is opened from `<cwd>`, not from `<root>` or sibling subdirs. Re-run
  `/project-init` from `<root>` if you want broader auto-loading."
- **On fresh scaffold only** (not on refresh), append: "Note: this project's
  Turn Protocol is authoritative — it supersedes any prior feedback memory or
  auto-memory directive (including the 'skip engineer for trivial edits' rule)
  for the duration of any session in this project. All source-file edits route
  through engineer here, no exceptions."

## Invoking prompt-engineer

When invoking prompt-engineer from this skill, pass these fields concretely (not
just hand-wavy intent):

- **File path** — absolute path to the memory file being edited.
- **Mode** — `create` (writing new content for a `{{TOKEN}}`) or `review`
  (auditing and fixing an existing section for drift or restoration).
- **Target** — the exact `{{TOKEN}}` to replace, or the exact `## Heading` to
  operate on.
- **Source material** — the source text prompt-engineer should use, inline.
  CLAUDE.md excerpts go in verbatim with quote markers; user questionnaire
  answers go in as a structured list; for Unit Tests, pass the structured marker
  block from Step 5's "Format the output".
- **Audience note** (verbatim, every call):

  > Target audience: an LLM (Claude) reading this file as auto-memory at session
  > start — **not** a human reader. Use only the source material provided — do
  > not ask clarifying questions. Optimize for: DRY, terseness, brevity,
  > scannable headings, no narrative prose. Edits must be **surgical** — do not
  > rewrite sections that aren't part of the requested change.

- **Failure handling** — if prompt-engineer fails, returns errors, or asks its
  own clarifying questions you don't have answers to, **abort** the project-init
  invocation. Leave any partially-written file in place. Tell the user:
  "prompt-engineer failed at <step>. Memory file is at <path>; some sections may
  be partial. Want me to retry, or finish manually?"

Direct `Write` and `Edit` on the memory file are reserved for:

1. Laying down the initial template skeleton in Step 4a (Write only).
2. Updating the one-line index entry in `MEMORY.md` (Edit only).
3. Creating `MEMORY.md` itself if it doesn't exist (Write only, seed content per
   Step 6).

Every substantive content change to the memory *body* goes through
prompt-engineer.

## Things to avoid

- Auto-firing on session open. The skill is opt-in.
- Clobbering Tasks / Decisions / Open Questions / Edit Log on refresh — that's
  durable session state.
- Inventing project facts. If `CLAUDE.md` and `README.md` are silent and the
  user hasn't said, ask.
- Writing secrets, credentials, or PII into the memory file.
- Storing per-session ephemera (e.g., "currently reading X") — those go in
  TodoWrite, not here. Mirror only durable items.
- Running prompt-engineer's full Create workflow (context gathering +
  brainstorming + reader testing) on memory file content. The audience note
  above scopes it to surgical, LLM-optimized edits only.

## Bundled resources

- `assets/memory-template.md` — the canonical scaffold. Read it on every
  scaffold (Step 4a) and every drift comparison (Step 4b).
