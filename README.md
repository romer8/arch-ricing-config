# arch-ricing-config

My personal Arch Linux ricing setup, managed with [GNU Stow](https://www.gnu.org/software/stow/).

WM: **qtile** (Wayland) · Terminal: **alacritty** · Shell: **zsh** + starship · Bar/menu: **rofi** · Notifications: **dunst** · Compositor: **picom** · Colors: **pywal**

## Layout

Most top-level directories are *stow packages*: their contents mirror the path
relative to `$HOME`, so stowing a package symlinks its files into place. `sddm/`
is the exception — root-owned config installed by a script, not stowed.

```
arch-ricing-config/
├── alacritty/   → ~/.config/alacritty/         stow
├── cava/        → ~/.config/cava/              stow
├── dunst/       → ~/.config/dunst/             stow
├── fontconfig/  → ~/.config/fontconfig/        stow
├── nvim/        → ~/.config/nvim/              stow
├── picom/       → ~/.config/picom/             stow
├── qtile/       → ~/.config/qtile/             stow
├── rofi/        → ~/.config/rofi/              stow
├── spicetify/   → ~/.config/spicetify/         stow
├── starship/    → ~/.config/starship.toml      stow
├── zsh/         → ~/.zshrc                      stow
├── fonts/       → ~/.local/share/fonts/        stow (assets)
├── themes/      → ~/Themes/                     stow (assets)
├── wallpaper/   → ~/Wallpaper/                  stow (assets)
├── sddm/        → /etc + /usr/share            NOT stowed (install-sddm.sh)
└── bootstrap.sh   stows all packages + refreshes font cache
```

## Install on a fresh machine

```sh
sudo pacman -S --needed stow
git clone git@github.com:romer8/arch-ricing-config.git ~/arch-ricing-config
cd ~/arch-ricing-config
./bootstrap.sh          # stows everything + refreshes font cache
```

## Editing & updating

There are **two kinds of config** here, with two different workflows:

| Kind | Where | How it reaches the system |
|------|-------|---------------------------|
| Stow packages (most things) | `qtile/`, `zsh/`, … | **symlinked** into `$HOME` — edits are live instantly |
| SDDM login theme | `sddm/` | **copied** by `sddm/install-sddm.sh` — needs a re-run to go live |

### Edit an existing config (stow packages)

The files in `~/.config`, `~/.zshrc`, etc. are symlinks into this repo, so editing
them *is* editing the repo. No copying, no restow:

```sh
nvim ~/.config/qtile/config.py        # or edit the repo copy directly — same file
cd ~/arch-ricing-config
git add -A && git commit -m "qtile: ..." && git push
```

### Add a new config as a stow package

Mirror the path the file should have under `$HOME`, then stow it and register it
in `bootstrap.sh`:

```sh
cd ~/arch-ricing-config
mkdir -p ranger/.config/ranger          # <pkg>/<path-relative-to-$HOME>
cp -r ~/.config/ranger/. ranger/.config/ranger/   # bring in current config
rm -rf ~/.config/ranger                 # remove the original...
stow ranger                             # ...so stow can symlink it back
# then add "ranger" to the PACKAGES list in bootstrap.sh
git add -A && git commit -m "add ranger" && git push
```

### Common stow commands

```sh
stow <pkg>      # enable a package (create symlinks)
stow -R <pkg>   # restow — run after ADDING new files to an existing package
stow -D <pkg>   # disable a package (remove its symlinks)
```

You only need `stow -R` when you add **new files** to a package; editing existing
tracked files needs nothing (they're already symlinked).

### Edit the SDDM login theme

Unlike the stow packages, `sddm/` is **not** symlinked, so an edit isn't live until
you re-run the installer:

```sh
cd ~/arch-ricing-config/sddm
nvim cyberpunk.conf                      # colors/clock/blur/background
nvim theme.conf                          # which theme + virtual keyboard
./install-sddm.sh                        # push changes into /etc and /usr/share
# preview without logging out:
QT_QPA_PLATFORM=xcb sddm-greeter-qt6 --test-mode \
  --theme /usr/share/sddm/themes/sddm-astronaut-theme
cd .. && git add -A && git commit -m "sddm: ..." && git push
```

See [`sddm/README.md`](sddm/README.md) for details (custom wallpaper, switching presets).

### Pulling updates on another machine

```sh
cd ~/arch-ricing-config && git pull
./bootstrap.sh                           # re-stow everything (safe to re-run)
sddm/install-sddm.sh                     # if the SDDM theme changed
```

### Pushing notes

Pushing uses SSH. If your key is passphrase-protected and `git push` errors with
`Permission denied (publickey)`, load the key into an agent first:

```sh
eval "$(ssh-agent -s)" && ssh-add ~/.ssh/github_id_ed25519   # run in a real terminal
```

## SDDM login theme (`sddm/`)

Root-owned files under `/etc` and `/usr/share` can't be stowed into `$HOME`, so the
**SDDM login theme** (sddm-astronaut, "cyberpunk" preset) lives in [`sddm/`](sddm/)
with an installer instead — run `sddm/install-sddm.sh`. See
[`sddm/README.md`](sddm/README.md).
