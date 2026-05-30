---
type: workshop-slide-outline
workshop: {{workshop-slug}}
session: {{N — or "talk" for a standalone}}
status: draft-for-review
created: {{today ISO}}
duration: {{e.g. "20 min on stage" / "180 min"}}
target_count: {{e.g. "8 slides" / "28-32 slides"}}
reference_deck: {{path to the slides.html this one forks structure from}}
brand: {{"Moleskine house style" / "Anthropic brand guidelines" / "technical-0426" / named}}
design_principles:
  - one idea per slide (more than one → two slides)
  - speaker notes ≠ slide content (script lives in .stage-strip, audience sees idea + image)
  - image > words where the image carries the idea
  - 22pt minimum body, breathing room
  - presenter chrome kept regardless of style (Esc grid, S stage-toggle, @media print)
  - images generated out-of-band via Codex (ChatGPT Plus), dropped into images/
---

# {{Workshop}} — {{Session N / Talk}} · Slide Outline

> Design intent: slides are **for the audience to look at and remember**, not for the speaker to read off. Speaker notes carry the script (`.stage-strip`, hidden with `S`). Slides carry the image and ONE idea. More than one idea on a slide → it's two slides.

## Visual system

> Forked from `{{reference_deck}}`{{ + brand: {{brand}}}}. Recolour/retype below; keep the structure + presenter chrome.

- **Palette:** {{list the hex values actually used — e.g. dark #141413, light/cream #faf9f5, accent #d97757 (sparingly), ...}}
- **Fonts:** {{headings / body / hand-display / mono — with fallbacks}}
- **Accent treatments:** {{e.g. "thick underline under ONE key word per slide", "hand-circled word", "big quote in display font"}}
- **Layout blocks in use:** {{which of: .cmp2/.cmp3, .doors.n4/.n5, .ladder3, .grid-2x2, .bigquote, .demo-frame, .activity .timer, full-image slide, .deeplinks}}
- **Image style:** {{e.g. "Moleskine hand-drawn ink on cream paper, no faces" / "Anthropic-brand flat diagram" — every image prompt must name this explicitly}}
- **Interaction patterns:**
  - distinction → side-by-side / 3-column compare
  - steps → progressive reveal / flowchart
  - anchor → big quote
  - whiteboard moment → the slide is a prompt, not an answer
  - hands-on beat → activity slide with a giant timer
  - presenter: `Esc`/`G` = grid overview · `S` = toggle stage cues · `F` = fullscreen · arrows/space = nav

---

## Slide-by-slide map ({{duration}}, {{target_count}})

> The **Speaker note hook** column is SEPARATE from the Slide column on purpose. The slide is what they see; the hook is what you say. Never collapse them.

{{Optionally split into Part 1 / Part 2 / Part 3 with sub-headers + timing.}}

| #   | Slide                          | Type            | Image / asset                                  | Speaker note hook                                    |
| --- | ------------------------------ | --------------- | ---------------------------------------------- | ---------------------------------------------------- |
| 1   | {{Title — "..."}}              | hero            | {{image needed, or "—"}}                       | {{what you say opening this slide — the .stage-strip}} |
| 2   | {{...}}                        | {{type}}        | {{...}}                                        | {{...}}                                              |
| ... |                                |                 |                                                |                                                      |

---

## Image-generation list (for Codex)

> Generate via Codex CLI (`codex exec -i ref.png -- "prompt"`, ChatGPT Plus — no API key). Output lands in `~/.codex/generated_images/`; rename + drop into `images/` as `slide-NN-slug.png`. The HTML placeholders activate automatically (`:has(img)`). Or use the workshop folder's batch-generate pipeline if present.
> **Every prompt seed must name the image style explicitly** (see Visual system → Image style).

| Slide # | Image needed                   | Prompt seed                                                                 |
| ------- | ------------------------------ | --------------------------------------------------------------------------- |
| 1       | {{hero — ...}}                 | {{"...{style}... composition of ..."}}                                      |
| ...     |                                |                                                                             |

{{N}} images · ~3 min each via Codex · ~{{N×3}} min total.

---

## Build checklist (phase 2)

- [ ] Outline approved by Tony
- [ ] Style decided + recorded in frontmatter (`reference_deck`, `brand`)
- [ ] `slides.html` built: forked `<style>` + `<script>` from reference deck, `:root` recoloured, fonts swapped
- [ ] One `<section class="slide" id="slide-N" data-title="...">` per row, with `<!-- type: ... -->` comment
- [ ] `.image-placeholder` on every image slide, carrying `data-image-prompt`
- [ ] `.stage-strip` on EVERY slide — beat # + timing + the one cue
- [ ] Presenter chrome intact: auto-numbering, hash deep-links, `Esc` grid, `S` toggle, `F` fullscreen, `@media print`
- [ ] Two photograph-it slides identified + made most legible
- [ ] No unverified facts on any slide (external tech → grep `90-inbox/research/` first)
- [ ] (optional) `refs/*.html` deep-dive pages + `.deeplinks` chips
- [ ] images/ list complete → handed to Codex (phase 3, out-of-band)
