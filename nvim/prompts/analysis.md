### Code Review

Objective: Provide a concise, high‑impact review of the active file. Use
bullets, stay grounded in the code, and explicitly state assumptions.

#### Quick Checklist

- [ ] Use bullet points over long prose
- [ ] Base conclusions only on the code provided
- [ ] Call out assumptions and uncertainties
- [ ] Include 1–2 minimal usage examples (with one edge case)
- [ ] Propose clearer names with rationale and mapping

#### Overview

- Purpose of the code and primary responsibilities.
- Key modules/classes/functions and their roles.
- High-level architecture boundaries and dependencies.

#### Logic Flow

- Main entry points and how control/data move through them.
- Core algorithms, branching, and lifecycle steps.
- Error handling strategy, side effects, and external interactions (I/O,
  network, DB).

#### Inputs and Outputs

- Inputs: parameters, environment variables, configuration; types, constraints,
  defaults.
- Outputs: return values, emitted events, mutations/side effects.
- Provide 1–2 minimal usage examples (include one edge case).
  - Example format:
    - Inputs (shape, types)
    - Steps (brief)
    - Output (shape, types)
    - Notes (edge cases, errors)

#### Notable or Complex Segments

- Non-obvious logic, performance-sensitive paths, concurrency/async, recursion.
- Why each segment is noteworthy and potential risks or pitfalls.
- Suggested tests or benchmarks to validate behavior/performance.

#### Naming Review and Improvements

- Identify ambiguous/terse names across variables, objects, and types.
- Identify dead code, unused declarations, and unnecessary assignments. Keep
  side effects explicit.
- Naming conventions: First, follow any explicit naming/style instructions
  provided in the task or repository (highest priority). If none exist, infer
  the prevailing conventions from the active file and surrounding project (e.g.,
  existing identifiers, linter/formatter/CI configs), then propose names
  consistent with modern best practices for the language and ecosystem (e.g.,
  camelCase, PascalCase, snake_case, SCREAMING_SNAKE_CASE). Maintain consistency
- Preserve behavior; avoid collisions and breaking public APIs unless called
  out.
- Provide a clear mapping table:

| Original | Proposed    | Rationale                          |
| -------- | ----------- | ---------------------------------- |
| `symbol` | `newSymbol` | Clarifies purpose, unit, and scope |

#### Best Practices and Maintainability

- Recommendations aligned with modern language/framework guidelines.
- Address immutability/const-ness, visibility, cohesion, modularity,
  documentation, and testability.
- Flag dead code, duplication, magic numbers, TODOs, and missing error handling.
- Note typing/nullability issues and suggest safer signatures.

#### Guidelines

- Be concise; prefer bullets over paragraphs.
- Quote identifiers with inline code formatting and use fenced code blocks for
  examples.
- Clearly label assumptions and unknowns.
- Do not rewrite the code; focus on explanation, structure, and naming clarity.

#### Expected Output

- A well-structured Markdown response with the sections above.
- Concrete, actionable suggestions tailored to the code and or file(s) provided.
