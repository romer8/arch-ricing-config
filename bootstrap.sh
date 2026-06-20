#!/usr/bin/env bash
# Deploy all dotfile packages into $HOME via GNU Stow.
# Safe to re-run: stow only creates/updates symlinks.
set -euo pipefail

cd "$(dirname "$0")"

PACKAGES=(
  alacritty cava dunst fontconfig nvim picom qtile rofi spicetify starship zsh
  fonts themes wallpaper
)

if ! command -v stow >/dev/null 2>&1; then
  echo "GNU Stow is required:  sudo pacman -S stow" >&2
  exit 1
fi

echo ">> Stowing packages into $HOME"
for pkg in "${PACKAGES[@]}"; do
  printf '   %-12s ' "$pkg"
  if stow --target="$HOME" --restow "$pkg" 2>/tmp/stow-err; then
    echo ok
  else
    echo "CONFLICT — resolve manually:"
    sed 's/^/      /' /tmp/stow-err
  fi
done

if command -v fc-cache >/dev/null 2>&1; then
  echo ">> Refreshing font cache"
  fc-cache -f >/dev/null
fi

echo ">> Done. Log out / reload qtile to apply."
