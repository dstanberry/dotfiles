# Interface Design for Testability

Design interfaces so that testing is natural: dependencies injected, results
returned, and surface area minimal.

**1. Accept dependencies, don't create them**

```typescript
// GOOD: dependency is passed in — easy to test
function processOrder(order, paymentGateway) {}

// BAD: dependency created internally — hard to test
function processOrder(order) {
  const gateway = new StripeGateway();
}
```

**2. Return results, don't produce side effects**

```typescript
// GOOD: returns a value — easy to assert
function calculateDiscount(cart): Discount {}

// BAD: mutates state — harder to observe
function applyDiscount(cart): void {
  cart.total -= discount;
}
```

**3. Keep surface area small**

- Fewer methods = fewer tests needed
- Fewer params = simpler test setup
