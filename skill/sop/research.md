# SOP — research (gather evidence)

> Raw material for the deck's decisions. The human has written the angle in `{deck}/brainstorm.md`; you gather the evidence.
> Paths are HOST-PROJECT paths (relative to the working dir).

## Order matters
`sop/brainstorm.md` (interview-driven angle) → `{deck}/brainstorm.md` → THIS SOP (AI gathers evidence) → `sop/create.md`.

**If `{deck}/brainstorm.md` doesn't exist OR has no 1-sentence purpose:** STOP. Do not ask one ad-hoc question and proceed. Run `sop/brainstorm.md` first — a structured 5-stage interview using Jobs-to-be-Done, Hypothesis-Driven Thinking, 5 Whys + skeptic test, and SCQA/Pixar narrative scaffolds. That SOP writes brainstorm.md; this SOP then runs against it.

**Why this is gated:** research without a decision = blank-page problem. The brainstorm SOP exists specifically to surface the decision through proven frameworks instead of forcing the user to brainstorm in a vacuum.

## Where research lives
- Write `{deck}/claims.md` + `{deck}/examples.md` **inside the deck folder** — keeps each deck self-contained; nothing bleeds between decks.
- Claims and examples are their OWN files, not folded into `brainstorm.md` (brainstorm = the human's angle; research = the AI's evidence — separate so review can trace claim→slide).

## Produce
- `claims.md` — 3–5 claims, each with: source · which insight technique · the **Action Title** it yields · a counter-argument.
- `examples.md` — 5–7 concrete examples, **vault-first** (search qmd / local notes), then web.

## The 4 insight techniques (apply to every claim → turns data into an Action Title)
1. **What / So What / Now What** — data → meaning → action
2. **Gap** — Gap (how far) / Drag (blocker) / Accelerator (lever)
3. **Second-order** — "Then What?" (chain effects)
4. **Anomaly** — data against expectation = deepest insight

A claim isn't done until it has an Action Title (conclusion + recommendation) derived via one of these.

## Hard rules
- Every claim needs a real source. No source = don't use it (AI memory = hallucination, audience catches it).
- Vault before web.
- You gather; the human picks which claims make the deck. Don't pre-select.

→ Next: `sop/create.md`
