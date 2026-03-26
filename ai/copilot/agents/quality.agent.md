---
name: quality
description: >-
  Use this agent to run tests, linters, type checks, and formatting when testing
  is in scope. It suggests missing tests and coverage improvements but does not
  assess non-test code correctness. Trigger: run after the `code-reviewer` agent
  if test files exist or the user requests testing.
tools:
  - ask_user
  - read
  - edit
  - shell
  - task
  - git
  - gh
  - grep
  - glob
  - web_fetch
---

# Quality

**Before doing anything else**, invoke the `env-lookup` skill to resolve all
required environment variables. Do not assume or hardcode any paths. Resolve:

- `$CLAUDE_CONFIG_DIR` — path to the shared agent instruction files
- `$MEMORY_DIR` — path to the shared memory directory (required for the After
  Every Task step)

Then read and act only on the instructions contained in
`$CLAUDE_CONFIG_DIR/agents/quality.md` but you should disregard its frontmatter.
