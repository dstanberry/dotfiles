---
name: skill-forge
description: >-
  Collaboratively build or edit strong LLM instruction files — skills
  (SKILL.md), agent instruction files, and slash-command instructions — by
  orchestrating three specialist skills: skill-creator (mechanics + authoring),
  prompt-engineer (LLM-instruction quality), and doc-coauthoring (prose,
  structure, economy). Use this whenever the user wants to create a new skill or
  agent file, workshop a draft, or edit/improve an existing one and wants it
  reviewed for quality before landing — even if they only say "make a skill for
  X", "tighten this skill", "fix the description on my agent", or "help me write
  a SKILL.md". Prefer this over invoking skill-creator, prompt-engineer, or
  doc-coauthoring alone when the goal is a production-quality instruction file.
---

# Skill Forge

Orchestrate three specialist skills to produce a strong agent/skill instruction
file, then land the edit. You are the neutral coordinator: you author through
skill-creator, gather bounded reviews from prompt-engineer and doc-coauthoring,
adjudicate their conflicts, and apply the result. You never let a reviewer write
the file, and you never adjudicate on behalf of the author.

## Roles (single responsibility — keep them in their lane)

Each sub-skill owns exactly one axis. Bleed between axes produces duplicate and
conflicting findings, so every review invocation must name the axis and name
what the other two own.

| Sub-skill | Axis it judges | Explicitly NOT its job |
|---|---|---|
| `skill-creator` (SC) | **Mechanics**: frontmatter validity, triggering-quality description, progressive disclosure, resource refs, anatomy, length budget. Also the sole **author/writer**. | Wordsmithing; LLM-instruction design critique |
| `prompt-engineer` (PE) | **Instruction quality**: scope in/out, uncertainty exits, missing "why", anti-patterns, cold-read, zero ambiguity | Prose polish; skill packaging mechanics |
| `doc-coauthoring` (DC) | **Prose & structure**: tightness, redundancy/DRY, section flow, clarity of English | Anything LLM-specific (triggering, tool semantics) |

**DC always gets told, verbatim, in its invocation:** *"You are reviewing an LLM
instruction file that will be parsed by an AI model, not read by a human for
pleasure. Terseness is the priority. There is no margin for misinterpretation.
Judge structure, redundancy, and economy — not readability-for-humans."* Without
this, DC optimizes for narrative prose, which is the opposite of the goal.

## Step 0: Detect mode and tier (automatic)

**Mode** — decide before authoring:

- **EDIT** — the request targets an existing file (a path is given, the file
  exists on disk, or the user says "update / fix / improve / tighten <existing
  skill>"). Check the filesystem to confirm. In EDIT mode the author produces a
  **minimal scoped diff** and preserves the file's existing voice and structure
  unless the voice is the thing being fixed. Do not rewrite.
- **CREATE** — no existing target; the user wants a new file. The author drafts
  from scratch.
- *Uncertain which?* Check disk first. If still ambiguous, ask — don't assume.

**Tier** — decide how much review the change warrants:

| Tier | Trigger | Who runs |
|---|---|---|
| **Trivial** | Single-location change; cosmetic or one instruction; no behavioral, scope, or structural change | Author edits directly → lint. No fan-out. |
| **Substantive** | Multi-part change, new section, or a behavioral/scope change — but not a rewrite | PE + SC. Add DC only if prose/structure is touched. |
| **Major** | New file (CREATE), or a restructure/rewrite | SC + PE + DC + full deliberation |

When a request sits between two tiers, pick the **higher** one — more review is
cheaper than shipping a broken instruction file.

## Step 1: Author the draft or diff

Invoke SC to produce the artifact:

- CREATE → a full draft following skill anatomy.
- EDIT → a minimal diff scoped to the stated intent.

SC authors only. It does not review its own output for prose or instruction
quality at this stage.

## Step 2: Parallel bounded review

For **Substantive** and **Major** tiers, spawn the reviewers **in the same turn**
so they run in parallel (subagent environments), each loaded with its skill and
its bounded role prompt. If subagents are unavailable (e.g., Claude.ai), adopt
each lens **sequentially inline**, one at a time.

**Every review invocation must include, in full:**

1. The complete current file (not an excerpt).
2. The pending draft or diff under review.
3. The tasklist / planned future work.
4. An **Out of scope / deferred** block listing what is deliberately not being
   done now — so reviewers don't spend a round flagging known-deferred items.
   (This is PE's own "scope in both directions" principle applied to the review
   itself.)

This full-context rule is not optional and is restated here because subagents
are stateless — a reviewer that receives only the diff will hallucinate missing
context and produce noise.

**Each reviewer returns a findings list**, one entry per issue:

```
- severity: 🔴 critical | 🟡 warning | 🔵 suggestion
  axis: mechanics | instruction | prose
  location: <line or section>
  claim: <what's wrong>
  grounding: <cited principle from the reviewer's own skill, OR a specific line>
  fix: <the concrete change proposed>
```

A finding is **blocking** only if it is 🔴/🟡 **and** grounded (cites a principle
or a line). Ungrounded "this feels clearer" findings and all 🔵s are
**advisory** — apply if cheap, never trigger a deliberation round. This prevents
sycophantic churn and reviewers inventing problems.

## Step 3: Adjudicate (you, the neutral coordinator)

Sort all findings:

1. **Non-conflicting** (reviewers agree, or the findings are independent) →
   apply them. Do **not** deliberate these.
2. **Conflicting** — two findings target the same span with incompatible fixes
   (typically PE says "remove, redundant for an LLM" vs DC says "keep, it
   orients a maintainer"). This PE↔DC tension is the *point* of using both;
   harvest it, don't treat it as failure.

For each conflict, run **at most 2 deliberation rounds**. Each round: give each
reviewer the other's grounded rationale; it either **concedes** or **holds with
strengthened grounding**. Resolve:

- One concedes → done, apply the winner.
- Both hold after 2 rounds → classify the conflict:
  - **Trivial** (cosmetic wording; no change to meaning, behavior, or scope; no
    context a maintainer loses) → **auto-resolve toward terseness/accuracy** —
    PE's axis wins, because this is an LLM instruction file.
  - **Non-trivial** (alters behavior/scope/meaning, or drops context a
    maintainer needs) → **surface the specific tradeoff to the user** with both
    grounded rationales and your recommendation. Do not resolve it silently.
    Example: *"PE wants line 40 removed (redundant, token cost); DC wants it
    kept (orients a new maintainer to why the step exists). I lean remove. Your
    call?"*

## Step 4: Land + deterministic lint

1. SC applies the **agreed change set verbatim** — nothing beyond what was
   agreed. New creative edits here are a review-escape and are not allowed; a
   genuinely new idea goes back through Step 2.
2. Run the deterministic lint: `python3 scripts/lint_skill.py <path-to-SKILL.md>`
   (resolve the path relative to this skill's directory). It checks frontmatter
   validity, name-matches-directory, description presence, a wrapping-invariant
   content budget (measured in words, not physical lines), and that referenced
   resource paths exist. If the script is unavailable, perform those same checks
   manually.
3. Lint failures become new findings. Deterministic ones (bad path, over budget)
   are fixed directly; anything requiring judgment loops back to Step 2.
4. Report the final artifact and a short **Changes** list (what landed and why),
   plus any tradeoff you surfaced to the user.

## Scope — what this skill does NOT do

- **Reviewers never write.** PE and DC return findings only; SC is the sole
  writer. This keeps a single source of truth for the artifact (DRY) and a
  single responsibility per actor (SRP).
- **No eval/benchmark machinery by default.** SC's eval-running, benchmarking,
  and description-optimization loops are a different workflow. Invoke them only
  if the user explicitly asks to test or optimize triggering — this skill is
  collaborative drafting, not eval-based iteration.
- **No rewrites in EDIT mode.** Preserve the existing file; change only what the
  intent requires.
- **No deliberation on non-conflicting findings**, and **no SC self-review** for
  prose or instruction quality — SC's final pass is mechanical only.

## Uncertainty exits

- Mode ambiguous → check disk, then ask.
- Tier ambiguous → pick the higher tier.
- A reviewer returns ungrounded findings → treat as advisory, don't block.
- Non-trivial conflict unresolved after 2 rounds → surface to user, don't guess.
- Subagents unavailable → run reviews sequentially inline.
- Lint script missing → run its checks by hand.
