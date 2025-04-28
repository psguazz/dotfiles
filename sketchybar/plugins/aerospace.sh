#!/bin/bash

source "/Users/psg/.config/scripts/palette.sh"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  bg=$diff_yellow
  icon=$grey
  label=$fg
else
  bg=$bg_dim
  icon=$grey
  label=$grey
fi

sketchybar --set $NAME \
           background.color="$(hex_to_rgba $bg)" \
           icon.color=$(hex_to_rgba $icon) \
           label.color=$(hex_to_rgba $label)
