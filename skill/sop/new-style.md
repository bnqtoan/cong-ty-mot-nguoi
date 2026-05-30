# SOP — new-style (invent a style without drift)

> The escape hatch from "only a few styles." A style is a set of values for the fixed token contract (`40-assets/reference-deck/_TOKENS.md`) + ONE signature move. The chrome/layout engine never changes, so a brand-new look CANNOT drift the presenter mechanics.
>
> **When this runs:** create SOP Step 2 offers two paths — (A) fork an existing seed from the gallery, or (B) run THIS SOP to bake a fresh style. Use B whenever the existing gallery doesn't fit, or the user brings a reference image / brand / specific look.

## The three input sources (any one, or combined)

1. **Reference image** (PRIMARY) — a screenshot of a deck/site you like, a moodboard, a brand shot. AI reads pixels.
2. **Prompt** — a text description ("navy + orange underline, serif headlines, lots of air").
3. **Brand** — the user's logo / website / brand guide (extract their real palette + fonts so the deck matches their identity).

You can mix: "this reference image, but in my brand's green."

## Step 1 — extract the DNA (this is the whole creative act)

From the source(s), pull EXACTLY these, and nothing the contract doesn't have:

- **Palette** → map to color tokens. From an image: sample the dominant bg, the text ink, the ONE accent that pops. Name hex values. Enforce 60-30-10: one bg (60%), one secondary/muted (30%), one accent (10%). If the image has 5 colors, pick the 3 that carry the system; demote the rest.
- **Type pairing** → `--font-display` + `--font-body` + `--font-mono`. From an image, identify or approximate: is the headline a serif (editorial/Fraunces-like) or a grotesk (confident/Be-VN-like)? Set `--display-weight` + `--display-style` (italic?) + `--display-tracking` to match the feel. **Fonts must be VN-diacritic safe** (Be Vietnam Pro, Fraunces, Inter, Manrope, Newsreader all are — check before picking a display font).
- **Density** → `--pad-slide`, `--gap`, `--radius`, `--maxw`. Tight/brutalist = small pad, radius 0. Airy/editorial = big pad, soft radius. Read the whitespace of the reference.
- **Signature move** → the ONE element you'd point at to say "that's the look." Underline? Pill word? Corner glyph? Oversized numeral? Sparkle? Pick ONE. (More than one = muddy. The seed table in `_TOKENS.md` shows examples — don't copy them, find THIS source's own.)

Write the extraction back to the user in this shape and get a nod:

```
Style DNA — from {image/prompt/brand}:
- Palette:   bg {#…} · ink {#…} · muted {#…} · accent {#…}  (60-30-10 ✓)
- Type:      display {Font, weight, italic?} · body {Font} · mono {Font}
- Density:   {airy / medium / tight} — pad {…} radius {…}
- Signature: {the one move, 1 line}
OK to bake?
```

## Step 2 — fill the token contract

Write a theme token block that defines EVERY Required token in `_TOKENS.md` (+ any Optional ones the look needs). This is ~25 lines of `:root{…}`. No new selectors except the ONE signature class.

## Step 3 — build the ONE signature primitive
Build the single class that delivers the signature move, using the design's `clip-path`/`mask`/`border`/`text-decoration` — driven by tokens so it recolors with the theme. Get THIS shape right in isolation first (primitives-before-layouts).

## Step 4 — bake a reference deck
Fork the engine/base deck structure (chrome + layout + primitives) and apply the new token block + signature class. The content can be the canonical sample content (so the gallery stays comparable) OR the user's real deck. Keep ALL presenter chrome verbatim (that's the locked part).

## Step 5 — VERIFY VISUALLY (mandatory)
Render it. Screenshot the cover + one content slide. Confirm: accent is sparing (10%, not everywhere), display font carries the personality, signature move reads at a glance, VN diacritics render. **Never register a style you haven't seen rendered.** If you can't screenshot, flag "VERIFY: needs your eyes."

## Step 6 — register + lock
- Add the deck to `40-assets/reference-deck/{slug}/` (or `{slug}.html`).
- Add a section to `40-assets/reference-deck/_index.md`: slug · path · temperament+register fit · DNA (palette/type/density/signature) · avoid-for.
- Add a row to `references/style-decision-matrix.md` intersection grid so the next deck can route to it.
- Now it's a seed like any other — forkable, never re-described in prose.

## Hard rules
- **One signature move per style.** Enforced by taste, flagged in review.
- **60-30-10 or it's not a style, it's a mess.** The accent is 10%, not a theme color you paint everywhere.
- **Never touch the chrome.** `.stage-strip`, hash-sync-by-id, Esc grid, derived count, S/N/D keys — verbatim. The whole point of the engine is that styles can't break these.
- **VN-diacritic-safe display font** — test "ữ ằ ọ" before committing.
- **Don't pre-build a catalog.** Styles are baked on demand from a real source. The gallery grows from real decks, not from speculative theme files.

→ Back to: `sop/create.md` Step 2c (fork the just-baked deck like any reference)
