#!/bin/bash
# Launch neomutt in a larger-font Alacritty window (mail is easier to read).
# Tweak FONT_SIZE to taste; doesn't affect your normal terminals.
FONT_SIZE=16
exec alacritty -o "font.size=${FONT_SIZE}" -e neomutt
