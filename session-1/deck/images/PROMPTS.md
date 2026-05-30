# Image prompts for v2 deck

> Each entry: `slug · filename · prompt`. Drop generated PNG into this folder; `place-images.py` fuzzy-matches by slug. Style across the deck = **brand-flat-editorial on cream**: warm cream `#faf9f5` background, ONE restrained orange `#d97757` accent per image, no faces (silhouettes only), calm + dignified, generous whitespace, NOT cartoonish / 3D / photorealistic. Pass reference image (e.g., `imported/cxo-session-1/slides/images/...`) as `-i` to Codex to lock the look.

## Slides needing images

### s26-pitch-hong · s26-pitch-hong.png
> brand-flat-editorial on warm cream #faf9f5, ONE restrained orange #d97757 accent. Scene: một phòng họp tối lúc thuyết trình. Người speaker đứng nhỏ bên slide projector chiếu lớn. Audience 4-5 người ngồi quanh bàn họp, ALL nhìn xuống laptop / điện thoại trên bàn, không ai nhìn lên slide. Slide projection rõ nhưng bị ignored. Cảm xúc: "pitch hỏng vì không ai theo dõi". Silhouettes only, no faces. Calm + dignified, generous whitespace. NOT cartoonish / 3D / photorealistic. Aspect 16:7.

## Future opt-in (not blocking ship)

Below are optional slots where an editorial image would lift the slide further but SVG is fine for now:

### s01-cover-hero · s01-cover-hero.png  *(optional — background atmosphere)*
> brand-flat-editorial subtle pattern wash, warm cream + soft orange + soft blue radial highlights, abstract "deck pages floating in a workshop room" composition. Cover-slide background only. Aspect 21:9.

### s02-question · s02-question.png  *(optional — replace SVG chat bubble)*
> brand-flat-editorial on cream. Scene: phòng workshop, một silhouette giơ tay đang hỏi, speaker silhouette nhìn ra. Speech bubble nhỏ phía trên với câu hỏi (no text, just bubble shape). Calm. Aspect 16:7.

### s14-trang-trang · s14-trang-trang.png  *(optional — replace SVG cursor)*
> brand-flat-editorial. Scene: laptop trên bàn gỗ ấm, màn hình mở 1 file outline.md trắng, chỉ có dòng `#` + cursor nhấp nháy. Cảm xúc: cô đơn trước trang trắng. Tone Moleskine. Cream paper warmth. Aspect 16:7.

## Generation workflow

```bash
cd 20-decks/2026-05-29-s1-slide-pipeline-v2
env -u OPENAI_API_KEY codex exec --skip-git-repo-check \
  -i ../../40-assets/reference-deck/slides.html.images-ref/some-existing.png \
  -- "Use the imagegen skill. {paste prompt above}. Aspect 16:7."
# wait ~3 min, then:
mv ~/.codex/generated_images/*/ig_*.png images/s26-pitch-hong.png
python3 ../../.claude/skills/slide/scripts/place-images.py slides.html images/
```
