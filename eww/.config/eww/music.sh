#!/bin/bash
# YouTube Music (Brave tab) now-playing helper for eww.
#   no arg  -> print JSON for defpoll (status/title/artist/art path)
#   toggle  -> play/pause   next -> skip fwd   prev -> skip back
# Prefers a Brave MPRIS player; falls back to the first available one.

get_player() {
  local p
  p=$(playerctl -l 2>/dev/null | grep -m1 -i brave)
  [ -z "$p" ] && p=$(playerctl -l 2>/dev/null | head -n1)
  printf '%s' "$p"
}

player=$(get_player)

case "$1" in
  toggle) [ -n "$player" ] && playerctl -p "$player" play-pause; exit ;;
  next)   [ -n "$player" ] && playerctl -p "$player" next;       exit ;;
  prev)   [ -n "$player" ] && playerctl -p "$player" previous;   exit ;;
esac

# No player running at all
if [ -z "$player" ]; then
  printf '{"status":"Stopped","title":"Nothing playing","artist":"","art":""}\n'
  exit
fi

status=$(playerctl -p "$player" status        2>/dev/null)
title=$(playerctl  -p "$player" metadata title 2>/dev/null)
artist=$(playerctl -p "$player" metadata artist 2>/dev/null)
arturl=$(playerctl -p "$player" metadata mpris:artUrl 2>/dev/null)

# Album art: download once per song (filename keyed to the URL so the path
# changes between songs, which forces eww to re-render the image).
art=""
if [ -n "$arturl" ]; then
  hash=$(printf '%s' "$arturl" | md5sum | cut -c1-8)
  ART="/tmp/eww-music-art-${hash}.png"
  if [ ! -f "$ART" ]; then
    rm -f /tmp/eww-music-art-*.png
    curl -sf "$arturl" -o "$ART" || ART=""
  fi
  art="$ART"
fi

[ -z "$title" ] && title="Nothing playing"

# Emit JSON, escaping backslashes and quotes in free-text fields.
esc() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }
printf '{"status":"%s","title":"%s","artist":"%s","art":"%s"}\n' \
  "$(esc "$status")" "$(esc "$title")" "$(esc "$artist")" "$art"
