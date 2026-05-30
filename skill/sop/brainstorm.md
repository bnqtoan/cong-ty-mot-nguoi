# SOP — brainstorm (the upstream thinking, where the deck's angle gets found)

> **When to run this SOP:** `{deck}/brainstorm.md` doesn't exist (or is empty / just a stub). The human has raw materials in `inbox/{event}/` but hasn't yet decided what the deck is *actually claiming*.
>
> **What this SOP produces:** a populated `brainstorm.md` that `sop/research.md` can consume. NOT a slide. NOT an outline. Just the thinking layer.
>
> **Hard rule:** this SOP is interview-driven. AI asks; human answers. AI does NOT decide the angle. AI's job is to ask the questions that *force* the angle out of the human's head.

## Why this SOP exists

The slide skill was built assuming `brainstorm.md` already exists. Many users (especially first-time) don't arrive with one. Without brainstorm.md the skill hits a wall: `sop/research.md` Step 0 explicitly says *"If brainstorm.md has no 1-sentence purpose yet, stop and ask for it first — research without a decision = blank-page problem."*

This SOP fills that wall. It walks the user through structured frameworks to produce a real brainstorm.md, not a vague form-fill.

## The 5 stages

```
Stage 1: DISCOVER (Jobs-to-be-Done)
Stage 2: HYPOTHESIZE (HDT)
Stage 3: STRESS-TEST (5 Whys + skeptic)   ↺ loops to Stage 2
Stage 4: NARRATIVE (SCQA + Pixar)
Stage 5: WRITE brainstorm.md
```

Each stage uses ONE proven framework, named explicitly so the human knows why we're doing what we're doing.

**On duration:** this SOP has not been measured against real users yet. A confident user may finish in under 15 minutes. A user iterating heavily through Stage 3 may take 30-45 minutes. A user changing the angle mid-flow may take longer. The original draft of this SOP carried a "~22 min total" budget; that was a design-time aspiration, not a measured number, and shipping it as a claim led to over-promising. **Hard cap: stop forcing iterations after 30 minutes** — write brainstorm.md with what you have, flag the weak fields as "REFINE LATER", proceed to research SOP, iterate from real signal later.

---

## Stage 1 — DISCOVER (Jobs-to-be-Done frame)

**Framework:** Clayton Christensen, *Competing Against Luck* (2016). The core question: people don't buy products; they "hire" them to do a job.

**Applied to a deck:** the audience doesn't show up to "see a presentation"; they show up because they have a *job* this deck might do for them. Decision to make. Anxiety to resolve. Pattern to learn. Question to answer.

If we don't know the job, we can't make a deck that does it.

### Questions to ask (in order)

1. **"Ai sẽ ngồi nghe? Bạn hình dung 1 người cụ thể được không?"**
   - Push past "investors" / "students" / "team" → name a specific person if possible.
   - If audience.md already exists, skip this — read it.

2. **"Tại sao họ tới buổi này / đọc deck này? Họ đang muốn giải quyết chuyện gì?"**
   - This is the JTBD core. NOT "what topic," but "what job they want done."
   - Examples of jobs: *"quyết có rót thêm vốn không"* / *"hiểu vì sao bài của em chỉ 5.5"* / *"shortlist 2 agency cho round cuối"*.

3. **"Nếu sau 60 phút nghe xong họ nói 'đáng giờ' — thì cái họ vừa nhận được là gì?"**
   - This surfaces the *outcome* the audience would value. Not what YOU want to say; what THEY want to leave with.

### Gate at end of Stage 1

You should have, in 1-2 sentences:
- **Who:** specific audience
- **Job:** what they want done by this deck
- **Outcome:** what "worth my time" looks like for them

If any is vague, ask one more clarifier. Do NOT proceed without all 3.

**Timebox: 3 min.** If after 3 min the user still can't name the job, write down "JOB UNCLEAR — to refine after first draft" and proceed. Sometimes the job emerges by stage 3.

---

## Stage 2 — HYPOTHESIZE (Hypothesis-Driven Thinking, McKinsey)

**Framework:** McKinsey's Hypothesis-Driven Thinking. Source: McKinsey Problem Solving Process; widely documented (Stratechi, multiple business school case method references).

**Core move:** don't gather data and *then* form an opinion. Form a *guess* first, then test it. The brainstorm IS the hypothesis. We test it in Stage 3.

### The ask

> "Given what you know about the audience (Stage 1), **what's your best guess at the main thing you'd tell them?**
>
> Đừng nói 'em chưa biết' — đoán đi. Sai cũng được, mình sẽ test sau."

Push back on these answers:
- ❌ "Em sẽ nói về Q3" → "About Q3 NÓI GÌ cụ thể?"
- ❌ "Margin tụt nhưng vẫn ổn" → "OK nhưng claim gì? Vì sao ổn?"
- ❌ "3 framework để fix" → "3 cái nào? Cái nào tier 1?"

### What a good hypothesis looks like

Structure: **"X because Y, which means Z for them."**

Examples (across the 3 demo scenarios):
- IELTS: *"Bài 5.5 vs 6.5 không khác về vốn từ, mà khác về cách chọn topic sentence. Vì vậy 3 fix cho lớp tuần này tập trung topic sentence, không phải vocab."*
- Investor: *"Margin tụt 4pp nhưng top 3 chi nhánh vẫn 14% — model OK, chỉ là 1 chi nhánh đang ramp. Vì vậy Q4 ask 2 tỷ working capital là rational, không phải bail-out."*
- Pitch: *"Tết 2024 ai cũng làm 'trở về'; territory 'mâm cơm' còn trống và Mâm Việt là brand fit tự nhiên nhất. Vì vậy 1.8 tỷ campaign này nên anchor vào 'mâm cơm' chứ không 'trở về'."*

### Gate at end of Stage 2

User states the hypothesis in 1 sentence. If they can't, prompt:
> "OK chưa rõ. Cho mình 3 cái guess thô, mình giúp bạn pick cái mạnh nhất."

Capture all 3, then proceed to Stage 3.

**Timebox: 5 min.**

---

## Stage 3 — STRESS-TEST (5 Whys + Skeptic)

**Framework:** 5 Whys (Sakichi Toyoda, Toyota Production System) for root cause + Devil's Advocate / Skeptic test for survivability.

**Core move:** a hypothesis that can't survive 3 stress tests isn't a hypothesis worth presenting. The 3 tests:

### Test 1 — The 30-second test

> "Nếu bạn chỉ có 30 giây với audience này, bạn nói câu gì?"

- The hypothesis from Stage 2 should compress to ≤30s spoken (~50-70 words).
- If it expands, it's not 1 hypothesis — it's 3 weak ones strung together.

### Test 2 — The "mad" test

> "Nếu bạn KHÔNG nói câu này, audience có giận / thất vọng không?"

- If audience wouldn't notice the absence, the claim isn't load-bearing. Cut it.
- If audience would be mad (or feel cheated of value), it's the real claim.

### Test 3 — The skeptic test

> "Một skeptic thông minh sẽ phản bác câu này thế nào? Bạn có counter chưa?"

- Surface the strongest objection.
- If user has no counter — that's data: claim is weak OR user hasn't thought through.
- Capture the objection + draft counter into the brainstorm.

### The 5 Whys loop (when hypothesis is too shallow)

If Test 1 fails (too long), ask "Vì sao?" → push deeper:
1. "Why does this matter to audience?" → 1st Why
2. "Why does THAT matter?" → 2nd Why
3. ... continue up to 5 levels

The 3rd-5th Why usually surfaces the *real* claim — the one with weight.

### Loop back to Stage 2 if claim doesn't survive

If after stress tests the claim shifts significantly, go back to Stage 2 with refined version. **Maximum 3 iterations.** After 3, ship the best version + flag the weak spots for the user to revisit after first draft.

### Gate at end of Stage 3

- Hypothesis survives all 3 tests
- 2-3 counter-arguments surfaced + counters drafted
- 1-2 "load-bearing claims" identified (the ones audience would be mad to miss)

**Timebox: 7 min including loops.**

---

## Stage 4 — NARRATIVE (SCQA + Pixar)

**Framework A:** SCQA (Situation-Complication-Question-Answer) from Barbara Minto's *Pyramid Principle* (1973). The standard consulting narrative scaffold.

**Framework B:** Pixar storytelling template (Emma Coats, 2011): *"Once upon a time... Every day... One day... Because of that... Until finally..."* — for emotional / story-driven decks.

**Core move:** the hypothesis from Stage 2-3 is the answer. We now wrap it in a story arc the audience can *follow* from where they are now.

### When to use SCQA (default for business decks)

> "Mình sẽ build SCQA arc cho deck:
> - **Situation:** audience đang ở đâu (cái họ đã biết)?
> - **Complication:** cái gì đã thay đổi / đang sai / đáng lo?
> - **Question:** câu hỏi tự nhiên audience sẽ hỏi sau Complication?
> - **Answer:** = hypothesis từ Stage 2."

Walk through one at a time. The S is the easiest (audience starting point). The C is the lever (without C there's no reason to present). The Q is implicit (audience will think it; you state it to acknowledge). The A is your claim.

### When to use Pixar (creative pitches, personal moments, story-led decks)

> "Mình sẽ build Pixar arc:
> - **Once upon a time:** [context]
> - **Every day:** [routine that's about to change]
> - **One day:** [the disruption]
> - **Because of that:** [first consequence]
> - **Because of that:** [second consequence]
> - **Until finally:** [resolution = your claim]"

Use for: brand campaigns, personal stories, creative pitches, anything where audience needs to *feel* before they decide.

### The 1-beat extraction

After SCQA or Pixar arc is built, ask:
> "Nếu audience chỉ nhớ 1 câu duy nhất, nhớ câu nào?"

This is `1 beat` in brainstorm.md. Usually it's the Answer / Until finally — but sometimes the Complication is more memorable. Let user pick.

### Gate at end of Stage 4

- 4-bullet SCQA (or 5-bullet Pixar) written out
- 1 sentence extracted as "1 beat"
- Story Test prep: if user reads only [Situation] + [Answer] aloud, does it make sense as a 2-sentence pitch?

**Timebox: 5 min.**

---

## Stage 5 — WRITE brainstorm.md

Capture everything into the canonical brainstorm.md shape consumed by `sop/research.md`:

```markdown
# brainstorm.md — {event-name}

## 1 câu deck này để làm gì
{the hypothesis from Stage 2-3, refined. ≤1 sentence.}

## Claim chính (3-5 cái)
- {primary claim — the one that survived stress tests}
- {supporting claim 1}
- {supporting claim 2}
- {optional 4th-5th}

## 1 beat
{from Stage 4 — single sentence audience must remember}

## Delivery / goal
{Zoom / hall / PDF + audience target action from Stage 1}

## Story arc (SCR or Pixar)
{from Stage 4}

## Counter-arguments mình chuẩn bị
- {skeptic Q1} → {prepared counter}
- {skeptic Q2} → {prepared counter}
- ...

## Open questions for research SOP
{anything user couldn't answer — flagged for sop/research.md to investigate, e.g. "need to verify Bình Tân ramp comparable vs Q7 Y1"}
```

After writing, present file path + 1-line summary. Ask:
> "Đọc qua brainstorm.md — đúng intent của bạn không? Sửa gì trước khi chạy research SOP?"

User confirms → hand off to `sop/research.md`.

**Timebox: 2 min.**

---

## Audit mode (when brainstorm.md already exists)

If user dropped `_brainstorm.md` into `inbox/{event}/`, OR brainstorm.md exists in `{deck}/`, do NOT re-interview. Instead:

1. Read existing brainstorm.md
2. Run Stage 3 stress tests on it (5 min)
3. Either:
   - **Approve as-is** if it passes — flag 0 changes, proceed to research
   - **Propose 1-2 tightening edits** + ask user to confirm (e.g. *"1-câu deck đang là 18 từ, có thể tighten thành 'X' (10 từ) — OK không?"*)
   - **Push back hard** if it fails stress tests — explain why + ask user to refine

This makes the skill respect the user's pre-thinking while still gating quality.

---

## Hard guardrails

- **Total timebox: 30 min hard cap.** After 30 min, force-write brainstorm.md with what you have + flag weak fields as "REFINE LATER" in comments.
- **Max 3 stress-test loops in Stage 3.** Don't loop forever.
- **Never decide for the user.** AI proposes; user picks. If user can't pick, surface the trade-off.
- **No jargon the user didn't introduce.** If user says "Q3 review," don't introduce "EBITDA" unless they did.
- **Vietnamese voice rules** (per `feedback_vn_natural_flow` + `user_southern_vn_dialect`): mình/bạn, no English code-switch in audience-visible questions, "khoẻ" / "nhẹ hều" / "đỡ tốn công" diminutives over abstract terms.

## After this SOP

Hand off to `sop/research.md` Step 1. That SOP will read the new brainstorm.md and start filling claims.md + examples.md.

If user's brainstorm flagged "Open questions" — research SOP picks them up first.

---

## Sources

Frameworks cited above:

- **Jobs-to-be-Done** — Clayton Christensen, *Competing Against Luck* (HarperBusiness, 2016). Also Christensen et al., *Know Your Customers' Jobs to Be Done* (HBR, September 2016).
- **Hypothesis-Driven Thinking** — McKinsey Problem Solving Process. Documented in Stratechi's consulting guide ([stratechi.com/synthesizing](https://www.stratechi.com/synthesizing/)), Ethan Rasiel's *The McKinsey Way* (McGraw-Hill, 1999).
- **5 Whys** — Sakichi Toyoda, Toyota Production System. See Taiichi Ohno, *Toyota Production System: Beyond Large-Scale Production* (Productivity Press, 1988).
- **SCQA** — Barbara Minto, *The Pyramid Principle: Logic in Writing and Thinking* (Pitman Publishing, 1973; current Pearson edition).
- **Pixar storytelling** — Emma Coats, "Pixar's 22 Rules of Storytelling" (Twitter thread, 2011, widely archived).

## Integration with rest of skill

- `SKILL.md` — should reference this SOP in the brainstorm step
- `sop/research.md` Step 0 — change *"stop and ask for it first"* → *"run sop/brainstorm.md first"*
- `sop/retro.md` — should compare deck-as-shipped vs brainstorm.md intent
- `references/template-slide-outline.md` — already references brainstorm.md as input, no change

→ Next: `sop/research.md`
