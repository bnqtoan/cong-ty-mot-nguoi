---
type: skill-reference
applies-to: sop/create.md Step 2 (fork-choice gate)
audience: AI building decks via the slide skill
status: canonical 2026-05-29
---

# Style decision matrix — which reference deck to fork

> **The rule:** a deck's style is not "what looks nice." It's the match between **content temperament** and **audience register**. Wrong style = audience disengages before content lands.
>
> **When this runs:** `sop/create.md` Step 2, BEFORE forking any reference deck. Skill must propose top 2 candidates with rationale, get user approval, then fork.

## Why this exists

The skill was shipping decks with the wrong style — most painfully, an IELTS teaching deck got forked to a navy + lime tech-brand style because the skill defaulted to its own fallback instead of matching content to audience. Pedagogical content + student audience = warm cream editorial, not enterprise dark.

This matrix forces the decision to be explicit and justified, not silent.

## The 2 axes

### Axis 1 — Content temperament (read from `brainstorm.md`)

What is the deck *doing*? Six temperaments:

| Temperament | Signals in brainstorm.md | Visual demands |
|---|---|---|
| **Data-heavy / analytical** | "review", "Q3", "KPI", "metrics", "numbers", investor/board language | confident hierarchy, restrained accent, room for charts |
| **Pedagogical / teaching** | "class", "students", "rubric", "framework", "examples of", "how to" | warm, low cognitive load, generous whitespace, scaffolding |
| **Creative / persuasive** | "pitch", "campaign", "concept", "big idea", "brand", "story" | bold typographic, strong visual identity, room for mood |
| **Technical / engineering** | "architecture", "stack", "API", "workflow", "build", "implementation" | dark or bright tech feel, mono accents, diagram-heavy |
| **Personal / story-led** | "my journey", "what I learned", "founder story", "keynote" | editorial warmth, illustrations over diagrams, less structure |
| **Sales / conversion** | "landing", "convert", "sign up", "buy", "register", public webinar | bold typographic, large hierarchy, single CTA per moment |

### Axis 2 — Audience register (read from `{deck}/audience.md`, per-deck)

Who's listening? Five registers:

| Register | Signals in audience.md | Style demands |
|---|---|---|
| **Peer / alumni / operator** | "alumni", "Claude Code users", "founders", "already know X" | editorial italic, peer-to-peer voice, no scaffolding |
| **Executive / investor / board** | "investor", "board", "VC", "CFO", "exec", "decision-maker" | confident pitch, hierarchy, accent restraint |
| **Student / learner** | "students", "trainee", "band X", "learning", instructor language | warm, scaffolded, plenty of anchors, high readability |
| **Creative professionals** | "designers", "agency", "brand team", "art director", "CD" | strong visual identity, bold typographic, room for craft |
| **Mass consumer / mixed** | "general audience", "consumer", "public webinar", broad demo | bold typographic, large hierarchy, no insider jargon |

## The intersection grid

Six temperaments × five registers = 30 cells. Not every cell needs a unique style — many collapse. Below is the recommended fork per cell, drawing from the 4 reference decks currently shipped (v1/v2/v3/v4) + 2 future styles (Moleskine personal + Stellar bold).

```
                  PEER      EXECUTIVE     STUDENT      CREATIVE     MASS
DATA-HEAVY        v2-cream  v3-pitchdeck  v2-cream     v4-rosette*  v3-pitchdeck
PEDAGOGICAL       v2-cream  v2-cream      v2-cream     v2-cream     v2-cream*
CREATIVE          v4-rose   v3-pitchdeck  v2-cream*    v4-rose      v4-rose
TECHNICAL         v1-flat   v1-flat       v2-cream*    v1-flat      v1-flat*
PERSONAL          v2-cream  v2-cream      v2-cream     v2-cream     v2-cream
SALES/CONVERSION  v2-cream* v3-pitchdeck  v2-cream     stellar      stellar
```

(`*` = override possibility; see "Overrides" below)

### Read it this way

When skill is about to fork, do the intersection lookup. Examples:

- IELTS class deck → **Pedagogical × Student → v2-cream** ✓ (the bug case)
- F&B Q3 investor review → **Data-heavy × Executive → v3-pitchdeck** ✓
- Agency Tết pitch → **Creative × Creative → v4-rosette** ✓
- AI architecture talk for engineers → **Technical × Peer → v1-flat** ✓
- Founder keynote for mass audience → **Personal × Mass → v2-cream** ✓

## The 4 currently-shipped reference decks (the forkable inventory)

Each canonical reference deck has a frontmatter block declaring its temperament+register fit. The skill reads these.

### v1 — brand-flat-editorial (navy + lime)
`40-assets/reference-deck/2026-05-29-s1-slide-pipeline/slides.html`
- **Temperament fit:** Technical, Data-heavy (tech context)
- **Register fit:** Peer (operators, devs), Executive (tech-savvy)
- **Visual DNA:** navy #10203a + lime #c6f24e accent, Be Vietnam Pro 800, JetBrains Mono for meta
- **Don't use when:** student audience, pedagogical content, creative pitches

### v2 — cream + Fraunces italic + orange
`40-assets/reference-deck/2026-05-29-s1-slide-pipeline-v2/slides.html`
- **Temperament fit:** Pedagogical (default), Personal, Data-heavy (when peer), Sales (when peer/student)
- **Register fit:** Peer, Student, Mass (with adjustments)
- **Visual DNA:** cream #faf9f5 + Fraunces italic + orange #d97757, generous whitespace
- **Don't use when:** dark-room executive pitch, agency creative show

### v3 — pitchdeck (sage green + cream)
`40-assets/reference-deck/2026-05-29-s1-slide-pipeline-v3-pitchdeck/slides.html`
- **Temperament fit:** Data-heavy, Sales (executive), Creative (executive)
- **Register fit:** Executive, Mass (data-heavy)
- **Visual DNA:** sage #1f3a2e bg, cream type, sage pill accents
- **Don't use when:** student audience (too formal), technical content (wrong vibe)

### v4 — rosette (charcoal + violet + orange)
`40-assets/reference-deck/2026-05-29-s1-slide-pipeline-v4-rosette/slides.html`
- **Temperament fit:** Creative, Sales (creative)
- **Register fit:** Creative pros, Peer (when creative)
- **Visual DNA:** charcoal #161616 + cream + violet/orange chips, rosette glyph
- **Don't use when:** pedagogical (too bold), data-heavy (chips fight numbers)

## Overrides (when matrix says one thing, content says another)

The matrix is a default, not a rule. Override when:

1. **Brand mandates** — client requires their dark theme even though content is pedagogical
2. **Continuity** — this is deck #2 in a 3-part series; match the series style
3. **Counter-positioning** — pitch deck wants to LOOK like a teaching deck for warmth (executive + cream)
4. **Explicit user pick** — user named a fork target in brainstorm.md or in the inbox CLAUDE.md

When overriding, the skill must DECLARE the override in the proposal: *"Matrix says v3-pitchdeck (Data × Executive), but I'll override to v2-cream because [reason]. OK?"*

## The proposal format

When the skill reaches Step 2 of create SOP, it presents:

```
Style proposal — fork choice:

CONTEXT:
- Temperament: {pedagogical} (signal: rubric + 12 students + band 5.5→6.5 framing)
- Audience: {student} (signal: instructor-to-student register, IELTS band markers)

TOP 2 CANDIDATES:

1. v2-cream + Fraunces italic + orange  ← RECOMMENDED
   Why: pedagogical × student = warm + scaffolded + readable.
        Cream reduces cognitive load for new concepts.
   Tradeoff: less "wow factor" than bolder decks; intentional for learning.

2. v3-pitchdeck (sage)
   Why: alternative if instructor wants more confidence/structure feel.
   Tradeoff: sage reads formal/corporate; can feel distant from learners.

OK with #1? Say "yes" / "go #2" / "different style: X"
```

User answers. Skill forks the approved deck. Writes `<!-- fork: v2-cream · rationale: pedagogical × student -->` as audit trail comment near top of slides.html.

## Mechanical check

`slide-check.sh` check #17 verifies: every shipped slides.html has a `<!-- fork: {ref-deck} · rationale: {text} -->` comment within first 30 lines. Missing = build failure. This forces the audit trail to be in every deck.

## When the matrix doesn't have a good answer

If the intersection cell is `*` (collapse) or the deck is genuinely novel (e.g., "experimental brutalist deck for kids' coding class"), the skill should:

1. Say: *"Matrix doesn't have a strong default for this. Closest options: A, B."*
2. Offer the choice
3. After build, recommend adding this deck as a new reference + matrix update for next time

That's how the compound loop reaches the style system: new styles enter the matrix via real decks that needed them.

## Integration with rest of skill

- `sop/create.md` Step 2 — gates on this matrix
- `sop/retro.md` — should evaluate whether the style choice landed; if mismatched, propose matrix update
- `40-assets/reference-deck/_index.md` — registry that the skill reads to know what's forkable (must stay in sync with the 4 entries above)
- `references/build-details.md` — refers users here for style decisions

## Updating the matrix

When a new style ships, add a row in the 4-reference-decks section above + map it into the intersection grid. The matrix is a living document; PRs from retros are expected.
