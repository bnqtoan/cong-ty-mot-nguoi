#!/usr/bin/env bash
# slide-check.sh — lint a slides.html (and optionally its repo) for the KNOWN TRAPS in SKILL.md.
# Usage: scripts/slide-check.sh path/to/slides.html
#   - if the file's parent has a sibling refs/ or an index.html, those get a couple of checks too.
set -u
f="${1:?usage: slide-check.sh path/to/slides.html}"
[ -f "$f" ] || { echo "no such file: $f" >&2; exit 2; }
dir=$(cd "$(dirname "$f")" && pwd)
fail=0; warn=0
bad()  { echo "  ✗ $1"; shift; for l in "$@"; do echo "      $l"; done; fail=1; }
note() { echo "  ⚠ $1"; warn=1; }

echo "=== slide-check: $f ==="

# 1. <li> that is display:grid AND the deck has inline <b>/<i> inside <li> — the layout-rip trap.
#    Heuristic: any CSS rule selecting `li` with `display:grid` or `display: grid`, AND at least one `<li...><b>` or `<li...><i>` in the HTML.
if grep -Eiq '\bli[^{}]*\{[^}]*display:\s*grid' "$f" 2>/dev/null \
   || grep -Eq '\.[A-Za-z_-]+\s+li[^{]*\{[^}]*display:\s*grid' "$f" 2>/dev/null; then
  m=$(grep -nE '<li[^>]*>\s*<(b|i|em|strong)\b' "$f")
  [ -n "$m" ] && bad 'a CSS rule grids an <li>, and there are <li> with inline <b>/<i> children → the ::before number + first inline child collide as grid cells (layout rips). Use absolute ::before + padding-left, not display:grid on the li.' $(echo "$m" | head -3)
fi

# 2. _-prefixed CSS/asset <link> — Jekyll skips them on Pages.
m=$(grep -nE '<link[^>]+href=["'"'"'][^"'"'"']*/_[A-Za-z0-9._-]+\.css' "$f")
[ -n "$m" ] && bad 'links a _-prefixed CSS file → GitHub Pages (Jekyll) skips _-prefixed files → 404 online. Rename without the underscore + add a .nojekyll at repo root.' $(echo "$m" | head -3)

# 3. chrome <script> matching slide ids by "slide-" + n — breaks on named ids.
#    Strip // line-comments and /* */ blocks first so a comment mentioning the anti-pattern isn't flagged.
m=$(sed -E 's@//.*$@@; s@/\*([^*]|\*[^/])*\*/@@g' "$f" | grep -nE '"slide-"\s*\+|`slide-\$\{')
if [ -n "$m" ]; then
  bad 'chrome <script> builds slide ids as "slide-" + n → deep-links/hash-sync break the moment a non-numeric id (slide-cover, slide-quote, slide-thanks) exists. Match by exact id: slides.findIndex(s => s.id === hash).' $(echo "$m" | head -3)
fi

# 4. hand-typed presenter total — a literal " / NN" or 'NN' that doesn't come from .length.
#    Heuristic: a string like "01 / 14" or "/ 14" in the HTML, AND no `.slide").length` / `slides.length` near a total/count var.
if grep -Eq '[0-9]{1,3}\s*/\s*[0-9]{1,3}' "$f" && ! grep -Eq '\.slide["'"'"']?\)\.length|slides\.length|querySelectorAll\(["'"'"']\.slide' "$f"; then
  note 'looks like a hand-typed slide total (e.g. "01 / 14") with no .slide.length anywhere — derive the total from document.querySelectorAll(".slide").length so a restructure re-counts itself.'
fi

# 5. manual <br/> inside an <h1> (title orphans).
m=$(grep -nE '<h1[^>]*>[^<]*<br' "$f")
[ -n "$m" ] && note 'manual <br/> inside an <h1> → orphans single words on narrow viewports. Wrap phrase-groups in <span class="nowrap"> + size with clamp() instead.' 

# 6. <img src> pointing at a file that isn't there.
while IFS= read -r src; do
  case "$src" in /*|http*|data:*) continue;; esac
  p="$dir/$src"
  # resolve ../ roughly
  p=$(cd "$dir" 2>/dev/null && cd "$(dirname "$src")" 2>/dev/null && echo "$(pwd)/$(basename "$src")")
  [ -n "$p" ] && [ -f "$p" ] || note "img src '$src' has no file on disk (placeholder will show / 404 online until the PNG is added)."
done < <(grep -oE '<img[^>]+src=["'"'"'][^"'"'"']+' "$f" | sed -E 's/.*src=["'"'"']//')

# 7. .stage-strip on every .slide — the audience/speaker invariant. Count <section ...class="...slide..."> only.
nslides=$(grep -cE '<section[^>]+class=["'"'"'][^"'"'"']*\bslide\b' "$f")
nstrip=$(grep -cE 'class=["'"'"'][^"'"'"']*stage-strip' "$f")
[ "$nslides" -gt 1 ] && [ "$nstrip" -lt "$nslides" ] && note "$nstrip .stage-strip vs $nslides slide sections — some slides have no speaker-note layer (.stage-strip). Put one on every slide."

# 8. crowded-slide heuristic: a .slide whose <li> count (outside .stage-strip) is high.
#    crude: total <li> / total .slide ; if any single slide section is huge, flag the file.
big=$(awk 'BEGIN{RS="<section[^>]*class=[\"'"'"'][^\"'"'"']*slide"; n=0} NR>1{c=gsub(/<li[ >]/,"&"); if(c>10){n++}} END{print n}' "$f")
[ "${big:-0}" -gt 0 ] && note "$big slide(s) have >10 <li> — likely the speaker layer leaking onto the audience layer. Split into two slides + image, or use the T-key tabs pattern."

# repo-level: only relevant if this looks like it'll be GitHub-Pages-deployed (a .git dir somewhere above) AND it has a separate-CSS-file footgun
root="$dir"; gitroot=""; for _ in 1 2 3 4 5; do [ -d "$root/.git" ] && gitroot="$root" && break; [ "$root" = "/" ] && break; root=$(cd "$root/.." && pwd); done
if [ -n "$gitroot" ]; then
  haslink=$(grep -lE '<link[^>]+href=["'"'"'][^"'"'"']+\.css' "$f" >/dev/null 2>&1 && echo y)
  hasrefcss=$(ls "$dir"/../refs/*.css "$dir"/refs/*.css >/dev/null 2>&1 && echo y)
  if [ -n "$haslink" ] || [ -n "$hasrefcss" ]; then
    [ -f "$gitroot/.nojekyll" ] || note "this deck links a separate CSS file and lives in a git repo ($gitroot) with no .nojekyll — if you deploy to GitHub Pages, add a .nojekyll (Jekyll 404s _-prefixed files; the .nojekyll also speeds the build)."
  fi
fi

# 9. duplicate closing tags — a botched append/merge.
for tag in '</body>' '</html>'; do
  c=$(grep -coF "$tag" "$f")
  [ "$c" -gt 1 ] && bad "found $c occurrences of $tag — duplicate closing tag (likely a bad append/merge). Keep exactly one."
done

# 10. a placeholder whose prompt is just the branch word ('stock'/'svg'/'codex') — image-decision wasn't actually applied.
m=$(grep -nE 'data-image-prompt=["'"'"'](stock|svg|codex|placeholder)["'"'"']' "$f")
[ -n "$m" ] && bad 'an image placeholder has its branch keyword left in as the prompt (data-image-prompt="stock"/"svg"…) → image-decision was not applied. Put a real prompt, or convert to inline SVG / stock URL.' $(echo "$m" | head -3)

# 11. audience-word-count > 40 per slide (the text-wall trap; ≤25 target per create.md Step 3, with +15 slack for inline labels).
#     Two ways to detect: (a) the build-skill emitted `<!-- audience-word-count: N -->` markers (preferred), or (b) we count words in each <section class="slide"> minus its <div class="stage-strip">.
mark_over=$(grep -nE '<!--\s*audience-word-count:\s*([4-9][0-9]|[1-9][0-9]{2,})' "$f")
if [ -n "$mark_over" ]; then
  bad 'audience-word-count marker reports >40 words on at least one slide → text wall. Outline-row slide-text should be ≤25 words (create.md Step 3). Split the slide or move prose to .stage-strip.' $(echo "$mark_over" | head -3)
else
  # fallback heuristic when no markers present: rough word-count per section.
  big=$(awk '
    BEGIN{ RS="</section>"; ORS=""; over=0 }
    /<section[^>]*class=["'"'"'][^"'"'"']*\bslide\b/ {
      body=$0
      # strip stage-strip block (.stage-strip ... </div> or end of section)
      gsub(/<div[^>]*class=["'"'"'][^"'"'"']*stage-strip[^<]*<\/div>/, "", body)
      gsub(/<div[^>]*class=["'"'"'][^"'"'"']*stage-strip[^<]*$/, "", body)
      # strip all tags
      gsub(/<[^>]+>/, " ", body)
      gsub(/&[a-z]+;/, " ", body)
      n=split(body, w, /[[:space:]]+/)
      wc=0; for(i=1;i<=n;i++) if(length(w[i])>1) wc++
      if (wc > 40) over++
    }
    END { print over+0 }
  ' "$f")
  [ "${big:-0}" -gt 0 ] && note "$big slide(s) have >40 audience-visible words (heuristic; tags stripped, stage-strip excluded). Likely a text wall — outline-row slide-text should be ≤25 words (create.md Step 3). For a precise check, emit <!-- audience-word-count: N --> after each section."
fi

# 12. eyebrow (.slide-kicker) ration — borrowed from taste-skill v2 §4.7.
#     Count kickers vs slides; must be ≤ ceil(slides/3). One-per-slide is the AI templated-rhythm Tell.
nkick=$(grep -cE 'class=["'"'"'][^"'"'"']*slide-kicker' "$f")
nsl=$(grep -cE '<section[^>]+class=["'"'"'][^"'"'"']*\bslide\b' "$f")
if [ "$nsl" -gt 0 ]; then
  cap=$(( (nsl + 2) / 3 ))
  if [ "$nkick" -gt "$cap" ]; then
    note "$nkick .slide-kicker labels across $nsl slides — over the ration of $cap (ceil(slides/3)). Eyebrow on every slide = templated rhythm (taste-skill §4.7 Tell). Drop kickers from interior slides; keep only on block-opening slides."
  fi
fi

# 13. em-dash (— or –) in audience-visible elements — borrowed from taste-skill v2 §9.G.
#     Practical heuristic: count em/en dashes inside <h1>...</h1> tags (always audience layer).
#     This misses dashes in body/captions, but catches the load-bearing case (titles) without
#     fighting awk over multi-line section parsing.
# Lines containing <h1...> and an em/en-dash on the same line. Multi-line h1s get caught by their opening line.
hdash=$(grep -cE '<h1[^>]*>.*(—|–)' "$f")
# Body slide-text elements: .lead/.quietline/.t/.sub/blockquote, dash on same line. Simpler heuristic to dodge quote-hell.
bdash=$(grep -E 'class=.*(lead|quietline|"t"|"sub")|<blockquote' "$f" | grep -cE '—|–')
total_dash=$((hdash + bdash))
if [ "$total_dash" -gt 0 ]; then
  note "$total_dash em/en-dash(es) detected in audience-visible elements (h1=$hdash, body=$bdash). taste-skill §9.G ban: replace with period, comma, parens, or line break. Stage-strip is exempt. Judgment call for VN typography — soften if the dash genuinely reads natural."
fi

# 14. SVG text containment audit — does the text fit inside its enclosing <rect>?
#     The "scaling text without scaling box" bug from 2026-05-29-s1-v2 retro.
#     Heuristic: for each <text font-size="N">CONTENT</text> immediately following a <rect width="W">,
#     estimate text width as chars × N × fudge (0.55 sans, 0.62 mono, 0.55 italic-serif), then check
#     width - 2*padding (padding = N * 0.6) >= text_width. Flag overflows.
#     Limitations: doesn't handle multi-line text, doesn't trace nested <g>, font-family inheritance approximate.
#     But catches the obvious cases like "cấu trúc · $0 · git-diffable" overflowing a 200-wide rect.
overflow=$(perl -ne '
  BEGIN { $over = 0; $printed = 0; $rect_x = -1; $rect_y = -1; $rect_w = 0; $rect_h = 0; $rect_line = 0; }
  # Track most recent rect with x/y/width/height (excluding stroke-width).
  if (/<rect\b([^>]*)>/) {
    my $attrs = $1;
    my ($rx, $ry, $rw, $rh) = (-1, -1, 0, 0);
    if ($attrs =~ /\bx="([\d.]+)"/) { $rx = $1; }
    if ($attrs =~ /\by="([\d.]+)"/) { $ry = $1; }
    if ($attrs =~ /(?<!stroke-)\bwidth="([\d.]+)"/) { $rw = $1; }
    if ($attrs =~ /(?<!stroke-)\bheight="([\d.]+)"/) { $rh = $1; }
    if ($rw > 0) {
      $rect_x = $rx; $rect_y = $ry; $rect_w = $rw; $rect_h = $rh; $rect_line = $.;
    }
  }
  # Match each <text ...font-size="N"...>CONTENT</text>; only flag if text x is inside rect x-range.
  while (/<text\b([^>]*?\bfont-size="([\d.]+)"[^>]*)>([^<]+)<\/text>/g) {
    my $attrs = $1; my $fs = $2; my $content = $3;
    next if $rect_w == 0;
    next if $. - $rect_line > 6;     # rect must be nearby
    # Containment check: does text x fall inside rect x-range?
    my ($tx, $ty) = (-1, -1);
    if ($attrs =~ /\bx="([\d.]+)"/) { $tx = $1; }
    if ($attrs =~ /\by="([\d.]+)"/) { $ty = $1; }
    if ($tx >= 0 && $rect_x >= 0) {
      next if $tx < $rect_x;                       # text starts left of rect
      next if $tx > $rect_x + $rect_w;             # text starts right of rect
    }
    if ($ty >= 0 && $rect_y >= 0 && $rect_h > 0) {
      next if $ty < $rect_y - 8;                   # text above rect
      next if $ty > $rect_y + $rect_h + 8;         # text below rect
    }
    $content =~ s/&[a-zA-Z#0-9]+;/ /g;
    $content =~ s/^\s+|\s+$//g;
    next if length($content) < 3;
    my $fudge = 0.55;
    if ($attrs =~ /font-family="[^"]*[Mm]ono/) { $fudge = 0.62; }
    elsif ($attrs =~ /font-family="[^"]*Fraunces/ || $attrs =~ /font-style="italic"/) { $fudge = 0.55; }
    my $padding = $fs * 0.6;
    my $avail = $rect_w - 2 * $padding;
    my $text_w = length($content) * $fs * $fudge;
    # Tolerance: only flag if overflow > 10% (avoid borderline cases)
    if ($text_w > $avail * 1.05) {
      if ($printed < 5) {
        printf "      L%d: \"%s\" (~%dpx) > rect(width=%d, avail=%d after padding) font-size=%d\n",
          $., $content, int($text_w), int($rect_w), int($avail), int($fs);
        $printed++;
      }
      $over++;
    }
  }
  END { print "OVERFLOW_COUNT=$over\n"; }
' "$f")
n_overflow=$(echo "$overflow" | sed -n 's/^OVERFLOW_COUNT=\([0-9]*\).*/\1/p' | head -1)
if [ "${n_overflow:-0}" -gt 0 ]; then
  note "$n_overflow SVG text element(s) likely overflow their enclosing <rect> (estimated text-width > rect-width - 2*padding). The 'scaling text without scaling box' trap (s1-v2 retro). Either widen the rect, shrink the text, or shorten the string. First 5:"
  echo "$overflow" | grep -v 'OVERFLOW_COUNT='
fi

# 15. Speaker-meta leaking into audience layer — content-to-container §Type F.
#     Uses 3 STRUCTURAL patterns (language-agnostic), not a phrase list. See sop/create.md
#     "Speaker-meta in audience layer" for the rule.
#
#     Pattern A — Conditional-about-delivery: (if|nếu|khi|when|in case) + (timing|deck-mgmt verb)
#     Pattern B — Deck-infrastructure refs: S<N>, Slide N, Beat N, Block N, Phần N, refs/, 40-assets/, sop/, stage-strip
#     Pattern C — Deck-mgmt imperative: (demote|skip|pause|ship|cut|hạ|giữ|bỏ qua|drop) + (slide|deck|section|rule|block|này)
#
#     These detect intent, not vocabulary. New words/languages survive automatically.
audience_lines=$(grep -nE '<(h1|blockquote|p|div|span)[^>]*class=[^>]*\b(lead|quietline|smallcap|t|sub|wrap)\b|<h1\b|<blockquote\b' "$f" | grep -vE 'stage-strip')

# Pattern A: conditional + timing/management
pat_A=$(echo "$audience_lines" | grep -iE '\b(if|nếu|khi|when|in case)\b[^<>]*\b(phút|phut|min|minute|giờ|gio|hour|overrun|behind|out of time|hết giờ|het gio|thiếu giờ|thieu gio|vượt giờ|vuot gio|over time|past time)\b')
# Pattern B: deck infrastructure references in audience text.
# Slide IDs: require explicit citation context (S## with ≥2 digits e.g. "S12", or "callback S5", or
# "see Slide 12") — NOT bare "slide 2" which is just a noun + count (false positive on
# "AI dựng slide 2 phút"). File-path refs (refs/, sop/, 40-assets/) are always speaker-meta.
pat_B=$(echo "$audience_lines" | grep -iE '\bS[0-9]{2,3}\b|\b(callback|see|xem|nhớ)\s+(S[0-9]+|Slide [0-9]+|Beat [0-9]+|Block [0-9]+|Phần [0-9]+)\b|\b(refs/|40-assets/|sop/|stage-strip|stage-note)\b')
# Pattern C: deck-management imperative + deck noun
pat_C=$(echo "$audience_lines" | grep -iE '\b(demote|skip this|pause here|cut this|drop this|hạ slide|giữ slide|bỏ slide|move this slide|cut .* slide|drop .* slide|hạ .* slide|hạ .* xuống refs)\b')

audience_meta=$(printf '%s\n%s\n%s\n' "$pat_A" "$pat_B" "$pat_C" | sort -u | grep -v '^$' | head -8)
if [ -n "$audience_meta" ]; then
  n_meta=$(printf '%s\n' "$audience_meta" | grep -c '.')
  note "$n_meta audience-layer element(s) match speaker-meta structural patterns (conditional+timing / deck-infra refs / deck-mgmt imperative). Should be in .stage-strip only. content-to-container §Type F. Per sop/create.md, treat as build failure. First matches:"
  echo "$audience_meta" | sed 's/^/      /'
fi

# 16. Scrollytelling traps (from references/scrollytelling-pattern.md).
#     Detects: (a) deck uses .scroll-driven / animation-timeline but missing prefers-reduced-motion fallback,
#              (b) CSS transform applied to SVG <g> that has a transform attribute (collapses to origin).
has_scrolly=$(grep -E 'animation-timeline:\s*scroll|class=["'"'"'][^"'"'"']*scroll-driven' "$f" | head -1)
if [ -n "$has_scrolly" ]; then
  # 16a: missing reduced-motion fallback
  has_reduce=$(grep -E '@media\s*\(\s*prefers-reduced-motion:\s*reduce' "$f" | head -1)
  if [ -z "$has_reduce" ]; then
    bad 'scrollytelling detected (.scroll-driven or animation-timeline: scroll) but no @media (prefers-reduced-motion: reduce) block. Accessibility fail — ship the fallback that forces final state.'
  fi
  # 16b: SVG <g transform="..."> with CSS rule applying transform (NOT scale property)
  # Heuristic: grep for `<g transform=` AND for CSS that targets a class also used on those <g> with `transform:`
  collide=$(grep -nE '<g[^>]+transform="translate' "$f" | head -3)
  if [ -n "$collide" ]; then
    has_css_transform=$(grep -E '\.(module|center-group|scene)\b[^{]*\{[^}]*transform:\s*(translate|scale|rotate)' "$f" | head -1)
    if [ -n "$has_css_transform" ]; then
      note "scrollytelling SVG: <g> elements have transform=\"translate(...)\" attributes AND CSS rules using transform property — CSS transform OVERRIDES the attribute and collapses modules to origin. Use the 'scale' / 'rotate' / 'translate' property names (independent of transform attribute), not 'transform:'. See references/scrollytelling-pattern.md gotcha #1."
    fi
  fi
  # 16c: <path> in animated section without pathLength="100" — stroke-draw math breaks
  paths_animated=$(grep -E '<path[^>]*class="[^"]*conn' "$f" | grep -v 'pathLength="100"' | head -3)
  if [ -n "$paths_animated" ]; then
    note 'scrollytelling: <path class="conn..."> without pathLength="100" attribute. stroke-dashoffset math will be wrong across different path lengths. Add pathLength="100" to every animated path.'
  fi
fi

# 17. Fork audit-trail comment — from style-decision-matrix.md.
#     Every shipped deck must declare which reference deck it forked from + the rationale.
#     This forces the Step 2 gate to leave a trace; silent forks are blocked.
fork_comment=$(head -30 "$f" | grep -E '<!--\s*fork:\s*[^·]+·\s*rationale:\s*.+\s*-->')
if [ -z "$fork_comment" ]; then
  bad 'no <!-- fork: {ref-deck} · rationale: {1-line} --> comment in first 30 lines. Step 2 of create SOP requires the fork-choice gate to leave an audit trail. Either: (a) add the comment if the deck was actually forked from a known reference, or (b) re-run create SOP Step 2 to make the choice explicit.'
fi

echo "  ℹ quality (Action Titles, Story Test, copy self-audit, content↔container) is NOT machine-checked here — run the slide review SOP (sop/review.md) for that."
echo "==========================================="
if [ "$fail" = 0 ] && [ "$warn" = 0 ]; then echo "  ✓ clean — no known traps. (Still: present it, check the live URL, hit S before going live.)"
elif [ "$fail" = 0 ]; then echo "  ⚠ warnings only — review above; none are hard blockers."
else echo "  ✗ hard traps above — fix before deploy."; fi
exit "$fail"
