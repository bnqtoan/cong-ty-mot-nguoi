# SOP — create (outline → slides.html)

> The core. **Fork a reference deck, swap content, keep the chrome.** The image step (incl. calling the `image-gen` skill) is step 4.
> Paths like `40-assets/…`, `20-decks/…` are HOST-PROJECT paths (relative to the working dir). Bundled assets are referenced as `<this-skill>/…`.

## 2 phases, NEVER collapsed
```
1. outline.md (content + speaker notes)  →  human approves  →  2. fork + fill slides.html
```
**Hard gate: do not write slides.html until the outline is approved.**

---

## Step 1 — outline.md (the thinking)

Make the deck folder `20-decks/{YYYY-MM-DD-name}/` and `mkdir -p {deck}/images`.
**Don't `cp` a template then Write over it** — the harness blocks overwriting a file you haven't Read. Write `outline.md` **fresh**, following the shape in `<this-skill>/references/template-slide-outline.md` (read it as a guide, don't copy it). (`brainstorm.md` is the human's; only write it yourself if you're explicitly acting as the driver.)

Outline contents:
- Frontmatter: audience (`{deck}/audience.md`, per-deck — from `inbox/{event}/_audience.md`), **delivery context** (hall=few words / PDF=detailed / Zoom), which reference deck you'll fork, target slide count.
- Slide table: `# · Action Title · Beat · Image plan · Claim/Example ID`. **Every heading is an Action Title** (conclusion + recommendation). Decide the Image plan here (step 4 rules) so it's reviewable before build.

Present the outline, ask "Right? Anything to change before I build the HTML?" Wait for yes.

---

## Step 2 — fork the reference deck

**Do NOT describe a style. Fork one.** This step has THREE sub-steps (2a, 2b, 2c) — never skip 2a or 2b.

### Step 2a — Read context from audience + brainstorm

Before picking a fork target, read:
- `{deck}/audience.md` (per-deck; from `inbox/{event}/_audience.md`) — register signals (peer / executive / student / creative / mass)
- `{deck}/brainstorm.md` (or `inbox/{event}/_brainstorm.md`) — temperament signals (data-heavy / pedagogical / creative / technical / personal / sales)

Extract:
- 1-line audience register diagnosis with the signal that supports it
- 1-line content temperament diagnosis with the signal that supports it

### Step 2b — Style proposal (HARD GATE, never auto-fork)

**Two paths — offer both:**
- **(A) Fork a seed** from the gallery (`40-assets/reference-deck/_index.md`) — fast, proven.
- **(B) Bake a new style** via `sop/new-style.md` — when the user brings a reference image / prompt / brand, or no seed fits. The gallery is a starting set, not a closed menu; B is first-class.

If the user gave a reference image or brand, lead with (B). Otherwise use `<this-skill>/references/style-decision-matrix.md` to look up the intersection and propose **top 2 seed candidates** with rationale + tradeoff, in this format:

```
Style proposal — fork choice:

CONTEXT:
- Temperament: {pedagogical} (signal: rubric + 12 students + band 5.5→6.5 framing)
- Audience: {student} (signal: instructor-to-student register, IELTS band markers)

TOP 2 CANDIDATES:

1. {v2-cream + Fraunces italic + orange}  ← RECOMMENDED
   Why: pedagogical × student = warm + scaffolded + readable.
   Tradeoff: less "wow factor" than bolder decks; intentional for learning.

2. {v3-pitchdeck (sage)}
   Why: alternative if instructor wants more confidence/structure feel.
   Tradeoff: sage reads formal/corporate; can feel distant from learners.

OK with #1? Say "yes" / "go #2" / "different style: X"
```

**Wait for explicit user approval.** Do NOT proceed to 2c without it. Silent default is forbidden.

If the user pre-named a fork target in the inbox CLAUDE.md or brainstorm.md (e.g. *"fork v2"*), respect it but still STATE the match against the matrix: *"User pre-named v2-cream. Matrix concurs (pedagogical × student). Proceeding."*

### Step 2c — Fork + audit trail

Once approved:
1. Read the approved reference deck's `slides.html`
2. Write the new `slides.html` keeping its CSS tokens, layout blocks, and presenter chrome — swap content per your outline
3. **Add an audit-trail comment** within the first 30 lines of the new file:
   ```html
   <!-- fork: {ref-deck-path} · rationale: {1-line context match} -->
   ```
   This is verified by `slide-check.sh` check #17. Missing = build failure.

Always keep, regardless of look:
- **audience/speaker split** — `.stage-strip` for the script, **`N`** to toggle notes (HIDDEN by default; user-facing default state). `S` toggles sidebar.
- **presenter chrome verbatim** — auto slide-numbering, **hash-sync by EXACT id** (`slides.findIndex(s=>s.id===hash)`, never `"slide-"+n`), **total from `querySelectorAll(".slide").length`** (never hand-typed), `Esc`/`G` grid, `F` fullscreen, arrows/space nav, **`S` = sidebar**, **`N` = notes**, **`D` = dark mode toggle**, `@media print`.
- sidebar with auto-built TOC from `data-title` attribs; sticky-grid mode.
- scroll-snap deck; `.image-placeholder` with `data-image-prompt` + `:has(img)` activation; self-contained single HTML file.
- separate CSS (if any) NOT `_`-prefixed (Jekyll 404s it) + `.nojekyll` at root.

Deep detail (exact chrome JS, style gallery, traps): `<this-skill>/references/build-details.md`.

### When no existing reference fits

Look up `references/style-decision-matrix.md` "When the matrix doesn't have a good answer" section. Generally: propose closest 2 from matrix, let user pick. After build, recommend the deck as a new reference + matrix update (retro step).

### Build a NEW style (first-class path, NOT last resort)

The gallery is a starting set, not a menu. Whenever the user brings a **reference image, a prompt, or their brand** — or nothing in the gallery fits — bake a fresh style. This is normal, not exceptional.

**Run `sop/new-style.md`.** It extracts DNA (palette · type · density · ONE signature move) from the source, fills the token contract (`40-assets/reference-deck/_TOKENS.md`), builds the one signature primitive, bakes a reference deck, verifies visually, and registers it. Drift is impossible because the chrome/layout engine is fixed — only token VALUES change.

Then fork the just-baked deck exactly like any seed (Step 2c). The new style is now in the gallery for future decks too.

---

## Step 3 — one idea per slide + 5-field schema (HARD GATE for ≤20% distill)

One beat + one visual per slide. More than one idea → split. Distill to ≤20% (`<this-skill>/references/slide-method.md` §2).

### Content → container check (run BEFORE writing the slide row)

Before writing each outline row, ask the 4 questions from `<this-skill>/references/content-to-container-principle.md`:
1. What's the content's job? (comparison? sequence? quote? reveal? personal?)
2. What does the eye need to do?
3. What container supports that?
4. Does that container fit, or fight?

If the visual column implies a container that fights the content — rewrite the row BEFORE forking the deck. Per-slide CSS patches at HTML time can't fix content-container misalignment.

**The universal pattern (cards / chips / dial-rings / any 'this vs that'):** fill = primary, outline = subordinate. Works light AND dark themes. **Never use opacity to fade a foil on a dark theme** — opacity blends toward page bg, weakens hierarchy. Use explicit darker stroke or dimmer text color instead.

**Outline rows MUST use the 5-field schema — never collapse fields:**
- `title` — Action Title's punch (kết luận chính). **≤14 words.** → `<h1>`
- `subtitle` — *optional 5th field added 2026-05-29.* Extends the title with the "why/how" clause. **≤18 words.** Same punctuation register as title (not a paragraph). → renders inside `<h1>` as `<span class="dim">` OR inside a `<p class="sub-title">` directly under the h1.
- `slide-text` — what the audience sees on the slide body. **≤25 audience-visible words.** Excludes title, subtitle, chart labels. → renders inside `.slide`, NOT inside `.stage-strip`.
- `visual` — image-plan + 1-line intent. → the slide's diagram/image.
- `stage-note` — what the speaker SAYS. Unbounded length. → renders inside `.stage-strip` (hidden by `S`).

**Why subtitle exists** (the "Ladder lens" lesson, 2026-05-29):
Some Action Titles need 2 beats — a punch (the conclusion) + a clause (the why/how). Without the subtitle field, authors either:
- Cram both into title → 18-22 words, breaks the ≤14 rule, becomes a paragraph not a title
- Split across slides → loses the 1-beat coherence
- Move "why" to slide-text → reads as detached body, breaks the punch's flow

Title + subtitle pattern is what BCG/McKinsey decks actually do. Example: title *"Doanh thu +18% lừa mắt"* (5 words, the punch) + subtitle *"top 3 chi nhánh vẫn 14% margin, model OK"* (10 words, the why).

**Hard gate before building HTML:**
1. If any outline row has `title` > 14 words → STOP. Either tighten OR split into title + subtitle. Don't paper over with smaller font.
2. If `subtitle` > 18 words → either it's a clause not a paragraph (tighten) or it's body text (move to `slide-text`).
3. If `slide-text` > 25 words → STOP. Push back: "split this slide or move text to `stage-note`." Don't paper over with smaller font.
4. Two slide-text exceptions, marked in the outline: **cover slide** (S01-style, ≤15 words allowed) and **quote slide** (a single quote ≤30 words allowed).
5. When emitting HTML, append `<!-- audience-word-count: N -->` after each `</section>` (includes title + subtitle + slide-text) so `slide-check.sh` (check #11) can verify post-build.

**Why this exists:** the deck Tony built before this rule had outline rows where `beat` carried 35-word prose + `visual` carried 60-word comparison — and the build skill faithfully dumped all of it onto the slide, producing text walls. The rule forces the distillation to happen at outline time (cheap to fix), not HTML time (expensive to fix).

### Eyebrow ration (Section kicker rationed — borrowed from taste-skill v2 §4.7)

The section kicker (`.slide-kicker` — small uppercase wide-tracking label above the headline) is a categorising label. Putting one on every slide produces the same templated rhythm that taste-skill flags as the #1 production Tell.

**Rule:** `.slide-kicker` count ≤ `ceil(slide-count / 3)`. Cover slide counts as 1. Block-opening slides may carry one; the next 2 slides cannot.

**Mechanical check:** `grep -c 'class="slide-kicker"' slides.html`. If > ceil(slide-count / 3) → rework before ship.

**What to do instead of a kicker:** drop it. The headline alone is enough. The slide's *position in the deck* already categorises it; no label needed.

### Speaker-meta in audience layer — HARD BAN (Type F, content-to-container)

**The rule:** anything addressing the speaker, talking ABOUT the deck (timing, slide IDs, beat numbers, callbacks, fallback plans, "if-overrun" clauses, "demote this if", "QC cuối", "personal moment as label") belongs **ONLY in `.stage-strip`**. Never in `<h1>`, `<p class="lead">`, `<p class="quietline">`, `.smallcap`, `<blockquote>`, `.card .t`, or any audience-visible element.

**Why this is hard ban, not soft warn:** the audit caught this exact leak on the canonical s1-v2 deck (slide S12 had "Nếu Block 2 overrun 30 phút, demote slide này..." in `<p class="lead">`). User caught it post-ship. **Lint check #15 missed it because the regex was English-only.** Now expanded to cover Vietnamese speaker-meta vocabulary.

**The actual rule (structural, language-agnostic):**

Audience-visible text that addresses **how the deck is produced/run**, not what it claims, is speaker-meta. It belongs in `.stage-strip`.

**3 detection patterns** (work for English, Vietnamese, anything — these are the structural signals, not phrase lists):

1. **Conditional-about-delivery** — `(if|nếu|khi|when|in case)` clause about TIMING or deck management. Examples: "if overrun", "nếu hết giờ", "if time allows", "khi vượt giờ". Test: does the conditional reference minutes/hours/timing OR slide-management verbs?

2. **Deck-infrastructure references** — mention of slide IDs (`S\d+`, `Slide N`, `Beat N`), block/section labels (`Block N`, `Phần N`), file paths (`refs/`, `40-assets/`, `sop/`, `stage-strip`). Audience doesn't have slide numbers in their head; if the text uses them, the text is for the speaker.

3. **Deck-management imperatives** — verbs that act on the deck itself (demote/skip/pause/ship/hạ/giữ/bỏ qua/move/cut) when combined with deck-management nouns (slide/deck/section/this rule/this block). "Cut the budget" is fine. "Cut this slide" is speaker-meta.

**The audit method (run on each audience-visible string at outline time):**

1. Read it as if you're the audience, not the speaker.
2. Does the text talk ABOUT the talk, or talk TO the audience?
3. If ABOUT → move to `stage-note`.
4. If TO audience but contains a meta clause ("nếu thiếu giờ thì..."), strip the meta clause; keep the audience-facing claim.

**Why not a phrase list:** every deck/instructor/language introduces new vocabulary ("overrun", "ramp", "demote", "skip", "tăng track", etc.). Maintaining a denylist becomes a museum of past mistakes. The 3 structural patterns above are language-agnostic and survive new vocabulary.

**Lint check:** `slide-check.sh` check #15 implements the 3 patterns (not a phrase list). Any flagged string is a build failure that must be moved to `.stage-strip`, not shipped.

### Copy self-audit (mandatory before ship — borrowed from taste-skill §4.9)

Before declaring the deck done, re-read every audience-visible string (title, slide-text, chart labels, button text — NOT stage-strip). Flag any that:
- are grammatically broken or have unclear referents
- sound like AI hallucination (cute-but-wrong wordplay, forced metaphors)
- read as "performative-craftsman" ("Field notes", "Quietly in use at", forced mock-poetic micro-meta)

Rewrite every flagged string. If unsure whether a string is meaningful, replace with a plain functional sentence.

---

## Step 3.5 — ANIMATION GEAR DECISION (before Step 4 image decision)

The skill ships 4 animation mechanisms. Pick the deepest one the content needs — don't stack.

| Gear | Mechanism | Pace controlled by | Use when |
|---|---|---|---|
| **1. CSS reveal** | IntersectionObserver + opacity/transform | audience scroll, slide-level | default reveal on every SVG when slide enters viewport (already in `references/build-details.md`) |
| **2. SMIL animation** | `<animate>` inside SVG | self-running loop | a pulse, a typewriter, a flowing dot — content is a steady-state visual |
| **3. Interactive SVG** | click handlers + CSS state | audience click | content invites exploration (4 lenses, decision tree, "click to see why") |
| **4. Scrollytelling** | sticky stage + IntersectionObserver per-beat | audience scroll, beat-level | content IS a system being constructed step-by-step; reader paces themselves |

**Trigger signals for scrollytelling (gear 4)** — from `brainstorm.md`:
- "step by step" / "one by one" / "as the reader processes"
- A diagram that grows in stages
- A funnel with intermediate stages worth lingering on
- Long read / essay / case study format
- Async / web-published / take-home deck

If matched: use `40-artifacts/reference-decks/scrollytelling-flowanim.html` as the fork target instead of the standard slide deck. See `references/scrollytelling-pattern.md` for the layout primitive + 4 transformation primitives + gotchas.

## Step 4 — IMAGE DECISION

For each slide's visual, pick ONE branch. **Rule: SVG for structure, image for emotion.**

| Branch | When | What you do |
|---|---|---|
| **Inline SVG** (default) | flow, compare, hierarchy, timeline, icon, chart, relationship, "loop" — anything STRUCTURAL | Write `<svg>` directly in the slide. $0, editable, crisp, diffs in git. Most slides. |
| **Stock (Unsplash)** | a real generic photo (people, desk, city), uniqueness doesn't matter | Insert an `images.unsplash.com` URL + credit. |
| **Generated raster** | unique concept/metaphor/hero art | **Call the `image-gen` skill** — hand it the prompt (naming the deck's style) + target `{deck}/images/{slug}.png`. image-gen owns whether Codex is available; it generates or returns a prompt. |
| **Placeholder** | image-gen unavailable / deferring generation | `<div class="image-placeholder" data-img="{key}" data-image-prompt="{real prompt naming the style}">`; append `{key} · {key}.png · {prompt}` to `{deck}/images/PROMPTS.md`. User generates later → drops into `images/` → run place-images (below). |

First ensure `{deck}/images/` + `{deck}/images/PROMPTS.md` exist.

**Calling image-gen:** invoke the `image-gen` skill with the prompt + output dir; it handles Codex-or-not. If it's not installed in this environment, drop to the Placeholder branch instead — don't shell out to Codex yourself.

Anti-patterns: ❌ raster of a diagram (use SVG) · ❌ bare placeholder with no `data-img` key or prompt · ❌ mixing image styles in one deck.

### Shapes: grab existing, don't hand-roll
- **Real-world** (maps, icons, common diagrams) → grab existing SVG. Icons: Lucide/Heroicons/Tabler via jsDelivr (no API key). Maps: Wikipedia Commons (recolor via `mask-image`/`fill:currentColor`). Charts: D3 examples.
- **Brand-abstract** (sparkle, rosette, pill) → hand-roll with CSS `clip-path`/`border-radius`. The shape IS the design.

### Hard gate: modern-web features → consult the guide FIRST
If the slide touches scroll-driven animation, view transitions, container queries, `:has()`, `popover`/`dialog`, `text-wrap:balance`, `field-sizing`, `mask`, `color-mix`, `oklch`, anchor positioning — **before writing CSS** run `npx -y modern-web-guidance@latest search "{topic}"` then `… retrieve "{id}"`. The gotchas (Firefox lacks scroll-timeline → IntersectionObserver fallback; CSS `transform` overrides an SVG `transform` attribute → use the `scale` property) only surface in the guide or the browser.

### Verify-visually-or-flag
After any animated/interactive output, include EITHER a screenshot at key states (0/33/66/100% scroll) OR an explicit "VERIFY: needs your eyes at scroll 0/33/66/100%" flag. Never claim animation works without rendering it.

### place-images (after images land in the folder)
`python3 <this-skill>/scripts/place-images.py {deck}/slides.html {deck}/images/` — fuzzy-matches `data-img` keys to filenames (`hero-flow` ← `Hero_Flow_v2.png`), injects `<img>`, reports unmatched placeholders + unused files. Idempotent.

---

→ Next: `sop/review.md` (always check before deploy)
