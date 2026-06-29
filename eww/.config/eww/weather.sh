#!/bin/bash
# Keyless weather via wttr.in (location auto-detected from IP).
# Maps the condition to a Nerd Font (Material Design) glyph so it always
# renders, instead of wttr.in's emoji (some of which the font lacks).
# Emits JSON: {"icon":"<glyph>","temp":"+21C","desc":"Partly cloudy"}
raw=$(curl -s --max-time 8 'wttr.in/?format=%t|%C' 2>/dev/null)
if [ -z "$raw" ]; then
  printf '{"icon":"󰅤","temp":"--","desc":"offline"}\n'
  exit
fi
temp=$(printf '%s' "$raw" | cut -d'|' -f1 | xargs)
desc=$(printf '%s' "$raw" | cut -d'|' -f2 | xargs)

d=$(printf '%s' "$desc" | tr '[:upper:]' '[:lower:]')
case "$d" in
  *thunder*|*storm*)          icon="󰖓" ;;
  *snow*|*sleet*|*ice*|*blizzard*) icon="󰼶" ;;
  *rain*|*drizzle*|*shower*)  icon="󰖗" ;;
  *fog*|*mist*|*haze*|*smoke*) icon="󰖑" ;;
  *partly*|*partially*)       icon="󰖕" ;;
  *overcast*|*cloud*)         icon="󰖐" ;;
  *clear*|*sunny*)            icon="󰖙" ;;
  *)                          icon="󰖙" ;;
esac

esc() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }
printf '{"icon":"%s","temp":"%s","desc":"%s"}\n' "$icon" "$(esc "$temp")" "$(esc "$desc")"
