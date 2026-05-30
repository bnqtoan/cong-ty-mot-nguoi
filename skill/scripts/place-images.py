#!/usr/bin/env python3
"""place-images.py — fuzzy-match generated images to slide placeholders.

Usage:
    python3 scripts/place-images.py <slides.html> <images_dir>

Each placeholder in slides.html looks like:
    <div class="image-placeholder" data-img="hero-flow" data-image-prompt="...">...</div>

We match data-img keys to files in images_dir by a normalized, separator-insensitive,
version-suffix-tolerant token score, then rewrite matched placeholders to <img>.
Idempotent: only fills placeholders that don't already contain an <img>.
"""
import sys, re, os
from pathlib import Path

IMG_EXT = {".png", ".jpg", ".jpeg", ".webp", ".gif", ".svg"}

def norm(s: str):
    s = s.lower()
    s = re.sub(r"\.[a-z0-9]+$", "", s)                 # drop extension
    s = re.sub(r"[_\-\s]+", " ", s)                    # separators -> space
    s = re.sub(r"\b(v\d+|final|copy|\d+x\d+|\d{3,})\b", "", s)  # version/size noise
    return [t for t in s.split() if t]

def score(key_tokens, file_tokens):
    if not key_tokens or not file_tokens:
        return 0.0
    ks, fs = set(key_tokens), set(file_tokens)
    inter = len(ks & fs)
    # token overlap, normalized by key length; bonus if file fully covers key
    base = inter / len(ks)
    if ks <= fs:
        base += 0.25
    return base

def main():
    if len(sys.argv) != 3:
        print("usage: place-images.py <slides.html> <images_dir>")
        sys.exit(2)
    html_path, img_dir = Path(sys.argv[1]), Path(sys.argv[2])
    html = html_path.read_text(encoding="utf-8")

    files = [f for f in img_dir.iterdir() if f.suffix.lower() in IMG_EXT] if img_dir.exists() else []
    file_tok = {f: norm(f.name) for f in files}

    # find placeholders: capture the whole <div ... class="image-placeholder" ...>...</div>
    ph_re = re.compile(
        r'<div([^>]*class="[^"]*image-placeholder[^"]*"[^>]*)>(.*?)</div>',
        re.S)

    matched, unmatched, used = [], [], set()

    def repl(m):
        attrs, inner = m.group(1), m.group(2)
        if "<img" in inner:                      # already filled
            return m.group(0)
        kmatch = re.search(r'data-img="([^"]+)"', attrs)
        if not kmatch:
            unmatched.append("(placeholder with no data-img key)")
            return m.group(0)
        key = kmatch.group(1)
        kt = norm(key)
        best, best_s = None, 0.0
        for f, ft in file_tok.items():
            sc = score(kt, ft)
            if sc > best_s:
                best, best_s = f, sc
        if best and best_s >= 0.5:
            rel = os.path.relpath(best, html_path.parent)
            used.add(best); matched.append((key, best.name, round(best_s, 2)))
            alt = key.replace("-", " ")
            return f'<img class="slide-img" src="{rel}" alt="{alt}" data-img="{key}">'
        unmatched.append(key)
        return m.group(0)

    new_html = ph_re.sub(repl, html)
    if new_html != html:
        html_path.write_text(new_html, encoding="utf-8")

    print(f"=== place-images: {html_path.name} ===")
    print(f"matched ({len(matched)}):")
    for k, f, s in matched: print(f"   {k:20} <- {f}   (score {s})")
    if unmatched:
        print(f"unmatched placeholders ({len(unmatched)}) — still need an image:")
        for k in unmatched: print(f"   {k}   (see images/PROMPTS.md)")
    unused = [f.name for f in files if f not in used]
    if unused:
        print(f"unused files ({len(unused)}) — named too far off to match:")
        for f in unused: print(f"   {f}")
    if not matched and not files:
        print("(no images in folder yet — generate them, drop into images/, re-run)")

if __name__ == "__main__":
    main()
