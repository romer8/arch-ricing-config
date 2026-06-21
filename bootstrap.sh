#!/usr/bin/env bash
# Install dependencies and deploy all dotfile packages into $HOME via GNU Stow.
# Safe to re-run: pacman uses --needed, stow only creates/updates symlinks.
#
#   ./bootstrap.sh              install deps + stow everything
#   ./bootstrap.sh --no-deps    just stow (skip package installation)
set -euo pipefail

cd "$(dirname "$0")"

# Stow packages (each mirrors a path under $HOME)
PACKAGES=(
  alacritty cava dunst fontconfig nvim picom qtile rofi spicetify starship zsh
  fonts themes wallpaper
)

# Runtime dependencies from official repos
PACMAN_PKGS=(
  stow                # dotfile symlink manager
  qtile               # window manager (wayland)
  python-dbus-fast    # qtile notifications + StatusNotifier tray
  alacritty           # terminal
  zsh starship        # shell + prompt
  rofi                # launcher / menus
  dunst               # notifications
  cava                # audio visualizer
  neovim              # editor
  picom               # compositor (X11 sessions)
  python-pywal        # colorscheme generator (wal)
  ttf-jetbrains-mono noto-fonts noto-fonts-emoji   # fonts
)

# Dependencies from the AUR (need an AUR helper: paru or yay)
AUR_PKGS=(
  spicetify-cli       # spotify theming
)

install_deps() {
  echo ">> Installing official-repo dependencies"
  sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"

  local helper=""
  command -v paru >/dev/null 2>&1 && helper=paru
  [ -z "$helper" ] && command -v yay >/dev/null 2>&1 && helper=yay
  if [ -n "$helper" ]; then
    echo ">> Installing AUR dependencies with $helper"
    "$helper" -S --needed --noconfirm "${AUR_PKGS[@]}"
  else
    echo "!! No AUR helper found — install manually: ${AUR_PKGS[*]}"
  fi
}

if [ "${1:-}" != "--no-deps" ]; then
  install_deps
fi

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

echo ">> Done. The SDDM login theme is separate: see sddm/install-sddm.sh"
echo ">> Log out / reload qtile to apply."
