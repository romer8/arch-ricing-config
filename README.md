# arch-ricing-config

My personal Arch Linux ricing setup, managed with [GNU Stow](https://www.gnu.org/software/stow/).

WM: **qtile** (Wayland) · Terminal: **alacritty** · Shell: **zsh** + starship · Bar/menu: **rofi** · Notifications: **dunst** · Compositor: **picom** · Colors: **pywal**

## Layout

Each top-level directory is a *stow package*. Its contents mirror the path
relative to `$HOME`, so stowing a package symlinks its files into place.

```
arch-ricing-config/
├── alacritty/   .config/alacritty/
├── cava/        .config/cava/
├── dunst/       .config/dunst/
├── fontconfig/  .config/fontconfig/
├── nvim/        .config/nvim/
├── picom/       .config/picom/
├── qtile/       .config/qtile/
├── rofi/        .config/rofi/
├── spicetify/   .config/spicetify/
├── starship/    .config/starship.toml
├── zsh/         .zshrc
├── fonts/       .local/share/fonts/   (assets)
├── themes/      Themes/               (assets)
└── wallpaper/   Wallpaper/            (assets)
```

## Install on a fresh machine

```sh
sudo pacman -S --needed stow
git clone git@github.com:romer8/arch-ricing-config.git ~/arch-ricing-config
cd ~/arch-ricing-config
./bootstrap.sh          # stows everything + refreshes font cache
```

## Day-to-day

```sh
cd ~/arch-ricing-config
stow qtile              # enable one package (creates symlinks)
stow -D qtile           # remove a package's symlinks
stow -R qtile           # restow after adding files
git add -A && git commit -m "..." && git push   # edits are live via symlinks
```

Because files are symlinked, editing `~/.config/qtile/config.py` edits the
copy in this repo directly — just commit and push.

## Root-owned config (`system/`)

Files under `/etc` and `/usr/share` can't be stowed into `$HOME`, so they live in
[`system/`](system/) with an installer instead. Currently: the **SDDM login theme**
(sddm-astronaut, "cyberpunk" preset) — run `system/install-sddm.sh`. See
[`system/README.md`](system/README.md).
