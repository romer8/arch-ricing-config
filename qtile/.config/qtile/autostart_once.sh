#!/bin/bash

# Wallpaper + pywal colorscheme (bg fill color #282738)
wal -b 282738 -i ~/Wallpaper/Aesthetic2.png &

# Compositor (X11 only)
picom --config ~/.config/picom/picom.conf &

# Session manager + polkit authentication agent
lxsession &

# eww daemon (for the volume slider popup; opens instantly on toggle)
"$HOME"/.local/bin/eww --config "$HOME"/.config/eww daemon &
