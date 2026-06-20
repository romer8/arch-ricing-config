# system/ — root-owned config (not stow-managed)

These files live under `/etc` and `/usr/share`, outside stow's `$HOME` target,
so they're installed by a script instead of symlinked.

## SDDM login theme

- `etc/sddm.conf.d/theme.conf` — selects the theme + virtual keyboard
- `sddm-astronaut-theme/cyberpunk.conf` — the customized "cyberpunk" preset
  (colors, clock format, blur, background)

Install / update on this or a fresh machine:

```sh
cd ~/arch-ricing-config/system
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
Tune `sddm-astronaut-theme/cyberpunk.conf` here, re-run `install-sddm.sh` to push
it live, then commit. To use a custom wallpaper, add the image under the theme's
`Backgrounds/` and set `Background=` in the preset (also copy the image into this
repo so it's reproducible).
