#!/usr/bin/env bash
# Builds the CV PDF from content/cv.md (also rendered as the /cv/ page) + cv.typ.
# Usage: cv/build.sh [output.pdf]   (default: static/cv.pdf, served by Zola at /cv.pdf)
set -euo pipefail
cd "$(dirname "$0")"
out=$(realpath -m "${1:-../static/cv.pdf}")

if command -v typst >/dev/null && [[ -n ${TYPST_FONT_PATHS:-} ]]; then
  # Inside the devshell: typst and TYPST_FONT_PATHS are already set up.
  typst compile --root .. --ignore-system-fonts cv.typ "$out"
else
  # Typst and fonts come from the nixpkgs pinned in the repo's flake.lock.
  mapfile -t p < <(nix build --no-link --print-out-paths --inputs-from .. \
    nixpkgs#typst nixpkgs#roboto-slab nixpkgs#open-sans)
  typst=${p[0]} slab=${p[1]} sans=${p[2]}
  "$typst/bin/typst" compile --root .. --ignore-system-fonts --font-path "$slab" --font-path "$sans" cv.typ "$out"
fi
echo "CV généré : $out"
