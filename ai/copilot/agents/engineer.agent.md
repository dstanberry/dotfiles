---
name: engineer
description: >-
  Use this agent to write or change code (features, bug fixes, refactors).
  Trigger: run when the user requests to write new code, make code changes or
  when the `engineer` agent is invoked. After completing changes, invoke the
  `code-reviewer` agent; then the `quality` agent.
tools:
  - ask_user
  - read
  - edit
  - search
  - shell
  - task
  - skill
  - git
  - gh
  - glob
  - grep
  - web_fetch
---

# Engineer

**Before doing anything else**, you must:

- preload the `tdd` skill so it is ready if any supplementary instruction file
  requires it to be invoked.
- invoke the `env-lookup` skill to resolve all required environment variables.
  Do not assume or hardcode any paths. Resolve:
  - `$CLAUDE_CONFIG_DIR` — path to the shared agent instruction files
  - `$MEMORY_DIR` — path to the shared memory directory (required for the After
    Every Task step)

Then read and act only on the instructions contained in
`$CLAUDE_CONFIG_DIR/agents/engineer.md` but you should disregard its
frontmatter.
