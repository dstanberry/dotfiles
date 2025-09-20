### Code Refactor

Refactor the code to improve clarity, maintainability, and efficiency without
changing observable behavior or the public API.

#### Scope and Constraints

- Do not change public APIs: exported names, function signatures, return
  types/values, side effects, or I/O behavior.
- Do not add external dependencies.
- Preserve performance characteristics unless there is a demonstrated, material
  issue; note any trade-offs explicitly.

#### Principles

- Favor small, single-responsibility units and early returns over deep nesting.
- Eliminate redundancy (DRY). Extract minimal, reusable helpers only when they
  improve clarity.
- Use intention-revealing names; rename variables, functions, and types when it
  improves understanding.
- Prefer idiomatic language features and standard library APIs over custom
  implementations.
- Prefer linear over quadratic work; short-circuit when possible.
- Remove dead code, unused declarations, and unnecessary assignments. Keep side
  effects explicit.
- Manage resources correctly (close files, release handles, respect
  timeouts/cancellations) and consider thread-safety where applicable.
- Optimize for clarity first; avoid premature micro-optimizations.

#### Error Handling

- Validate inputs and fail fast with clear, actionable errors.
- Distinguish recoverable vs. unrecoverable errors.
- Propagate or log errors; never swallow them silently.
- Preserve existing error types/messages unless they are clearly incorrect; note
  any changes.

#### Documentation and Types

- Keep docstrings/comments accurate, concise, and non-redundant.
- Retain or improve type annotations; remove only if truly obsolete or
  misleading.

#### Language and Style

- Prefer immutability where practical (e.g., const/let over var; final/val;
  immutable collections).
- Prefer composition over inheritance.
- Follow the language’s standard formatting and linting conventions.
- Use pattern matching, null-safe operators, and collection utilities to
  simplify control flow where available.
- Replace long chains and nested loops/conditionals with clearer constructs.

#### Naming

- Use terse, intention-revealing names aligned with domain concepts and data
  semantics.
- Provide a brief mapping of significant renames (old → new).

#### Testing and Regression Safety

- Ensure functional parity; if a behavior change is unavoidable, call it out
  explicitly and explain why.
- Add or modify unit tests only if explicitly requested or if tests were
  provided (e.g., in the workspace); all tests must pass locally.
  - Unit tests must be generated using modern best practices for maintainable
    and effective tests in this language.
  - Follow AAA (Arrange–Act–Assert), ensure test isolation, and use clear
    assertions.
  - Avoid boilerplate comments; keep comments minimal and only where needed to
    explain complex intent.
- Consider edge cases and concurrency if applicable.

#### Deliverables

1. Refactored code.
2. Brief rationale covering:
   - Key changes and motivations.
   - Important renames (old → new).
   - Assumptions, limitations, or TODOs.
   - Any known behavior or performance implications.

#### Clarifications

If any part of the refactor is ambiguous or risky, ask targeted clarifying
questions before proceeding.

#### Checklist (use before finalizing)

- [ ] Behavior unchanged; public APIs stable.
- [ ] Names improved; intent clearer.
- [ ] Redundancy removed; nesting reduced.
- [ ] Robust error handling preserved or improved.
- [ ] Docs/comments and types accurate and helpful.
- [ ] Idiomatic APIs and patterns used.
- [ ] Resources managed correctly; thread-safety considered.
- [ ] Tests updated/added and passing locally.
