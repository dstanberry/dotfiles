---
name: code-review
description:
  Code review best practices. Use when user wants to review code, asks for code
  review checklist, or mentions "code review."
context: fork
agent: code-reviewer
argument-hint: "[file(s)]"
---

# Perform a Code Review

If $ARGUMENTS are provided, perform a thorough code review of the specified
file(s). If no arguments are provided, perform a comprehensive code review:

- If files are mentioned in the conversation, review those.
- Otherwise, use `git` to identify recently changed files and review those.
- If that fails, ask the user to specify which files to review.
