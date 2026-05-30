# Build details (reference) — style gallery, presenter chrome, KNOWN TRAPS

> Deep reference for `sop/create.md`. Forked from the old creating-slide skill. The HOW-TO is in the SOPs; this holds the long detail (reference deck gallery, exact chrome JS, trap table).

# creating-slide — Build a workshop slide deck (the Tony way)

## The one invariant this skill enforces

**A `slides.html` is TWO co-located documents in one file: (1) what the audience sees, (2) what the speaker reads — and they are different.** The slide carries ONE idea + (usually) an image. The speaker's script lives in the same HTML but in a layer the audience never sees (`.stage-strip`, toggled off with the `S` key). You write *both* into the deck. **You never make the speaker read off the slide.**

Everything else — colours, fonts, layout vocabulary — is per-deck. Don't overfit to one style.

## What this produces

In `workshops/{workshop}/{session-N}/slides/` (or wherever the talk lives):
- **`SLIDE-OUTLINE.md`** — the source of truth. Reviewed and agreed BEFORE any HTML.
- **`slides.html`** — the deck. Self-contained: HTML + CSS + inline JS, no build step.
- **`images/` prompt list** — appended to the outline; the PNGs themselves are generated **out-of-band via Codex** (see IMAGES section). Placeholders in the HTML carry the prompt and auto-activate when the PNG lands.
- **`refs/*.html`** (optional) — deep-dive companion pages, linked from slides via a `.deeplinks` chip.

## The pipeline — 3 phases, NEVER collapsed

```
1. SLIDE-OUTLINE.md  →  Tony reviews & agrees  →  2. slides.html  →  3. images via Codex
   (the thinking:                                  (mechanical:        (out-of-band:
    content + script,                               fork a reference    drop PNGs into
    two columns)                                    deck's style)       images/, done)
```

**Hard gate: do not write `slides.html` until the outline is approved.** (Tony, 04-21: "khi chúng ta thống nhất được về cấu trúc và script, thì mới chuyển qua làm slide.") If Tony hands you an already-approved outline, skip to phase 2.

## PHASE 1 — SLIDE-OUTLINE.md

Render `references/template-slide-outline.md`. It has:
- **Frontmatter:** `session`, `status: draft-for-review`, `design_principles` (the checklist below), `target_count`, and `reference_deck` + `brand` (which deck/guideline this one forks from — see PICK-A-STYLE).
- **Visual-system section:** the chosen palette (hex), fonts, accent treatments, which layout blocks this deck uses, and the interaction patterns in play. Filled from the reference deck + any brand guideline, NOT invented from scratch.
- **Slide-by-slide table:** `# · Slide title · Type · Image/asset · Speaker note hook` — the **Speaker note hook column is separate from the Slide column**. That separation is the whole point.
- **Image-generation list:** `slide # · image needed · prompt seed` — built bottom-up from the table. Each prompt seed references the chosen visual style explicitly.

If the talk's content/structure already exists (e.g. an `OUTLINE.md` from a brainstorm or workshop-prep skill), READ IT and turn it into this table — don't re-decide the talk. If it doesn't, run a short interview first (see INTERVIEW).

After drafting, present the outline and ask: "Right? Anything to change before I build the HTML?" Wait for yes.

## PHASE 2 — slides.html

### PICK-A-STYLE (do not overfit)

Each deck can look different. Decide the style BEFORE building, record it in the outline frontmatter:

| If the talk is… | Fork from | Notes |
|---|---|---|
| A Tony workshop, default | `workshops/workshop-20260504-ai-orchestration-product-team/session-1/slides.html` or `session-2/slides/slides.html` | Moleskine cream-paper / hand-drawn aesthetic, Be Vietnam Pro + Lora + Caveat. The current house style. |
| "Building app without UI" lineage / technical | `_archive/workshop-20260426/session-2/slides.html` and `session-3/slides.html` | Anthropic-ish dark/cream palette, more diagram-heavy. |
| Earlier reference | `_archive/workshop-20260422-vinuni-ai-product-design/session-1/slides.html` | Older but valid. |
| **An Anthropic / Claude-branded deck** | The reference deck for layout + structure, BUT recolour/retype to **Anthropic brand guidelines** | Read the `brand-guidelines` skill (anthropics/skills) if installed, or its hex set: Dark `#141413`, Light `#faf9f5`, Mid `#b0aea5`, Light-gray `#e8e6dc`, Orange `#d97757` (primary accent), Blue `#6a9bcc`, Green `#788c5d`; Poppins (headings, fallback Arial) + Lora (body, fallback Georgia). Apply the brand's restraint — orange sparingly, generous whitespace. |
| Something new | Tony names it; you fork the *structure* from a reference deck and restyle. | Always keep the presenter chrome + the audience/speaker split regardless of look. |

**What you ALWAYS keep, no matter the style:**
- The audience layer / speaker layer split (`.stage-strip` for notes, `S` to toggle).
- The presenter chrome JS verbatim — auto slide-numbering, URL-hash sync (deep links, no slide-1 flash), **`Esc` (or `G`) grid overview**, `F` fullscreen, arrow/space/PageDown nav, `S` stage-cue toggle, `@media print` (scroll-snap off, one slide per page, chrome hidden). **Fork the chrome `<script>` from `workshops/workshop-20260504-ai-orchestration-product-team/session-2/slides/slides.html`** (the newest good one) and copy its `.stage-strip` / `.bar` CSS. Two things the chrome MUST do right, because the cxo deck broke both: **(a) hash sync matches by EXACT slide id** (`slides.findIndex(s => s.id === hash)`), never `"slide-" + n` — ids are arbitrary strings (`slide-cover`, `slide-quote`, `slide-thanks`), a numeric assumption silently breaks every deep-link the moment the deck is restructured; **(b) the presenter total is `document.querySelectorAll(".slide").length`**, never a hand-typed number — a restructure must re-count itself. If the deck has tabbed slides (kitchen-tabs pattern), also carry the `T`-key tab-cycle handler.
- Scroll-snap deck (`scroll-snap-type: y mandatory`, each `.slide` `min-height: 100vh`, centered flex column).
- `.image-placeholder` pattern — aspect-locked dashed box carrying `data-image-prompt`, `:has(img)` strips the scaffolding once the PNG is in. (This is how phase 3 plugs in without touching layout.)
- Self-contained: one HTML file, Google Fonts via `<link>`, inline `<style>` + `<script>`. No bundler, no framework. **CSS that genuinely must be a separate file (e.g. shared across `refs/*.html`) MUST NOT be `_`-prefixed** — GitHub Pages runs Jekyll, which skips `_`-prefixed files, so `_story.css` 404s online while working locally. Name it `story.css` / `ref.css`, and drop a `.nojekyll` at repo root.

### Build it

One shot. Open the reference deck, copy its `<style>` block + `<script>` block, recolour `:root` + swap fonts per the chosen style, then for each row in the outline table emit:

```html
<section class="slide [layout-class]" id="slide-N" data-title="...">
  <span class="slide-num"></span>          <!-- auto-filled by the script -->
  <div class="wrap">
    <div class="slide-kicker">...</div>    <!-- small uppercase mono, optional -->
    <h1>... <span class="[accent-class]">one key word</span> ...</h1>
    <!-- layout block: .cmp2/.cmp3, .doors.n4/.n5, .ladder3, .grid-2x2,
         .bigquote, .demo-frame, .activity .timer, OR a full-image slide -->
    <div class="image-placeholder [.aspect-*]" data-image-prompt="...">
      <img src="../images/slide-NN-slug.png" alt="..." onerror="this.style.display='none'" />
      <div class="placeholder-label">[Image #N · short desc]</div>
      <div class="placeholder-prompt">...the prompt...</div>
    </div>
    <div class="stage-strip">▸ Beat N · ~M min. <b>the one cue you must not forget</b> · then →</div>
  </div>
</section>
```

Put a `<!-- type: ... -->` comment above each slide (the type vocabulary IS the spec — see TYPES). **Put a `.stage-strip` on EVERY slide** with the beat number, timing, and the single cue that matters. Don't hand-number slides — the script does it.

## PHASE 3 — images (delegate to the `image-gen` skill)

**Images are generated OUT-OF-BAND via the `image-gen` skill** — which calls Codex CLI's built-in imagegen skill (ChatGPT Plus/Pro sub, no API key; Codex CLI is a coding agent, not an image generator — it has an imagegen skill you invoke through it). This skill (`creating-slide`) just feeds `image-gen` the prompt list and wires the results back. Phase 3 here:
1. Make sure the outline's image-generation block is complete — one row per `.image-placeholder` in the HTML: `{ name = the filename slug, scene, optional `-i` refs }`. Each prompt opens with the **chosen image-style string** (see PICK-AN-IMAGE-STYLE below — default `brand-flat-editorial`).
2. Hand that list to `image-gen` (run `image-gen/scripts/img-batch.sh <list> --out slides/images/ --style "{STYLE STRING}"`, or do the background-batch-then-harvest procedure inline). It runs the `codex exec` calls in the background, harvests from `~/.codex/generated_images/`, copies PNGs into `slides/images/` as `slide-NN-slug.png` — the `.image-placeholder` / `:has(img)` machinery picks them up automatically. Or just tell Tony: "N images to generate — the list is at the bottom of SLIDE-OUTLINE.md; run `/image-gen` on it."
3. Don't block the deck on images — `slides.html` is presentable with dashed placeholders; PNGs slot in later. Image-heavy `git push` afterwards needs `git -c http.postBuffer=524288000 push`.

### PICK-AN-IMAGE-STYLE (per-deck — decide it, record it in the outline frontmatter)

The image-style options + their verbatim style strings + reference sets live in **`image-gen/references/styles.md`**. The short version: **`brand-flat-editorial`** is the default for AI / Claude-branded decks (clean line work on cream, one orange accent, no faces, lots of air — reference set: the cxo deck's `slides/images/` + `refs/img/`); **`moleskine-notebook`** for Tony-personal teaching decks (hand-drawn notebook page — see memory `reference_workshop_image_style.md`). Pick one, put its name in the outline frontmatter, and feed `image-gen` that style string for every prompt. **The deck CSS and the image style must agree** — a brand-flat deck gets brand-flat images, not Moleskine ones. And the corollary still holds: **no image of text** — checklists / photograph-it cards / numbered reference lists stay HTML; images are for *scenes and metaphors*.

### The image procedure — owned by the `image-gen` skill

The full how-to (the working `codex exec` invocation, `env -u OPENAI_API_KEY`, the `--` separator, the background-batch rule, harvesting from `~/.codex/generated_images/` by call order, the `-i` reference packs) lives in **`40-artifacts/skills/image-gen/`** — read its `SKILL.md` + `references/styles.md`, or just run `image-gen/scripts/img-batch.sh`. Don't re-derive it here; `creating-slide` produces the deck and the prompt list, `image-gen` produces the PNGs. Key reminders only: **Codex CLI isn't an image generator** — it has an imagegen skill you invoke (`-- "Use the imagegen skill. …"`); generation is **always background** (~minutes/image, you'll be notified); a `couldn't copy` line in Codex's output is expected (its `exec` sandbox is read-only); image-heavy `git push` needs `git -c http.postBuffer=524288000 push`.
4. `git -c http.postBuffer=524288000 push` — image-heavy pushes need the buffer bump or they fail mid-transfer (recurring; same as the 0504 deploy). Then Pages takes ~1 min to rebuild; a 404 on the new images right after pushing is just that, not a real failure.
5. Generated-but-unreferenced PNGs (you asked for 8, wired 5) are harmless — leave them in the folder. Don't regenerate to "use them up."

## KNOWN TRAPS (discovered live across the cxo build — check for these before deploy; `scripts/slide-check.sh` greps for them)

| Trap | What happens | Fix |
|---|---|---|
| **`display:grid` on an `<li>` that has inline `<b>`/`<i>` children** | The `::before` number becomes grid-cell-1 and the *first inline child* (`<b>từ vấn đề</b>`) becomes grid-cell-2 → the bold words get ripped out of the text and stacked vertically while the rest overflows. Looks fine in the CSS, broken in render. | Never grid-an-`<li>`-with-inline-children. Use absolute-positioned `::before` for the number + `padding-left` on the text. Wrap content in a single `<span>` if you must grid it. |
| **`_`-prefixed CSS/asset files** (`_story.css`, `_ref.css`) | GitHub Pages runs Jekyll, which skips `_`-prefixed files → 404 online, page renders unstyled. Works locally, so you don't catch it until you check the live URL. | Rename without the underscore (`story.css`). Add a `.nojekyll` file at repo root. |
| **Chrome `<script>` assumes numeric slide ids** (`"slide-" + n`) | Works while ids are `slide-1`…`slide-N`. The moment you add `slide-cover` / `slide-quote` / `slide-thanks` (you will), `hashIndex()` returns -1 → deep-links and hash-sync silently break. | Match by exact id: `slides.findIndex(s => s.id === hash)`. (Forking session-2's chrome gives you this already — but verify after any restructure.) |
| **Hand-typed presenter total** (`01 / 14`) | Every restructure (9→12→13→14…) drifts the count out of sync with reality. | Derive it: `total = document.querySelectorAll(".slide").length`. Never type the number. |
| **Manual `<br/>` mid-phrase in an h1/title** | Orphans single words ("suất", "dành cho sếp.") on narrow viewports / projectors. | Wrap each phrase-group in `<span class="nowrap">` so breaks land between groups; size with `clamp()` so it never overflows; relax `nowrap` under ~480px. No manual `<br/>` inside a phrase. |
| **Image of a text-dense slide** (a checklist, the photograph-it card) | A PNG of a checklist is less legible than the checklist, can't be selected, ages badly. Codex happily generates it; it goes unused. | Photograph-it / reference slides stay HTML. Generate images for *scenes*, not for *text*. |
| **Crowded slide** (3 takeaways + action + small image + QR all stacked; 4 cols × 6 items) | The audience layer has absorbed the speaker layer's density. | Split into two slides + add an image → or tabs (`T`-key) → or (last resort) shrink. See DESIGN PRINCIPLES. |
| **Ref/companion page as a wall of cards** | A deep-dive `refs/*.html` that's a dense canvas dump is worse than no ref — nobody reads it. | Make refs **scrollytelling**: dark hero (the complaint/headline) → numbered chapters, one image each (Codex) → a "punch" block (the verdict, big) → `<details>` collapsed for the full detail. Short by default, complete on demand. (See the cxo `refs/example-1.html` / `example-2.html`.) |
| **External asset paths in slides.html** (`<img src="/Users/.../Downloads/photo.jpg">`, `<img src="../../../inputs/profile.pdf">`) | Deck breaks the moment it's moved, zipped, deployed to Pages, or opened by anyone other than Tony on his own machine. "Self-contained" means SELF-contained. Also: PDFs of profiles / specs the deck refers to never get extracted for re-use later. | When Tony hands you an asset path outside the deck (avatar, profile PDF, sample doc, reference image): **(1) `cp` it into `slides/assets/`** with a clean name (`toan-avatar.jpg`, not `IMG_3294 (2) copy.jpg`); **(2) if it's a PDF Tony might want as text later, extract to `slides/assets/<slug>.md` in the same step** — saves him re-asking next time; **(3) reference only the local `assets/...` path** in the HTML. Apply this WITHOUT asking — it's the default behavior, not a question. |

## DEPLOY (when the deck goes online)

GitHub Pages, served from the repo: `slides/slides.html` + `slides/images/` + `slides/SLIDE-OUTLINE.md` + `refs/` (+ `refs/img/`, `refs/story.css`) + `examples/` source + an `index.html` at root that redirects to `/slides/slides.html` + a `.nojekyll`. Push with `git -c http.postBuffer=524288000 push`. Verify the live URLs (`curl -s -o /dev/null -w '%{http_code}'`) — `slides.html`, each ref, `refs/story.css`, the index — all should be 200; a fresh-push 404 just means Pages is still rebuilding (~1 min). For a phone handout (a prompt, instructions): don't make a Gist — point an `amy go` short link at the repo's raw `.md` (`go.bnqtoan.workers.dev/<slug>`), and the worker also serves `/qr/<slug>` so the QR renders live in the deck with nothing to host.

## INTERVIEW (only if no talk outline exists yet)

Short — the talk's content should mostly already exist. Single-shot via AskUserQuestion:
1. **What's the talk + how long?** (title, duration, # of beats/parts)
2. **Audience + format?** (who; live talk / hands-on workshop / videos-narrated — this sets deck length: a video-carried session = short deck, scaffolding between videos, NOT 30 slides)
3. **Style?** (default Moleskine / Anthropic-branded / technical-0426 / something named — see PICK-A-STYLE)
4. **Beat-by-beat content** — get the structure. If there's an `OUTLINE.md` already, read it instead of asking.

Then go to phase 1.

## TYPES (the slide-type vocabulary — doubles as build spec)

`hero` · `visual-recap` · `quote` · `big-quote` · `side-by-side-compare` (teach a distinction) · `3-column-compare` · `2-up-visual` · `visual-diagram` (teach a structure) · `demo` (frame border, speaker switches to terminal/screen) · `activity` (giant timer + one instruction, for hands-on beats) · `reveal` (progressive — same image gains an element) · `2x2-grid` · `ladder` (tiers) · `scorecard` · `setup` (QR / install instructions, often shown before the slot). Pick by *intent*: distinction → compare; steps → reveal/flowchart; anchor → big-quote; whiteboard moment → the slide is a prompt, not an answer; hands-on → activity.

## DESIGN PRINCIPLES (the checklist — independent of style)

- **One idea per slide.** More than one → split into two slides.
- **Speaker notes ≠ slide content.** The invariant. Script in `.stage-strip`, audience sees the idea + image. **A slide that reads like notes — multiple takeaways stacked, a paragraph, >~8 list items / grid cells visible at once — has leaked the speaker layer onto the audience layer. Fix it, in this order: (1) split into two slides + give one of them an image; (2) if it's genuinely one set that belongs together, use tabs (the `T`-key kitchen-tabs pattern from `workshop-20260504/session-2`) so only one panel shows at a time; (3) last resort, shrink the type — but if you're shrinking to fit, you're probably hiding a split.**
- **Image > words** where the illustration carries the idea (then it's a full-image slide). Style of the image follows the deck's chosen look. **Corollary: do NOT make an image of text.** A checklist, the photograph-it cards, a numbered list — those stay as crisp HTML (selectable, legible from the back); an image of a checklist is strictly worse than the checklist. (The cxo deck's gate card and 5-surfaces card stayed HTML for exactly this reason.)
- **22pt minimum body**; big-quote slides in the deck's hand/display font; breathing room.
- **The deck for a video/demo-heavy session is SHORT** — it's scaffolding between the real content, not the lesson.
- **Don't put facts on a slide you haven't verified.** External tech / install commands → grep the vault research first (`90-inbox/research/`), then official docs. "Không thể nói sai ở đây được."
- **Two photograph-it slides max** per talk — the ones you actually want people to capture. Make those the most legible.
- **Pick one structural motif and apply it to every slide of that shape.** If one slide gets a treatment (e.g. the editorial "manifesto rail" — hairline left rule, mono `01/02/03` index, crescendo type, staggered fade-in), the deck's other slides of that shape (the close, another three-line beat) must rhyme with it. The opening and closing should be visual bookends. One-off styling on a single slide reads as a mistake.

## ANTI-PATTERNS — DO NOT

- Build `slides.html` before the outline is agreed → rework. The gate is real.
- Put the script ON the slide (audience reads along; deck becomes a teleprompter).
- More than one idea on a slide.
- Hardcode last deck's palette/fonts as if they're mandatory — they're not; pick the style per talk.
- Drop the presenter chrome (`Esc` grid, `S` stage toggle, `@media print`) — keep it regardless of style.
- Hand-number slides — the script auto-numbers.
- Generate images before content is final → regenerate. Images are LAST and out-of-band.
- Generate images via any API key — use **Codex's imagegen skill** (`env -u OPENAI_API_KEY codex exec … -- "Use the imagegen skill. …"`, ChatGPT Plus sub). And don't say "Codex generates the image" — Codex is a coding agent that has an imagegen skill; invoke the skill.
- Let the deck do the teaching when a video or live demo should — short deck, more demo.
- Forget the image-generation list at the bottom of the outline — without it, phase 3 has nothing to run.
- Grid an `<li>` that has inline `<b>`/`<i>` children, `_`-prefix a CSS file, hand-type the slide count, hard-`<br/>` a title mid-phrase, or make a PNG of a checklist — see KNOWN TRAPS, all four are silent and all four bit the cxo deck.
- Ship a deck where one slide has a unique treatment and its sibling-shape slides don't — pick a motif, apply it to every slide of that shape.
- Push an image-heavy deck without `git -c http.postBuffer=524288000`, or `_`-prefix anything in a Pages repo without a `.nojekyll`.
- Reference any asset (avatar, profile PDF, reference image, sample doc) from outside the deck folder — `cp` it into `slides/assets/` with a clean name first, and if it's a PDF, also extract to `assets/<slug>.md` for later re-use. **Apply silently — never ask Tony to confirm the copy.** The deck must work the moment you `mv` the folder anywhere.

## When NOT to use this skill

- They want a `.pptx` / Keynote / Google Slides file → wrong shape; this builds an HTML deck.
- A single graphic or one-off image → not a deck.
- A document/report that happens to have "slides" of text → that's a doc, not this.
- The talk content doesn't exist yet and they don't want to define it → run a brainstorm / workshop-prep skill first to get the OUTLINE, then come back.
