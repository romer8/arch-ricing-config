#!/bin/bash

# Wallpaper + pywal colorscheme (bg fill color #282738)
wal -b 282738 -i ~/Wallpaper/Aesthetic2.png &

# Compositor (X11 only)
picom --config ~/.config/picom/picom.conf &

# Notification daemon (use dunst for theming + history; replace gnome's)
( pkill -x notification-daemon; sleep 0.5; dunst ) &

# Low-battery notifier
"$HOME"/.config/qtile/scripts/battery-notify.sh &

# Session manager + polkit authentication agent
lxsession &

# eww daemon (for the volume slider popup; opens instantly on toggle)
"$HOME"/.local/bin/eww --config "$HOME"/.config/eww daemon &
