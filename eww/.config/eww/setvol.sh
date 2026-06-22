#!/bin/bash
# Set volume from the eww scale. eww passes the new value (may be a float);
# strip any decimal part since pamixer wants an integer.
vol="${1%.*}"
[ -n "$vol" ] && pamixer --set-volume "$vol"
