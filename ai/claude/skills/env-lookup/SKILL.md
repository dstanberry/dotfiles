---
name: env-lookup
description: >-
  Resolves environment variables, including tool-agnostic abstractions like
  $AI_CONFIG_DIR and $MEMORY_DIR. Use when any skill or agent needs to look up
  an environment variable or resolve a path from the environment.
model: haiku
tools: [Bash]
---

# Environment Variable Lookup

## Platform Detection

Before looking up any variable, determine the platform by running
`uname 2>/dev/null`:

- If output is `Linux` or `Darwin` → **Unix**. Look up variables with
  `printenv <VAR>`. Empty output or non-zero exit means the variable is not set.
- If the command fails or returns nothing → **Windows**. Look up variables with
  `powershell -Command "[System.Environment]::GetEnvironmentVariable('<VAR>')"`.
  Empty output means the variable is not set.

Apply the platform-appropriate command for every lookup throughout this skill.

## Variable Alias Resolution

`$AI_CONFIG_DIR` and `$MEMORY_DIR` are tool-agnostic abstractions that map to
tool-specific variables depending on the executing environment. Before resolving
either, determine which tool is running this skill:

- **GitHub Copilot / GitHub Copilot CLI** → `$AI_CONFIG_DIR` = `$COPILOT_HOME`
- **Claude Code** → `$AI_CONFIG_DIR` = `$CLAUDE_CONFIG_DIR`
- **Unknown tool** → report that `$AI_CONFIG_DIR` cannot be resolved because the
  executing tool could not be identified.

## $AI_CONFIG_DIR

1. Apply the alias resolution above to determine the concrete variable name.
2. Look up the concrete variable using the platform-appropriate command.
3. If not set, report that the variable was not found. If set, return its value.

## $MEMORY_DIR

`$MEMORY_DIR` resolves to the `_memory` directory that is a sibling of the AI
config directory (e.g. if `$AI_CONFIG_DIR` is `/home/user/.config/ai/claude`,
then `$MEMORY_DIR` is `/home/user/.config/ai/_memory`).

1. Apply the alias resolution above to determine the concrete variable for
   `$AI_CONFIG_DIR`.
2. Look up the concrete variable using the platform-appropriate command.
3. If not set, report that `$MEMORY_DIR` could not be resolved because
   `$AI_CONFIG_DIR` is not set.
4. If set, append `/../_memory` to the value and return the result as the value
   of `$MEMORY_DIR`.

## All other variables

Look up the variable using the platform-appropriate command. If not set, report
that `$<VAR>` is not set in the environment. If set, return its value.
