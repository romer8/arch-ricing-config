#!/bin/bash
# Toggle the eww volume popup (auto-starts the eww daemon on first call).
# Ensure ~/.local/bin (where eww lives) is on PATH even when launched by qtile.
export PATH="$HOME/.local/bin:$PATH"
eww --config "$HOME/.config/eww" open --toggle volume
