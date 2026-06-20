# sddm/ — login theme (not stow-managed)

These files live under `/etc` and `/usr/share`, outside stow's `$HOME` target,
so they're installed by a script instead of symlinked.

## SDDM login theme

- `theme.conf` — the SDDM drop-in: selects the theme + virtual keyboard
  (installed to `/etc/sddm.conf.d/theme.conf`)
- `cyberpunk.conf` — the customized "cyberpunk" preset, colors/clock/blur/background
  (installed to `…/themes/sddm-astronaut-theme/Themes/cyberpunk.conf`)

Install / update on this or a fresh machine:

```sh
cd ~/arch-ricing-config/sddm
./install-sddm.sh
```

The script installs Qt6 deps, clones [sddm-astronaut-theme](https://github.com/keyitdev/sddm-astronaut-theme)
into `/usr/share/sddm/themes/`, drops our `cyberpunk.conf` over its default, and
installs the drop-in. Preview without logging out:

```sh
QT_QPA_PLATFORM=xcb sddm-greeter-qt6 --test-mode \
  --theme /usr/share/sddm/themes/sddm-astronaut-theme
```

### Editing the look
Tune `cyberpunk.conf` here, re-run `install-sddm.sh` to push
it live, then commit. To use a custom wallpaper, add the image under the theme's
`Backgrounds/` and set `Background=` in the preset (also copy the image into this
repo so it's reproducible).
