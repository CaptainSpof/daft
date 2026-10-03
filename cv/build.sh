#!/usr/bin/env bash
# Builds the CV PDF from content/cv.md (also rendered as the /cv/ page) + cv.typ.
# Usage: cv/build.sh [output.pdf]
#   output     argument, or CV_OUTPUT (default: static/cv.pdf, served by Zola at /cv.pdf)
#   CV_EMAIL   replaces the email shown in the CV
#   CV_SOURCE  another cv.md to render instead of content/cv.md (e.g. a private version)
set -euo pipefail
out=$(realpath -m "${1:-${CV_OUTPUT:-$(dirname "$0")/../static/cv.pdf}}")

root=..
inputs=()
[[ -n "${CV_EMAIL:-}" ]] && inputs+=(--input "email=$CV_EMAIL")
if [[ -n "${CV_SOURCE:-}" ]]; then
  src=$(realpath -e "$CV_SOURCE")
  # Typst ne lit que sous --root : on passe à / pour accepter un chemin absolu quelconque
  root=/
  inputs+=(--input "source=$src")
fi
inputs+=(--root "$root")

cd "$(dirname "$0")"
if command -v typst >/dev/null && [[ -n ${TYPST_FONT_PATHS:-} ]]; then
  # Inside the devshell: typst and TYPST_FONT_PATHS are already set up.
  typst compile --ignore-system-fonts "${inputs[@]}" cv.typ "$out"
else
  # Typst and fonts come from the nixpkgs pinned in the repo's flake.lock.
  mapfile -t p < <(nix build --no-link --print-out-paths --inputs-from .. \
    nixpkgs#typst nixpkgs#roboto-slab nixpkgs#open-sans)
  typst=${p[0]} slab=${p[1]} sans=${p[2]}
  "$typst/bin/typst" compile --ignore-system-fonts --font-path "$slab" --font-path "$sans" \
    "${inputs[@]}" cv.typ "$out"
fi
echo "CV généré : $out"
