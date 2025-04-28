#!/bin/bash

source "/Users/psg/.config/scripts/palette.sh"

sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --monitor 1); do
  sketchybar --add item space.$sid left \
    --subscribe space.$sid aerospace_workspace_change \
    --set space.$sid \
    click_script="aerospace workspace $sid" \
    script="$PLUGIN_DIR/aerospace.sh $sid" \
    drawing=off \
    icon="$sid" \
    icon.padding_left=10 \
    label.font="sketchybar-app-font:Regular:16.0" \
    label.padding_right=20 \
    label.padding_left=0 \
    background.corner_radius=5 \
    background.drawing=on \
    background.border_color=$(hex_to_rgba $grey) \
    background.border_width=2 \
    background.height=24
done

for sid in $(aerospace list-workspaces --monitor 1 --empty no); do
  apps=$(aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

  sketchybar --set space.$sid drawing=on

  icon_strip=""
  if [ "${apps}" != "" ]; then
    while read -r app; do
      icon_strip+=" $(/Users/psg/.config/scripts/icon_map_fn.sh "$app")"
    done <<<"${apps}"
  fi
  sketchybar --set space.$sid label="$icon_strip"
done
