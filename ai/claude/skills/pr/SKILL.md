---
name: pr
description: >
  Generates, creates, and maintains a Pull Request title and description based
  on branch commits. Use when the user says: "create PR", "open a PR", "generate
  PR description", "write a PR", "update PR description", "review the PR", "PR
  title and description", or "update the PR". PR title follows Conventional
  Commits format. Updates an existing PR when new commits are added or a review
  is requested.
---

# Pull Request

You are managing the Pull Request title and description for the current branch.
Your job is to inspect all commits on the branch, derive a well-formed title and
terse description, and create or update the PR. Do not ask the user to write the
content — write it yourself.

## Scope

**In scope:** inspecting branch commits, deriving PR title and description,
creating a PR with `gh pr create`, updating an existing PR with `gh pr edit`,
reviewing and revising when prompted.

**Out of scope:** merging the PR, requesting reviewers, assigning labels or
milestones unless explicitly asked.

## Modes

Detect the mode from context:

- **Create** — no open PR exists for this branch; user wants to generate title
  and description (and optionally open the PR).
- **Update** — new commits have been added; user wants the title/description
  revised to reflect them.
- **Review** — user asks to review the current PR; check all commits and
  determine whether the title/description still accurately represents the
  branch.

## Workflow

### Shared setup (run for all modes)

1. Run `git branch --show-current` to confirm the current branch name.

2. **If on `main`, `master`, or `develop`:** stop. Tell the user PR descriptions
   are for feature branches, not base branches. Do not proceed.

3. Determine the base branch: run `git remote show origin | grep 'HEAD branch'`
   to find the default remote branch. If that fails, assume `main` and note the
   assumption to the user.

4. Run `git log <base>..HEAD --oneline` to list all commits on this branch.

5. **If there are no commits ahead of base:** stop. Tell the user there are no
   new commits to describe. Do not proceed.

6. Run `git diff <base>..HEAD --stat` for a high-level summary of changed files.

7. Check whether an open PR exists: run
   `gh pr view --json title,body,url 2>/dev/null`.
   - If a PR exists: store the current title and body; proceed to the relevant
     mode.
   - If no PR exists: proceed as **Create** mode regardless of stated mode.

### Create mode

1. Derive the PR title and description (see rules below).

2. Present the title and description to the user and ask whether to open the PR
   now or review the content first.
   - If the user confirms: run `gh pr create --title "<title>" --body "<body>"`
     and show the resulting PR URL.
   - If the user wants to review first: show the content and wait.

### Update mode

1. Re-derive the PR title and description from the full current commit list.

2. Compare to the existing PR title and body. If changes are warranted: run
   `gh pr edit --title "<new title>" --body "<new body>"` and tell the user what
   changed and why.

3. If no changes are warranted: tell the user the current title and description
   still accurately represent the branch and show the existing content.

### Review mode

1. Re-read all commits (`git log <base>..HEAD --oneline`) and the diff stat.

2. Evaluate whether the existing PR title and description accurately represent
   the full set of changes. Check for:
   - New commit types not reflected in the title (e.g., a `fix` added after a
     `feat`-titled PR)
   - Scope drift (changes now span more areas than the title implies)
   - Missing or outdated bullets in the description
   - Breaking changes introduced after the PR was opened

3. If updates are warranted: apply them via `gh pr edit` and explain what
   changed. If no updates are needed: confirm the PR is still accurate and show
   the existing content.

## Title Rules

- Format: `type(scope): description` — Conventional Commits, same as individual
  commits.
- Choose the type that best represents the *dominant* change across all commits.
  When commits span multiple types, use the highest-impact one: breaking >
  feat > fix > refactor > perf > all others.
- Scope: the primary affected area. Omit if the change is truly cross-cutting.
- Description: imperative mood, ≤72 chars, lowercase, no trailing period.
- Breaking change: append `!` (e.g. `feat!:`) if any commit introduces a
  breaking change.

## Description Rules

- Use a short bullet list. No prose paragraphs, no preamble, no "This PR does
  X".
- Each bullet describes one logical change — consolidate related commits into a
  single bullet rather than listing each commit separately.
- Lead with the most significant change.
- If a breaking change exists, call it out explicitly as the first bullet:
  `- **BREAKING:** <what changed and what it breaks>`
- Cap at ~8 bullets. Group minor related changes into one bullet if needed.
- Do not restate the PR title as a bullet.

## Example

**Title:**

```
feat(auth): add OAuth2 login with Google and GitHub
```

**Description:**

```
- Add OAuth2 provider support for Google and GitHub
- Introduce `OAuthProvider` interface for future provider extensibility
- Store OAuth tokens encrypted in the session layer
- Update login UI with provider selection buttons
- Add integration tests for OAuth callback handling
```

## Uncertainty Defaults

- **Ambiguous dominant type** (e.g., equal `feat` and `fix` commits): use `feat`
  if any new capability was added, otherwise `fix`.
- **Can't determine base branch:** assume `main` and note the assumption.
- **`gh` CLI not available:** output the title and description as plain text and
  tell the user to create or update the PR manually.
- **No PR exists and user hasn't confirmed creation:** present the content and
  wait — do not run `gh pr create` without confirmation.
- **Breaking change uncertain:** do not mark it breaking, but flag the
  uncertainty to the user after presenting the content.
