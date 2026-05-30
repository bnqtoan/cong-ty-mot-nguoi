---
type: skill-reference
applies-to: scroll-driven slide decks (Pudding-style / NYT-style scrollytelling)
canonical-deck: 40-artifacts/reference-decks/scrollytelling-flowanim.html
status: canonical 2026-05-29
---

# Scrollytelling pattern — sticky stage + scrolled beats

> **When to use:** the content's job is a *sequence the audience controls the pace of*. A loop revealing one node at a time. A funnel showing distillation steps. A chart adding data points as the reader processes each one. A diagram constructing itself piece-by-piece while text on the right narrates.
>
> When the audience HAS to set their own pace (long read, complex diagram, story arc), scrollytelling is the right gear. When the speaker controls pace (live workshop), use SMIL animations or IntersectionObserver fade instead.

## The 4 animation gears the skill ships (when to use which)

| Gear | Mechanism | Pace controlled by | Use when |
|---|---|---|---|
| **1. CSS reveal** | IntersectionObserver + opacity/transform | Audience scroll, slide-level | Default reveal on every SVG when slide enters viewport. Already in `sop/create.md` Step 4 + `references/build-details.md`. |
| **2. SMIL animation** | `<animate>` inside SVG | Self-running loop | A pulse, a typewriter, a flowing dot. S04 loop pulse + S24 typewriter are the canonical examples. |
| **3. Interactive SVG** | Click handlers + CSS state | Audience click | S10 (4 lenses click-to-reveal) — when content invites exploration. |
| **4. Scrollytelling** | Sticky stage + IntersectionObserver per-beat | Audience scroll, beat-level | **THIS doc.** Scene transforms as reader scrolls past each text beat. |

Pick the deepest one the content actually needs. Don't stack.

## The layout primitive

```
┌─────────────────────────────────────────┐
│             .intro (1 viewport)         │  ← hook + scroll hint
├──────────────────┬──────────────────────┤
│                  │                      │
│   .stage         │   .beats             │
│   (LEFT)         │   (RIGHT)            │
│   position:      │                      │
│   sticky;        │   .beat 1 (100vh)    │
│   height: 100vh; │   .beat 2 (100vh)    │
│                  │   .beat 3 (100vh)    │
│   <svg>          │   .beat 4 (100vh)    │
│   the scene      │   .beat 5 (100vh)    │
│   stays put,     │   .beat 6 (100vh)    │
│   transforms     │                      │
│   on scroll      │                      │
│                  │                      │
├──────────────────┴──────────────────────┤
│            .outro (1 viewport)          │  ← payoff + CTA
└─────────────────────────────────────────┘
```

Mobile (< 820px): collapses to 1 column, stage becomes a 60vh top-sticky strip, beats stack below.

## The 4 transformation primitives

What can transform inside the stage as the reader scrolls:

### 1. Connection lines drawing in
```html
<path class="conn conn-skill" pathLength="100" d="M 270 270 L 90 90" />
```
```css
.conn{ stroke-dasharray: 100; stroke-dashoffset: 100; }
.conn.in{ stroke-dashoffset: 0; transition: stroke-dashoffset .5s; }
```
`pathLength="100"` is the trick — normalizes the stroke math so you always use percentages 0-100 regardless of actual path length.

### 2. Modules fading + scaling in
```css
.module{ opacity: 0; scale: .5; transform-box: fill-box; transform-origin: center; transition: opacity .35s, scale .35s; }
.module.in{ opacity: 1; scale: 1; }
```
**CRITICAL gotcha:** don't use CSS `transform` on SVG `<g>` elements that already have a `transform="translate(...)"` attribute. CSS `transform` OVERRIDES the attribute, collapsing modules to the origin. Use the `scale` property (independent of `transform`) instead. The reference deck documents this in comments.

### 3. Center figure pulsing
```css
.center-group.pulse{ animation: center-pulse 1.6s ease-in-out infinite; }
@keyframes center-pulse { 0%,100% { scale: 1 } 50% { scale: 1.06 } }
```
Add `.pulse` class on the final beat to signal "the system is alive."

### 4. Animated blips flowing along paths
```css
.blip{ opacity: 0; offset-rotate: 0deg; }
.blip-1{ offset-path: path("M 270 270 C 200 200, 140 120, 90 90"); }
.blip.flow{ opacity: 1; animation: blip-flow 1.4s linear infinite; }
@keyframes blip-flow { 0% { offset-distance: 0%; opacity: 1 } 100% { offset-distance: 100%; opacity: 0 } }
```
Modern CSS `offset-path` lets a dot travel along an arbitrary path — perfect for showing flow direction without redrawing.

## The driver: JS-based (bulletproof) or CSS-based (modern bonus)

### Bulletproof: IntersectionObserver per beat

```javascript
const beats = [...document.querySelectorAll('.beat')];
const STEP_TO_REVEAL = {
  1: [],
  2: ['skill'],
  3: ['skill','vault'],
  4: ['skill','vault','sell'],
  5: ['skill','vault','sell','mcp'],
  6: ['skill','vault','sell','mcp'],
};

function applyStep(step){
  const reveal = STEP_TO_REVEAL[step] || [];
  // add .in class to revealed modules + their conns, remove from others
  // toggle .pulse on the final beat
}

const io = new IntersectionObserver(entries => {
  let best = null;
  entries.forEach(e => { if (!best || e.intersectionRatio > best.intersectionRatio) best = e; });
  if (best && best.intersectionRatio > 0.4){
    applyStep(+best.target.dataset.step);
  }
}, { threshold: [0, 0.25, 0.5, 0.75, 1.0], rootMargin: '0px 0px -20% 0px' });

beats.forEach(b => io.observe(b));
```

Works in every browser back to 2018.

### Modern bonus: `animation-timeline: scroll()`

```css
@supports ((animation-timeline: scroll()) and (animation-range: 0% 100%)) {
  .scroll-driven .conn-skill{
    animation: draw linear forwards;
    animation-timeline: scroll(root);
    animation-range: 18% 28%;
  }
  /* connection N draws from N0% — N0%+10% of total page scroll */
}
@keyframes draw { from { stroke-dashoffset: 100 } to { stroke-dashoffset: 0 } }
```

Works in Chrome 115+, Safari 17.4+, Firefox-flag-only. **Always ship the JS fallback alongside** — `@supports` query gracefully degrades to no-op on unsupported browsers, and the JS driver carries the deck.

## Accessibility — always ship this

```css
@media (prefers-reduced-motion: reduce) {
  .conn{ stroke-dashoffset: 0 !important; animation: none !important; }
  .module{ opacity: 1 !important; transform: none !important; }
  .blip{ display: none; }
}
```

Reader sees the final state immediately, no animation. The CONTENT survives even when motion is off.

## How to use it in a deck

### Option 1: ONE scrollytelling section inside a normal deck

Fork the regular reference deck. Insert one `<section class="slide scrollytelling">` that contains the sticky-stage + beats layout. Other slides stay normal. Use for the moment that deserves the scroll-paced reveal — usually the loop diagram or the funnel.

### Option 2: Whole deck IS scrollytelling

Fork `40-artifacts/reference-decks/scrollytelling-flowanim.html`. Intro + story (sticky stage with N beats) + outro. This is the right call when the deck's content is a single coherent system being explained step-by-step (loop, funnel, decision tree, story arc).

### Option 3: Hybrid

Cover (normal) → intro to the story (normal) → ONE scrollytelling block (the system being constructed) → outro normal slides (CTAs, Q&A, thanks).

Use Option 1 for the live workshop tonight. Option 2/3 for a take-home / async / web-published deck where the audience reads at their own pace.

## Gotchas (codified from the flowanim build)

1. **CSS `transform` vs SVG `transform` attribute** — covered above. Always use `scale` (the property) on SVG `<g>` elements with transform attributes.
2. **`pathLength="100"`** — required on every `<path>` you want to stroke-draw. Without it, dasharray math breaks on different path lengths.
3. **`rootMargin: '0px 0px -20% 0px'`** — required so a beat counts as "active" once it's 20% past the top of the viewport, not the moment it touches the bottom. Without this, beats fire too early.
4. **`threshold: [0, 0.25, 0.5, 0.75, 1.0]`** — coarse thresholds, not fine. IntersectionObserver doesn't need 0.01 granularity for this; coarse thresholds reduce work.
5. **CSS scroll-timeline + JS driver — ship both.** Don't pick one. CSS handles the smooth feel where supported; JS handles correctness everywhere.
6. **The `.scroll-driven` class on `<body>`** — gates the CSS scroll-timeline animations. Lets you disable them by toggling the class (useful for `print` and `prefers-reduced-motion`).
7. **No `<style>` inside SVG when CSS scroll-timeline is active** — the @supports block sets up animations on classes; keep them in the document `<style>`, not inline. SMIL `<animate>` inside SVG is fine; CSS animation-timeline lives outside.

## Anti-patterns (don't do these)

- **Scrollytelling for a single beat slide** — overkill. Use IntersectionObserver fade instead.
- **More than 6-7 beats** — reader loses track of the scene. If you need 10 steps, split into 2 scrollytelling sections with an interlude.
- **Animating layout, not state** — don't translate boxes around the screen mid-scroll. Reveal/hide modules in their pre-positioned places. The scene composes; it doesn't choreograph.
- **Text-heavy beats** — each beat should be short (1 H2 + 1 paragraph max 38ch). The scene IS the content; the beat is the caption.
- **Stage scene that changes meaning between beats** — same elements, revealed progressively. Don't swap symbols beat-to-beat (reader thinks you changed topic).

## The principle this serves

From `references/content-to-container-principle.md`:
> *Content's job decides the container.*

Scrollytelling is the container that says **"this is a system being constructed."** When the content's job IS to show construction (a loop closing, a funnel filling, a building rising), scrollytelling delivers that mechanically. When the content's job is anything else, don't reach for it.

## Files

- **Canonical reference deck:** `40-artifacts/reference-decks/scrollytelling-flowanim.html` — fork this, swap content + scene, keep chrome
- **Live working example:** `workshops/workshop-20260529-3pack-cong-ty-mot-nguoi/demo-deck/style-flowanim.html` — the bộ máy growing demo
- **This doc:** `40-artifacts/skills/slide/references/scrollytelling-pattern.md`

## Integration with create SOP

When the human's `brainstorm.md` includes phrases like:
- "step by step"
- "construct"
- "one by one"
- "as the reader processes"
- "they should pace themselves"
- "long read" / "essay" / "case study"
- A diagram that grows in stages
- A funnel with intermediate stages worth lingering on

→ Propose Option 1 (one scrollytelling section) or Option 2 (whole deck) per the SOP's Step 1 outline approval. The human picks; skill builds.
