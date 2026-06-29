#!/bin/bash
# Combined battery state for eww (handles the dual BAT0/BAT1 setup).
# Emits JSON: {"pct":NN,"status":"Charging|Discharging|Full","icon":"<glyph>"}
now=0; full=0; charging=0; anyfull=1
for b in /sys/class/power_supply/BAT*; do
  if [ -r "$b/energy_now" ]; then
    now=$((now + $(cat "$b/energy_now"))); full=$((full + $(cat "$b/energy_full")))
  elif [ -r "$b/charge_now" ]; then
    now=$((now + $(cat "$b/charge_now"))); full=$((full + $(cat "$b/charge_full")))
  fi
  s=$(cat "$b/status" 2>/dev/null)
  [ "$s" = "Charging" ] && charging=1
  [ "$s" != "Full" ] && anyfull=0
done

pct=0
[ "$full" -gt 0 ] && pct=$((100 * now / full))
[ "$pct" -gt 100 ] && pct=100

if [ "$charging" -eq 1 ]; then
  status="Charging"; icon="󰂄"
elif [ "$anyfull" -eq 1 ]; then
  status="Full"; icon="󰁹"
else
  status="Discharging"
  if   [ "$pct" -ge 90 ]; then icon="󰁹"
  elif [ "$pct" -ge 70 ]; then icon="󰂁"
  elif [ "$pct" -ge 50 ]; then icon="󰁾"
  elif [ "$pct" -ge 30 ]; then icon="󰁻"
  elif [ "$pct" -ge 10 ]; then icon="󰁺"
  else icon="󰂎"; fi
fi

# "bar" mode: just the combined percentage (the qtile bar already has its own
# static battery icon TextBox next to it).
if [ "$1" = "bar" ]; then
  printf '%d%%\n' "$pct"
  exit
fi

printf '{"pct":%d,"status":"%s","icon":"%s"}\n' "$pct" "$status" "$icon"
