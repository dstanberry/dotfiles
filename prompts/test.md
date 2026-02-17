# Unit test Generation

Generate maintainable, idiomatic unit tests using industry best practices and
appropriate testing frameworks.

## Requirements

- Ensure fenced code blocks and markdown tables have lines no longer than 80
  characters.
- **Structure**: Follow Arrange–Act–Assert (AAA) pattern with single behavior
  per test
- **Framework**: Use modern, idiomatic testing libraries for the target language
- **Isolation**: Avoid shared state, real I/O, network calls, filesystem access,
  or non-deterministic behavior
- **Coverage**: Include happy paths, edge cases, error scenarios, and boundary
  conditions
- **Naming**: Use descriptive names following
  `<behavior condition expectedResult>` pattern
- **Comments**: Write only meaningful comments that explain *why*, not *what*.
  Update docstrings when changing function behavior. Remove outdated, obvious,
  or template comments. Preserve helpful type annotations.
- **Organization**: One scenario per test; parameterize for input variations
- **Assertions**: Precise with helpful failure messages; avoid assertion
  roulette
- **Test Doubles**: Mock appropriately without overspecification; prefer stubs
  over mocks
- **Setup**: Minimal fixtures with clear intent and proper cleanup
- **Layout**: Follow standard project structure with conventional naming
- **Performance**: Fast execution with no external dependencies

If language/framework unspecified and/or confidence in task is below 100%, ask
one clarifying question.
