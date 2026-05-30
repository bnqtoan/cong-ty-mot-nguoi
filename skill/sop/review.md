# SOP — review (three layers: structure + mechanics + quality)

> Run AFTER create, BEFORE deploy. Three layers, cheap-first. Structure gates the layout; linter gates syntax; quality gates the method.

## Layer 0 — structure (DRIFT GUARD, run FIRST)
```
bash scripts/studio-check.sh        # lints the studio ROOT, not one file (host script, next to place-images.py)
```
Catches folder/file drift before it spreads: research leaked into `10-research/`, a stray `00-decide/`, a deck missing `audience.md`/`outline.md`/`brainstorm.md`/`claims.md`, rogue `assets/`/`refs/` (images go in `images/`), nested-ghost folders, loose exports in a deck root, a retro filename not mapping to a deck. A `✗` = fix the layout before reviewing content. This is the mechanical defense against the per-deck model collapsing (CLAUDE.md "Nguyên tắc per-deck").

## Layer 1 — mechanics (deterministic, per-deck)
```
bash <this-skill>/scripts/slide-check.sh {deck}/slides.html
```
Catches: hash-sync built as `"slide-"+n`, hand-typed totals, missing `.stage-strip`, 404 images, `_`-prefixed CSS, duplicate closing tags, a placeholder whose prompt is just the branch word, missing fork audit-trail comment. Fix hard ✗ before continuing; ⚠ are judgment calls.

## Layer 2 — quality (judgment, vs the method)
The bar is `<this-skill>/references/slide-method.md`. Read it, score the deck against the 7 checks:

| # | Check | Pass = | ref |
|---|---|---|---|
| 1 | Action Title every slide | `<h1>` = conclusion + recommendation, not a topic label | §2 |
| 2 | **Story Test** | read ONLY the titles top-to-bottom → a complete narrative (name the through-line) | §5.1 |
| 3 | Support Test | everything on a slide defends THAT slide's title | §5.1 |
| 4 | Distill ≤20% / one idea | no text dumps; one beat; atomic ≤~10 words | §2 |
| 5 | SCR arc | Situation → Complication → Resolution (or deliberate variant) | §5.2 |
| 6 | Visual rule | structure→SVG, emotion→image; no raster-of-a-diagram | §3 + create SOP |
| 7 | 60-30-10 + one anchor | colour ratio held, accent sparing, ≤1 visual anchor/slide | §4 |
| 8 | **Eyebrow ration** | `.slide-kicker` count ≤ ceil(slides/3); not one-per-slide | create SOP (taste-skill §4.7) |
| 9 | **Copy self-audit** | every audience-visible string re-read; no AI-hallucinated, broken, or "performative-craftsman" phrases | create SOP (taste-skill §4.9) |
| 10 | **No em-dash in audience layer** | `—` / `–` absent from titles, slide-text, captions (stage-strip is exempt; VN nuance allowed) | create SOP (taste-skill §9.G) |
| 11 | **Content→container alignment** | each slide's container supports its content's job (fill=primary outline=subordinate for comparisons; ≤1 anchor per slide; no decoration on claim-slides) | `references/content-to-container-principle.md` |
| 12 | **No speaker-meta in audience layer** | text addressing the speaker (`"if overrun"`, `"moment"`, `"callback"`, `"pause"`, timing in parens) belongs in `.stage-strip` only | content-to-container §Type F |
| 13 | **No opacity-as-fade on dark theme** | foils use explicit darker stroke or dimmer text color, not `opacity:.x` (opacity blends toward bg, weakens hierarchy) | content-to-container §Type A |

### Scorecard to return
```
=== review: {deck} — VERDICT: SHIP / FIX-FIRST / REWORK ===
Story Test: PASS/FAIL — "through-line read from titles only: …"
SCR: PASS/FAIL — S:slide-x C:slide-y R:slide-z
Per-slide: {id}  Action-Title ✓/✗→"{rewrite}"  one-idea ✓/⚠  visual ✓/✗
Colour 60-30-10: ✓/⚠
Top 3 fixes: 1… 2… 3…
```

### Verdict rule
- **SHIP** — Story Test passes, every title an Action Title, no text dumps.
- **FIX-FIRST** — Story Test passes but ≤2 slides need a title/visual fix (quick).
- **REWORK** — Story Test fails OR multiple topic-titles OR text dumps → back to the outline. The thinking, not the slides.

### Honesty rule
Don't rubber-stamp. A polished deck that fails the Story Test is REWORK — that's the exact failure the method exists to prevent.

### Feed the retro
Write the verdict + Story-Test result + the recurring weak spot into the host's `50-retro/{deck}.md` (the retro SOP picks it up). Three decks missing the same way = a template/prompt change, not a per-deck fix.

→ Next: `sop/retro.md`, then `sop/deploy.md`
