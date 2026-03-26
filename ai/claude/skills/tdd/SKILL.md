---
name: tdd
description:
  Test-driven development with red-green-refactor loop. Use when user wants to
  build features or fix bugs using TDD, mentions "red-green-refactor", wants
  integration tests, or asks for test-first development.
---

# Test-Driven Development

## Philosophy

**Core principle**: Tests verify behavior through public interfaces, not
implementation details. Code can change entirely; tests should not.

**Good tests** exercise real code paths through public APIs. They describe
*what* the system does, not *how* — a good test reads like a specification:
"user can checkout with valid cart." These tests survive refactors because they
are decoupled from internal structure.

**Bad tests** are coupled to implementation: they mock internal collaborators,
test private methods, or verify state through external means. The signal: a test
breaks on refactor, but behavior has not changed.

See [test.md](../../../_shared/test.md) for examples and
[mock.md](../../../_shared/mock.md) for mocking guidelines.

## Anti-Pattern: Horizontal Slices

**Do not write all tests first, then all implementation.** This is "horizontal
slicing" — treating RED as "write all tests" and GREEN as "write all code."

This produces poor-quality tests:

- Tests verify *imagined* behavior and *shape* (signatures, data structures)
  rather than user-facing behavior
- Tests become insensitive to real changes — passing when behavior breaks,
  failing when behavior is fine
- Design is locked in before the implementation is understood

**Correct approach**: Vertical slices via tracer bullets. One test → one
implementation → repeat. Each cycle builds on what was learned from the previous
one.

```text
Incorrect (horizontal):
  RED:   test1, test2, test3, test4, test5
  GREEN: impl1, impl2, impl3, impl4, impl5

Correct (vertical):
  RED→GREEN: test1→impl1
  RED→GREEN: test2→impl2
  RED→GREEN: test3→impl3
  ...
```

## Workflow

### 1. Planning

Before writing any code:

- [ ] Confirm interface changes with the user
- [ ] Confirm which behaviors to test and in what order
- [ ] Identify [deep module](../../../_shared/module.md) opportunities (small
      interface, deep implementation)
- [ ] Design interfaces for [testability](../../../_shared/design.md)
- [ ] List behaviors to test (not implementation steps)
- [ ] Get user approval on the plan

Focus testing effort on critical paths and complex logic — not every possible
edge case. Confirm priorities with the user before writing any code.

### 2. Tracer Bullet

Write one test that confirms one behavior end-to-end:

```
RED:   Write test for first behavior → test fails
GREEN: Write minimal code to pass → test passes
```

This proves the full path works before building out the rest.

### 3. Incremental Loop

For each remaining behavior, repeat:

```
RED:   Write next test → fails
GREEN: Minimal code to pass → passes
```

- One test at a time; only enough code to pass the current test
- Do not anticipate future tests; keep tests focused on observable behavior

### 4. Refactor

After all tests pass, look for
[refactor candidates](../../../_shared/refactor.md):

- [ ] Extract duplication
- [ ] Deepen modules (move complexity behind simple interfaces)
- [ ] Apply SOLID design principles where natural
- [ ] Consider what new code reveals about existing code
- [ ] Run [code analysis](../../../_shared/analysis.md) on the result
- [ ] Run tests after each refactor step

**Never refactor while RED.** Get to GREEN first.

## Checklist Per Cycle

- [ ] Test describes behavior, not implementation
- [ ] Test uses public interface only
- [ ] Test would survive internal refactor
- [ ] Code is minimal for this test
- [ ] No speculative features added
