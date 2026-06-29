#!/bin/bash
# Toggle the eww desktop dashboard.
export PATH="$HOME/.local/bin:$PATH"
eww --config "$HOME/.config/eww" open --toggle dashboard
