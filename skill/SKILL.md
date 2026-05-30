---
name: slide
description: >
  The one skill for making slide decks — idea → research → outline → built HTML deck → review → deploy.
  Routes to per-phase SOPs under sop/. The core move is FORK A REFERENCE DECK, never describe a style in
  prose — a reference deck is a complete working visual system; clone it and swap content. Builds a
  self-contained scroll-snap HTML deck (audience layer + speaker layer, presenter chrome) — not
  PowerPoint/Keynote/Google Slides. Use this skill whenever the user wants to make / build / write /
  outline / review / score / deploy a slide deck or presentation — including "làm slide", "viết slide",
  "tạo deck", "slide outline", "research for a talk", "turn this PRD/doc/notes into slides", "score my
  deck", "is this deck good", even if they don't say the word "slide" but clearly need a talk built.
  Calls the image-gen skill for raster images. DO NOT use for .pptx/Keynote/Google Slides files, single
  one-off graphics, or pure SVG/icon work with no deck around it.
---

# slide — one skill, several SOPs

Making a deck is a pipeline. This skill is a thin router; the actual procedure for each phase lives in `sop/`. Read the SOP for the phase you're in, do exactly that, move to the next.

## The pipeline

```
IDEA → brainstorm → research → create → review → retro → deploy
(human)   sop/        sop/       sop/     sop/     sop/    sop/
                                  ↑ Step 2 = STYLE GATE (matrix-based, not auto-fork)
                                  ↑ Step 4 = image step (calls image-gen skill)
```

**Two HARD GATES in the pipeline that the skill must NEVER skip:**
- After brainstorm: user approves brainstorm.md before research starts
- After Step 2b of create: user approves fork choice before slides.html is written

Silent defaults are forbidden. See `references/style-decision-matrix.md` for the fork-choice rationale.

## Pick the SOP

| You are… | Read | One-line |
|---|---|---|
| user has raw material but no clear angle (no brainstorm.md) | **`sop/brainstorm.md`** | 5-stage interview: JTBD + HDT + 5 Whys + SCQA/Pixar → writes brainstorm.md |
| gathering evidence for an existing brainstorm.md | `sop/research.md` | claims + examples, 5 insight techniques → Action Titles |
| building the slides.html | **`sop/create.md`** | fork a reference deck, swap content, keep chrome; image step (incl. calling image-gen) is here |
| inventing a NEW look (from a reference image / prompt / brand) | **`sop/new-style.md`** | extract DNA → fill the token contract → bake + verify + register a new style. The gallery isn't a closed menu. |
| checking if the deck is good | `sop/review.md` | mechanical (`scripts/slide-check.sh`) + quality vs `references/slide-method.md` → SHIP/FIX/REWORK |
| closing the loop after a deck | `sop/retro.md` | write a retro, deposit ONE reusable so the next deck starts richer |
| shipping it | `sop/deploy.md` | static host (e.g. GitHub Pages), `.nojekyll`, postBuffer gotcha |

## The studio scaffold this skill assumes

This skill expects a small project layout in the **working directory** (the host project, NOT inside the skill). If these folders don't exist, create them on first use:

```
00-foundation/    me.md                  ← human: who the WORKSPACE OWNER is (skill `me`); for "about me / my office" decks
20-decks/{date-name}/                    ← one folder per deck — EVERYTHING per-deck:
                  audience.md             ·  who's listening to THIS deck (from inbox/{event}/_audience.md)
                  brainstorm.md           ·  human's angle
                  claims.md · examples.md ·  research
                  outline.md · slides.html
                  images/ (+ PROMPTS.md)
40-assets/        reference-deck/         ← deck(s) to fork (the visual-system gallery)
                  method/ · image-prompts.md
50-retro/         {date}-{deck}.md
```

If the host has no reference deck yet, the create SOP builds the first one. Paths like `40-assets/…` below are **host-project paths**, relative to the working directory — they are not bundled in this skill.

## What IS bundled in this skill (travels in the package)
- `scripts/slide-check.sh` — mechanical linter (review SOP)
- `scripts/place-images.py` — fuzzy image placer (create SOP, after images are generated)
- `references/slide-method.md` — the methodology (the quality bar for review)
- `references/template-slide-outline.md` — outline shape
- `references/build-details.md` — deep detail: presenter chrome JS, style gallery, known traps

## Dependency: the image-gen skill
The create SOP does NOT shell out to Codex directly. When a slide needs a raster image, it **calls the `image-gen` skill** (which owns the Codex / no-Codex / placeholder logic). If `image-gen` isn't installed, the create SOP falls back to emitting a placeholder + prompt (see that SOP).

## The one invariant across all SOPs
**A `slides.html` is TWO co-located documents: what the audience SEES (one idea + image) and what the speaker READS (`.stage-strip`, toggled with `S`). Never make the speaker read off the slide.** Presenter chrome (Esc grid, S toggle, hash-sync-by-id, derived count, @media print) is kept verbatim no matter the style.

## The core principle
**Don't describe a style — fork a deck that already has it.** A reference deck is a complete visual system: CSS tokens + layout blocks + chrome. Cloning + swapping content is fast and never drifts.

**A genuinely new look is BAKED, not described** — and the gallery is a starting set, not a closed menu. When the user brings a reference image, a prompt, or their brand, run `sop/new-style.md`: it extracts DNA (palette · type · density · ONE signature move) into the fixed **token contract** (`40-assets/reference-deck/_TOKENS.md`), builds the one signature primitive, bakes a reference deck, and registers it. The presenter chrome + layout engine never change — only token VALUES — so unlimited new styles are possible WITHOUT drift. Each baked style joins the gallery as a forkable seed.
