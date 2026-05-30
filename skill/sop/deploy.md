# SOP — deploy (static host, e.g. GitHub Pages)

> Only after review passed (SHIP or FIX-FIRST with fixes applied). Paths are HOST-PROJECT paths.

## Steps
1. Ensure `.nojekyll` at repo root (so `_`-prefixed files don't 404; also speeds the build).
2. For image-heavy decks: `git config http.postBuffer 524288000` (avoids push hangs).
3. Commit the deck folder (`20-decks/{deck}/` incl `slides.html` + `images/`).
4. Push to the Pages branch (pattern: `vibery-studio/...` style repo, deck served at a subpath).
5. Confirm the live URL loads + a deep-link (`#slide-id`) works.

## Gotchas
- Separate CSS files must NOT be `_`-prefixed.
- Hash deep-links break if chrome was built with `"slide-"+n` — the review linter catches this; don't deploy past a hard ✗.
- Placeholder images 404 online until the real PNG is added — run the place-images step first if the deck has any.

Live URL in ~30s. Done → make sure `sop/retro.md` ran so the asset compounds.
