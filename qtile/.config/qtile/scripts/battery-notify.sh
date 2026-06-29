#!/bin/bash
# Low-battery notifier -> dunst. Runs as a background loop (from autostart).
# Notifies once when crossing the low/critical thresholds; rearms on charge.
WARN=20
CRIT=10
INTERVAL=120
state=""   # "", "warn", "crit"

# single-instance guard
exec 9>"/tmp/eww-battery-notify.lock"
flock -n 9 || exit 0

batt_pct() {
  local now=0 full=0 b
  for b in /sys/class/power_supply/BAT*; do
    if   [ -r "$b/energy_now" ]; then now=$((now+$(cat "$b/energy_now"))); full=$((full+$(cat "$b/energy_full")))
    elif [ -r "$b/charge_now" ]; then now=$((now+$(cat "$b/charge_now"))); full=$((full+$(cat "$b/charge_full"))); fi
  done
  [ "$full" -gt 0 ] && echo $((100*now/full)) || echo 100
}

charging() {
  local b
  for b in /sys/class/power_supply/BAT*; do
    [ "$(cat "$b/status" 2>/dev/null)" = "Charging" ] && return 0
  done
  return 1
}

notify() { # urgency icon title body
  notify-send -u "$1" -i "$2" -h string:x-dunst-stack-tag:battery -a "battery" "$3" "$4"
}

while true; do
  pct=$(batt_pct)
  if charging; then
    state=""                       # rearm warnings for the next discharge
  elif [ "$pct" -le "$CRIT" ]; then
    [ "$state" != "crit" ] && { notify critical battery-caution "Battery critically low" "${pct}% left — plug in now!"; state="crit"; }
  elif [ "$pct" -le "$WARN" ]; then
    [ "$state" = "" ] && { notify normal battery-low "Battery low" "${pct}% remaining"; state="warn"; }
  else
    state=""
  fi
  sleep "$INTERVAL"
done
