# SOP — retro (close the loop, make the studio learn)

> After review, around deploy. Without this, the studio never compounds.
> Paths are HOST-PROJECT paths (relative to the working dir).

## Two things
1. Write `50-retro/{YYYY-MM-DD}-{deck}.md` — a 3-part look-back.
2. **Propose exactly ONE asset to deposit into `40-assets/`** — the compounding step.

## Procedure
1. Read the shipped deck (`{deck}/outline.md` + `slides.html`) and the deck's `brainstorm.md` (intent vs result).
2. Pull the review verdict (from `sop/review.md`) into the retro.
3. Write the retro (template below).
4. Pick the single highest-leverage reusable and ask the human to approve depositing it:
   - a prompt that produced a good image → `40-assets/image-prompts.md`
   - a layout/look worth forking → copy `slides.html` to `40-assets/reference-deck/` (a NEW reference deck in the gallery)
   - a sharper `audience.md` line → update that deck's `{deck}/audience.md` (audience is per-deck)
   - a method insight → `40-assets/method/`
5. You propose; the human decides (principle #2). Then write it.

## Template
```markdown
# retro — {date}-{deck}
## Cái gì chạy được
- …
## Cái gì cần sửa lần sau
- …
## Deck-review score
- Verdict: {SHIP/FIX-FIRST/REWORK} · Story Test: {pass/fail + through-line}
- Recurring weak spot to watch next deck: {…}
## ➜ Tài sản gửi vào 40-assets/
- **1 thứ học được:** "{the reusable}" → {where it went}
```

## The rule
End every retro with **"1 thứ học được" + where it was deposited.** If you can't name one reusable, the deck taught the studio nothing — say so honestly, don't invent one.

→ Next: `sop/deploy.md`
