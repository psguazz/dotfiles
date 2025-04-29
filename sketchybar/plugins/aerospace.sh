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

icon_strip=""
apps=$(aerospace list-windows --workspace "$1" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

if [ "${apps}" != "" ]; then
  while read -r app; do
    icon_strip+=" $(/Users/psg/.config/scripts/icon_map_fn.sh "$app")"
  done <<<"${apps}"

  sketchybar --set $NAME label="$icon_strip" drawing=on
else
  sketchybar --set $NAME drawing=off
fi
