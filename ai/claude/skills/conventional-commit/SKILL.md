---
name: conventional-commit
description: >-
  Autonomously generates and executes a conventional commit. Use when the user
  says: "commit", "make a commit", "conventional commit", "/commit", or "commit
  my changes". Inspects staged/unstaged changes, derives the correct type and
  scope, writes a Conventional Commits-compliant message, and runs `git commit`
  without the user needing to write the message manually.
---

# Conventional Commit

You are executing a conventional commit on behalf of the user. Your job is to
inspect the repository state, derive a well-formed commit message, and run the
commit autonomously. Do not ask the user to write the message — write it
yourself.

## Scope

**In scope:** running git inspection commands, deriving the commit message,
executing `git commit`.

**Out of scope:** pushing to remote, amending prior commits, running `git add`
unless the user explicitly asks you to stage changes.

## Workflow

Execute these steps in order:

1. Run `git status` to identify staged, unstaged, and untracked files.

2. **If there is nothing staged and nothing modified:** stop. Tell the user
   there is nothing to commit. Do not proceed further.

3. **If files are modified but nothing is staged:** ask the user whether to
   stage all changes (`git add -A`), specific files, or only already-staged
   changes. Wait for their response before continuing.

4. Run `git diff --cached` to inspect staged changes. If the user asked you to
   stage everything in step 3, run `git diff HEAD` instead.

5. Derive the commit message components from the diff:
   - **type** — choose the single most accurate type from the table below.
   - **scope** — identify the affected module, package, or area (e.g. `auth`,
     `parser`, `ui`, `deps`). Omit scope only if the change is genuinely
     cross-cutting with no single dominant area.
   - **description** — one short imperative phrase, ≤72 chars, lowercase, no
     trailing period. Use imperative mood: "add", "fix", "remove" — not "added",
     "fixes", "removed".
   - **body** — include when the change is non-obvious, the *why* is not clear
     from the description, or the approach needs context for future readers.
   - **footer** — include when there is a breaking change
     (`BREAKING CHANGE: ...`) or the commit closes a tracked issue
     (`Closes #123`).
   - **Breaking change** — append `!` after type/scope (e.g. `feat!:`) AND add
     `BREAKING CHANGE: <explanation>` in the footer.

6. Construct the commit message as a plain string in this format:

   ```
   type(scope): description

   Optional body paragraph(s).

   Optional footer lines.
   ```

7. Run `git commit`. Use multiple `-m` flags when body or footer are present:
   - Subject only:

     ```bash
     git commit -m "type(scope): description"
     ```

   - With body and/or footer:

     ```bash
     git commit -m "type(scope): description" -m "Body text." -m "Footer: value"
     ```

8. Show the user the resulting commit hash and message.

## Type Definitions

| Type       | When to use                                                   |
| ---------- | ------------------------------------------------------------- |
| `feat`     | A new feature or capability visible to users or consumers     |
| `fix`      | A bug fix                                                     |
| `docs`     | Documentation only — no production code changes               |
| `style`    | Formatting, whitespace, semicolons — zero logic changes       |
| `refactor` | Code restructuring: no behavior change, no bug fix            |
| `perf`     | A change that measurably improves performance                 |
| `test`     | Adding or correcting tests only                               |
| `build`    | Build system, scripts, tooling, or dependency changes         |
| `ci`       | CI/CD pipeline or workflow configuration changes              |
| `chore`    | Maintenance tasks that don't fit any other type               |
| `revert`   | Reverting a prior commit (reference the reverted SHA in body) |

## Examples

```
feat(auth): add OAuth2 login with Google
fix(parser): handle empty array input
docs: update README with installation steps
refactor(api): extract request validation into middleware
chore(deps): upgrade lodash to 4.17.21
feat!: require API key on all endpoints

BREAKING CHANGE: unauthenticated requests now return 401 instead of 200
```

## Uncertainty Defaults

- **Ambiguous type** (e.g., `refactor` vs `perf`): pick the most accurate one
  and briefly state your reasoning in the body.
- **No clear scope**: omit scope rather than inventing one.
- **Large diff spanning multiple concerns**: use the dominant change type; note
  secondary changes in the body.
- **Unsure if a change is breaking**: do not mark it breaking, but flag the
  uncertainty to the user after committing.
- **Not in a git repository**: stop immediately and tell the user.
