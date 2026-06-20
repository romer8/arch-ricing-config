#!/usr/bin/env bash
# Reproduce the SDDM login theme (sddm-astronaut, "cyberpunk" preset) on a fresh
# machine. Root-owned files live outside stow's $HOME scope, so this is a plain
# copy-into-place installer. Re-runnable.
#
#   sudo ./install-sddm.sh        (or run as user; it will sudo where needed)
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
THEME_DIR=/usr/share/sddm/themes/sddm-astronaut-theme
REPO=https://github.com/keyitdev/sddm-astronaut-theme.git

SUDO=""; [ "$(id -u)" -ne 0 ] && SUDO=sudo

echo ">> Installing Qt6 dependencies"
$SUDO pacman -S --noconfirm --needed \
  qt6-svg qt6-declarative qt6-5compat qt6-virtualkeyboard qt6-multimedia

echo ">> Installing sddm-astronaut-theme"
if [ ! -d "$THEME_DIR" ]; then
  tmp="$(mktemp -d)"
  git clone --depth 1 "$REPO" "$tmp/astronaut"
  $SUDO cp -r "$tmp/astronaut" "$THEME_DIR"
  $SUDO cp "$tmp"/astronaut/Fonts/* /usr/share/fonts/ 2>/dev/null || true
  rm -rf "$tmp"
else
  echo "   (already present, leaving theme files in place)"
fi

echo ">> Applying customized cyberpunk preset"
$SUDO cp "$HERE/cyberpunk.conf" "$THEME_DIR/Themes/cyberpunk.conf"
$SUDO sed -i 's|^ConfigFile=.*|ConfigFile=Themes/cyberpunk.conf|' "$THEME_DIR/metadata.desktop"

echo ">> Installing SDDM drop-in config"
$SUDO mkdir -p /etc/sddm.conf.d
$SUDO cp "$HERE/theme.conf" /etc/sddm.conf.d/theme.conf

$SUDO fc-cache -f >/dev/null 2>&1 || true
echo ">> Done. Preview without logging out:"
echo "   QT_QPA_PLATFORM=xcb sddm-greeter-qt6 --test-mode --theme $THEME_DIR"
