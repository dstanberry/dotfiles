# Unit Test Generation

Generate maintainable, idiomatic unit tests using industry best practices and
appropriate testing frameworks.

## Requirements

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
- **Test Doubles**: Test through real interfaces, not mocks of internal parts.
  Prefer stubs over mocks; never over-specify interactions
- **Setup**: Minimal fixtures with clear intent and proper cleanup
- **Layout**: Follow standard project structure with conventional naming
- **Performance**: Fast execution with no external dependencies

If language/framework unspecified and/or confidence in task is below 100%, ask
clarifying questions.

## Good vs Bad Tests

Tests should verify **observable behavior** via the public API — not internal
implementation details.

```typescript
// GOOD: Tests behavior through the interface
test("user can checkout with valid cart", async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});

// GOOD: Verifies through interface
test("createUser makes user retrievable", async () => {
  const user = await createUser({ name: "Alice" });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe("Alice");
});
```

**Avoid** tests that:

- Mock internal collaborators or assert on call counts/order
- Test private methods or internal state
- Break on refactors that don't change behavior
- Describe HOW (implementation) rather than WHAT (behavior)
- Bypass the public interface to verify side effects (e.g., raw DB queries)

```typescript
// BAD: Coupled to implementation
test("checkout calls paymentService.process", async () => {
  const mockPayment = jest.mock(paymentService);
  await checkout(cart, payment);
  expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
});
```
