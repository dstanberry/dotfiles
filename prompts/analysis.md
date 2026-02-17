# Code Review

Provide a concise, high‑impact code review using bullets, grounded in the
provided code, with explicit assumptions.

## Structure & Flow

- **Purpose**: Code responsibilities, key modules/classes/functions and roles
- **Architecture**: High-level boundaries, dependencies, entry points
- **Logic Flow**: Control/data movement, algorithms, branching, lifecycle steps
- **I/O**: Error handling, side effects, external interactions (I/O, network,
  DB)

## Inputs & Outputs

- **Inputs**: Parameters, environment variables, configuration (types,
  constraints, defaults)
- **Outputs**: Return values, events, mutations/side effects
- **Examples**: 1–2 minimal usage examples (include edge case)
  - Format: Inputs (shape, types) → Steps (brief) → Output (shape, types) +
    Notes (edge cases, errors)

## Analysis & Quality

- **Complex Segments**: Non-obvious logic, performance paths, concurrency/async,
  recursion
  - Why noteworthy, risks/pitfalls, suggested tests/benchmarks
- **Naming Issues**: Ambiguous/terse names across variables, objects, types
- **Code Cleanup**: Dead code, unused declarations, unnecessary assignments,
  magic numbers
- **Standards**: Project conventions, then language best practices (camelCase,
  snake_case, etc.)
- **Safety**: API preservation, immutability, visibility, cohesion, modularity,
  - **Comments**: Meaningful *why* explanations, updated docstrings, no
    testability outdated/obvious/template
- **Types**: Typing/nullability issues, safer signatures, error handling, TODOs
- **Mapping Table** for proposed changes:

| Original | Proposed    | Rationale                          |
| -------- | ----------- | ---------------------------------- |
| `symbol` | `newSymbol` | Clarifies purpose, unit, and scope |

## Requirements

- Use bullet points over prose; quote identifiers with inline code; use fenced
  blocks for examples
- Base conclusions only on provided code; call out assumptions and uncertainties
- Include concrete examples and naming improvements
- Do not rewrite code; focus on explanation, structure, and naming clarity
- Provide concrete, actionable suggestions tailored to the code/files
- Ensure fenced code blocks and markdown tables have lines no longer than 80
  characters.
