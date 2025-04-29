#!/bin/bash

source "/Users/psg/.config/scripts/palette.sh"

if [ "$SENDER" = "aerospace_workspace_change" ]; then
  if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    color=$yellow
    border=1
  else
    color=$grey
    border=0
  fi

  sketchybar --set $NAME \
             background.border_width="$border" \
             icon.color=$(hex_to_rgba $grey) \
             label.color=$(hex_to_rgba $color)
fi

if [ "$SENDER" = "space_windows_change" ]; then
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
fi
