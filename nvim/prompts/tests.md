### Unit Test Generation

Generate maintainable, idiomatic unit tests for the provided code.

#### Quick Checklist

- [ ] Apply Arrange–Act–Assert (AAA) with clear visual separation.
- [ ] Use the modern, idiomatic testing framework and mocking/faking tools for
      the language.
- [ ] Ensure strict test isolation (no shared mutable state, no real
      I/O/network/clock).
- [ ] Keep tests deterministic (control time and randomness).
- [ ] Write clear, behavior‑focused assertions with helpful failure messages.
- [ ] Prefer one behavior per test; parameterize to reduce duplication.
- [ ] Use descriptive test names (behavior — condition — expected result).
- [ ] Cover happy paths, edge cases, and error scenarios.
- [ ] Output only test code, organized per standard project layout.

#### Scope and Constraints

- Do not change the public API of the code under test.
- Avoid external services/resources; use in‑process doubles.
- Keep tests fast, isolated, and repeatable.

#### Framework and Tooling

- Use the de facto standard testing and mocking libraries for the specified
  language/version.
- If the language/framework/version is not specified, ask one clarifying
  question before proceeding.

#### Arrange–Act–Assert

- Arrange: set up inputs, collaborators, state, and fakes.
- Act: invoke a single unit of behavior.
- Assert: verify outcomes using precise, intention‑revealing assertions.

#### Isolation and Test Doubles

- No real network, filesystem, environment, clock, or randomness.
- Use fakes/stubs/mocks/spies as appropriate; avoid overspecifying behavior.
- Clean up with fixtures/setup/teardown to prevent state leakage.

#### Assertions

- Prefer high‑level, behavior‑centric assertions over internal state inspection.
- Include helpful failure messages where the framework does not provide them.
- Assert both positive and negative expectations when it clarifies behavior.

#### Structure and Naming

- One logical scenario per test; multiple assertions allowed within that
  scenario.
- Use descriptive names: what — when — then (or equivalent style for the
  framework).
- Group related cases using parameterized tests or table‑driven tests.

#### Coverage

- Include success paths, boundary/edge cases, and error/failure conditions.
- Exercise important branches and exceptional paths without duplicating trivial
  checks.

#### Determinism and Time

- Control time via injection or clock/fake timers.
- Seed or stub randomness to ensure repeatable outcomes.

#### Data and Fixtures

- Prefer minimal, intention‑revealing data builders/factories over verbose
  setup.
- Keep fixtures local to the tests that need them; avoid global mutable
  fixtures.

#### Output

- Return only the test code.
- Use conventional filenames and directories for the chosen framework.
- Include any minimal helpers, builders, or test doubles required by the tests.

#### Clarifications

- If required information is missing (language, framework, version, runtime),
  ask a single targeted question before generating tests.

#### Final Checklist (use before returning)

- [ ] AAA is clear; no shared state between tests.
- [ ] Tests are deterministic; time/randomness controlled.
- [ ] Assertions are precise and readable.
- [ ] Names and structure convey intent.
- [ ] Coverage includes happy path, edges, and errors.
- [ ] Output contains only test code and necessary minimal
