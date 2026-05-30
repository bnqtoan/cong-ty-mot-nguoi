---
source: 2026-05-29-s1-v4-rosette retro + content→container audit
status: canonical
applies-to: every slide-studio deck
---

# Content → container principle

> The deepest mistake when building a deck: thinking *"how do I style this slide?"* instead of *"what's the content doing, and what container supports that?"*
>
> A slide is a content moment wearing a container. When they fight, the audience loses. When they align, the slide disappears and only the content remains. **Smooth transition from content to slide = invisible container.**

This is the rule that should run BEFORE the 4-field outline schema. Once content and container agree at the framing level, every per-slide CSS choice flows from it. When they disagree at the framing level, no CSS tweak fixes the discord.

## The 4-step audit (per slide, in this order)

For every slide, answer in order:

1. **What's the content's job?** (1 sentence)
   - Comparison? Foil → answer.
   - Punchline reveal? Eye rests on the answer.
   - Sequence? Eye walks left to right.
   - Single claim? Sit with it, no clutter.
   - Quote? Spoken, not stated — italic restraint.
   - Personal moment? Breath + warmth + image-as-warmth (not data).
   - List with one default? Default = marked, peers = peers.
   - Diagram explaining a concept? Hero element outweighs labels.

2. **What does the eye need to do?**
   - Land where? Move where? Skim what? Stop on what?
   - Are there multiple things competing? The eye can only land on ONE thing first.

3. **What container supports that?** (NOT: "what looks pretty")
   - Comparison: cmp2 cards, foil = outline / answer = fill
   - Sequence: filmstrip, equal weight, arrows
   - Reveal: filled accent block, surrounded by negative space
   - Quote: italic + indent + restraint
   - Default-in-a-set: hero = fill-color, peers = outline-color
   - Personal: centered, big breath, single image-as-warmth

4. **Does the container deliver that, or fight it?**
   - If aligned: ship.
   - If fighting: don't tweak colors — re-architect the container.

## The 6 mismatch types (learned from v4 rosette audit)

### Type A — opacity-as-fade on dark themes

**Symptom:** Foil uses `opacity:.7` or similar to "fade" against the answer.

**Why it fails on dark:** Opacity blends TOWARD the page background. On a dark theme, dark surface + `opacity:.7` = blends INTO the page = becomes a slightly-different dark grey. Hierarchy disappears.

**Fix:** Don't fade by opacity. **Fade by changing the fill or the stroke explicitly:**
- Foil: `stroke="#2a2a2a"` (subtler), `fill="#1a1a1a"` (deeper), `color="#8a8475"` (dimmer text)
- Answer: original brightness, original stroke, original text color

**Codified rule:** *On dark themes, foils MUST use lighter stroke (closer to bg) on same bg, OR same stroke on darker fill. Never `opacity:.x`. Same logic works on light: foils fade with explicit colors, not opacity.*

### Type B — foil treated same as primary

**Symptom:** Both sides of a comparison get equal visual weight. No hierarchy.

**Why it fails:** Audience doesn't know which side is the answer. Eye drifts.

**Fix — the universal pattern (works both themes):**
> **Fill = primary. Outline = subordinate.**

- Answer: filled background + accent border / stripe + bright text
- Foil: just border + transparent or matching-bg fill + dimmed text
- Eye reads outline = lighter weight, fill = heavier weight

No opacity. No color tricks. Just *fill vs outline*. Same logic for cards, chips, buttons, dial-rings, anywhere.

### Type C — decoration where content needs clarity

**Symptom:** Background gradient, atmosphere wash, glyph, or decoration is loud enough to compete with the claim.

**Why it fails:** Eye lands on decoration. Claim becomes background noise.

**Fix:** Atmosphere/decoration belongs only on slides whose **content is a feeling** (cover, quote, personal moment, thanks). Never on slides whose **content is a claim** (lecture, comparison, diagram). If a structural slide has atmosphere, strip it.

**Sub-rule: one atmosphere mechanism per feeling-slide.** Choose ONE of:
- Atmosphere class (radial-gradient corners), OR
- Background image (PNG/SVG full-bleed with overlay), OR
- Brand glyph (single decorative element with sub-0.15 opacity off-canvas)

**Never stack more than one.** Stacking a PNG background + radial gradients + `::after` overlay + a glyph + a base color = a 5-layer blend that produces muddy gray noise where the hero text lives. The eye reads "broken render" or "image still loading," not "atmospheric."

**Title-safe zone rule:** Whichever atmosphere mechanism you pick, it must NOT pass through the hero text region. Gradients fade BEFORE the title's horizontal span. Images use vignettes that darken the corners not the center. Glyphs sit at the screen edge, not behind text.

### Type D — no hero / flat hierarchy

**Symptom:** Slide has 3+ visual blocks (H1 + image + chips + lead paragraph), all roughly equal weight. Eye doesn't know where to land.

**Why it fails:** Slide-studio teaches "1 anchor / slide" (S12 in this very deck). When the slide HAS no hero, the audience can't lock onto a beat.

**Fix:** Pick ONE anchor — drop the rest. If H1 IS the slide, drop the image. If the image IS the slide, shrink the H1. If the chips ARE the slide, drop the .lead. Choose. **The cost of NOT choosing is the audience choosing for you, badly.**

**Most painful instance** (v4 audit): S08 + S12, which both *teach* the 1-anchor rule, themselves have 3 anchors. Eat the dog food.

### Type E — theme literal collision

**Symptom:** A hardcoded color (white logo card, near-black background, etc.) breaks the theme's elevation system.

**Why it fails:** Theme's surface tokens get overridden by a brand fidelity choice (logos need white bg). The white card on charcoal now *outweighs* the H1 because it's the brightest thing on the slide.

**Fix options (in priority order):**
1. Negotiate the brand constraint — can the logo render on the theme bg? Many brands have dark-mode variants.
2. Darken the hardcoded surface toward the theme palette (`#262626` instead of `#fff` for logo cells on dark theme).
3. Accept the conflict but rebalance — make the H1 LOUDER so it still wins (bigger, brighter, more weight).
4. Last resort: structure the slide so the hardcoded element IS the content (not the H1) — i.e. make the slide be about the logos.

### Type F — speaker meta leaking into audience view

**Symptom:** Text on the slide addresses the speaker, not the audience.
- "Demote this if overrun"
- "Callback to S09"
- "Personal moment" (as a label on a personal moment slide)
- "(2-3 phút)"
- "Pause here"

**Why it fails:**
1. Costs the audience an anchor (Type D)
2. Reveals the production seam — breaks the illusion the speaker is talking TO the audience
3. The slide-studio architecture already has `.stage-strip` for exactly this content

**Fix:** Lint rule: any text on the slide that addresses the speaker BELONGS IN `.stage-strip`. The audience layer is for audience text only.

**Examples to grep for in any deck:**
- "if overrun" / "if behind schedule"
- "moment" (as a label)
- "callback"
- "demo" (as a tag, not the demo itself)
- "pause" / "wait here"
- "skip" / "if time allows"
- Timing in parentheses

## How this gets applied — workflow integration

### Before building HTML (in `sop/create.md` Step 1)

After writing outline.md and before forking the reference deck, run the 4-step audit per row:
- For each slide row, identify its job (Step 1)
- Note what container the visual column implies
- Check for the 6 mismatch types
- If mismatch: rewrite the outline row BEFORE proceeding

### During HTML build (in `sop/create.md` Step 4)

Apply the universal pattern when building visual elements:
- Comparisons → cmp2 cards, fill-vs-outline hierarchy
- Sequences → filmstrips with equal-weight tiles + accent arrows
- Single-claim slides → H1 + ONE visual element (drop the image OR drop the chips, not both)
- Quotes → italic + indent + restraint
- Personal moments → centered, single image-as-warmth, no chrome

### During review (in `sop/review.md`)

Add to layer-2 scorecard:
- [ ] Each slide passes the 4-step audit
- [ ] Foil/answer comparisons use fill-vs-outline, not opacity
- [ ] No speaker-meta in audience layer (grep for "if overrun", "moment", "callback")
- [ ] No slide has more than 1 visual anchor

## The deepest rule

> *Don't fix slides. Fix the content-container alignment. The slide is downstream.*

Most "ugly slide" complaints are content-container mismatches in disguise. A pretty container on misaligned content = pretty noise. A plain container on aligned content = the slide disappears and the content lands.

The reference decks (CXO + this v2/v3/v4 series) are aligned. When forking them, the question is not "does my deck look like this one?" — it's *"does my deck have the same alignment between content and container?"*

That's why the rule is **fork-don't-describe**: forking an aligned deck inherits the alignment. Describing a style in prose drifts away from it.
