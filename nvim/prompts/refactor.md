### Code Refactor

Refactor code to improve clarity, maintainability, and efficiency while
preserving observable behavior and public APIs.

#### Core Constraints

- Do not change public APIs: exported names, function signatures, return
  types/values, side effects, or I/O behavior.
- Do not add external dependencies.
- Preserve performance characteristics; note any trade-offs explicitly.
- Ensure functional parity; explicitly call out unavoidable behavior changes
- If any refactoring aspect is ambiguous or risky, ask targeted clarifying
  questions before proceeding

#### Refactoring Principles

**Structure & Design:**

- Favor small, single-responsibility units and early returns over deep nesting
- Eliminate redundancy (DRY); extract reusable helpers only when they improve
  clarity
- Prefer composition over inheritance
- Prefer idiomatic language features and standard library over custom
  implementations
- Use pattern matching, null-safe operators, and collection utilities to
  simplify control flow simplify control flow
- Replace long chains and nested loops/conditionals with clearer constructs
- Prefer concise expressions over verbose if-else blocks when readability is
  maintained (e.g., ternary operators, logical short-circuiting)

**Performance & Resource Management:**

- Prefer linear over quadratic algorithms; short-circuit when possible
- Manage resources correctly (close files, release handles, respect
  timeouts/cancellations)
- Consider thread-safety where applicable
- Optimize for clarity first; avoid premature micro-optimizations

**Code Quality & Maintainability:**

- Remove dead code, unused declarations, and unnecessary assignments
- Keep side effects explicit
- Use intention-revealing names for variables, functions, and types
- Follow language's standard formatting and linting conventions
- Prefer immutability where practical (const/let, final/val, immutable
  collections)

**Documentation & Comments:**

- Write only meaningful comments that explain *why*, not *what*
- Update docstrings when changing function behavior
- Remove outdated, obvious, or template comments
- Keep docstrings/comments accurate, concise, and non-redundant
- Retain or improve type annotations; remove only if obsolete or misleading

#### Naming Conventions

- Use terse, intention-revealing names aligned with domain concepts
- Follow explicit naming/style instructions in task/repository (highest
  priority)
- If none exist, infer prevailing conventions from active file and project
- Maintain consistency with language ecosystem best practices
- Provide brief mapping of significant renames (old → new)

#### Error Handling

- Validate inputs and fail fast with clear, actionable errors
- Distinguish recoverable vs. unrecoverable errors
- Propagate or log errors; never swallow them silently
- Preserve existing error types/messages unless clearly incorrect; note changes

#### Testing and Regression Safety

- Add/modify unit tests only if explicitly requested or tests were provided
- All tests must pass locally and follow modern best practices:
  - Use AAA (Arrange–Act–Assert) pattern with test isolation
  - Clear assertions with minimal boilerplate comments
- Consider edge cases and concurrency where applicable

#### Deliverables

1. Refactored code
2. Brief rationale covering:
   - Key changes and motivations
   - Important renames (old → new)
   - Assumptions, limitations, or TODOs
   - Known behavior or performance implications

#### Final Checklist

- [ ] Behavior unchanged; public APIs stable
- [ ] Names improved; intent clearer
- [ ] Redundancy removed; nesting reduced
- [ ] Robust error handling preserved or improved
- [ ] Documentation, comments, and types accurate and helpful
- [ ] Idiomatic APIs and patterns used
- [ ] Resources managed correctly; thread-safety considered
- [ ] Tests updated/added and passing locally
