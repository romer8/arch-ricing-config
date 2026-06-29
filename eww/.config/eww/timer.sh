#!/bin/bash
# Pomodoro-style focus timer for eww. State lives in a tmp file; the running
# countdown is derived from an end-epoch so no background ticker is needed.
#   no arg -> print JSON {"time":"MM:SS","running":0|1}
#   toggle -> start/pause      reset -> back to default duration
F="/tmp/eww-focus.state"
DEFAULT=1500   # 25 minutes

running=0; endt=0; remaining=$DEFAULT
[ -f "$F" ] && . "$F" 2>/dev/null

now=$(date +%s)

cur_remaining() {
  if [ "$running" = "1" ]; then
    local r=$((endt - now)); [ "$r" -lt 0 ] && r=0; echo "$r"
  else
    echo "$remaining"
  fi
}

save() { printf 'running=%s\nendt=%s\nremaining=%s\n' "$running" "$endt" "$remaining" > "$F"; }

case "$1" in
  toggle)
    if [ "$running" = "1" ]; then
      remaining=$(cur_remaining); running=0
    else
      [ "$remaining" -le 0 ] && remaining=$DEFAULT
      endt=$((now + remaining)); running=1
    fi
    save; exit ;;
  reset)
    running=0; remaining=$DEFAULT; save; exit ;;
esac

r=$(cur_remaining)
if [ "$running" = "1" ] && [ "$r" -le 0 ]; then
  running=0; remaining=$DEFAULT; save
  command -v notify-send >/dev/null && notify-send -i alarm "Focus" "Time's up — take a break!"
  r=0
fi
printf '{"time":"%02d:%02d","running":%s}\n' "$((r/60))" "$((r%60))" "${running:-0}"
