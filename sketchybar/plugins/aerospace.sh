#!/bin/bash

source "/Users/psg/.config/scripts/palette.sh"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  color=$yellow
  border=$yellow
else
  color=$grey
  border=$bg_dim
fi

sketchybar --set $NAME \
           background.border_color="$(hex_to_rgba $border)" \
           icon.color=$(hex_to_rgba $grey) \
           label.color=$(hex_to_rgba $color)

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
