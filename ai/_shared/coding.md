# Coding Standards

Language-agnostic standards for writing clear, safe, and maintainable code.

## Naming

Names should make comments unnecessary. Prefer self-documenting identifiers over
abbreviated or generic ones.

- Use names that reveal intent: `retryCount` not `n`, `isExpired` not `flag`
- Avoid misnomers — a name that contradicts behavior is worse than a vague one
- Boolean names should read as assertions: `isReady`, `hasPermission`,
  `canRetry`
- Functions should be named for what they return or do, not how they do it

## Comments

Use comments to convey intent, not mechanics. Explain *why*, not *what*.

```python
# GOOD: explains why
# Retry up to 3 times — the upstream service has transient failures at startup
for attempt in range(3):
    ...

# BAD: restates the code
# Loop 3 times
for attempt in range(3):
    ...
```

Use analogies only when they genuinely clarify — never as decoration.

## Types

Use the type system as documentation and as a first line of defense.

- **Strongly typed languages** (TypeScript, Go, Rust, C#, Java, Kotlin, Swift):
  use explicit types everywhere; avoid `any`, `object`, or equivalent escape
  hatches
- **Dynamically typed languages** (Python, Ruby): use type hints/annotations
  where supported; annotate function signatures at minimum
- Model domain concepts as types — prefer `UserId` over bare `string` where the
  distinction matters

## Input Validation

Validate at trust boundaries: API endpoints, CLI entry points, config loading,
and any data crossing a process boundary.

- Reject invalid input early with a clear, actionable error message
- Do not validate the same input at multiple internal layers — validate once at
  the entry point, then trust it internally
- Distinguish missing vs. malformed vs. out-of-range inputs in error messages

## Secrets

Never hard-code secrets, credentials, or environment-specific values in source
code.

- Use environment variables or `.env` files (excluded from version control)
- Fail fast with a clear error on startup if a required secret is absent
- Use a secrets manager (Vault, AWS Secrets Manager, etc.) for production
  workloads

## Function Design

- Target ~50 lines per function; extract helpers when a function grows beyond
  this or handles more than one responsibility
- Keep cyclomatic complexity below 10 — if a function has more than ~10
  branches, break it apart
- Follow SOLID principles, especially Single Responsibility and Dependency
  Inversion; functional codebases benefit from these too
- Prefer pure functions where practical — easier to test, reason about, and
  reuse

## Error Handling

Detect errors early and surface them with clear context.

- Fail fast: validate preconditions at the start of a function
- Error messages should state what went wrong, where, and ideally how to fix it
- Do not swallow exceptions silently — log or propagate with context
- Distinguish recoverable errors (retry, fallback) from unrecoverable ones
  (crash with a clear message)

## Contracts

Keep code and its contracts in sync. When a function signature, API route,
schema, or data model changes, update the following as part of the same change:

- OpenAPI / AsyncAPI specs
- Type definitions and interfaces
- Docstrings and inline documentation
- SQL migrations and ORM models
- Dependent tests
