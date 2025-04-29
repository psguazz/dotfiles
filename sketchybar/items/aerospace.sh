#!/bin/bash

sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --monitor 1); do
  sketchybar --add item space.$sid left \
             --subscribe space.$sid space_windows_change aerospace_workspace_change \
             --set space.$sid \
             background.border_color=$(hex_to_rgba $yellow) \
             click_script="aerospace workspace $sid" \
             drawing=off \
             icon="$sid" \
             label.font="sketchybar-app-font:Regular:11.0" \
             label.padding_right=15 \
             script="$PLUGIN_DIR/aerospace.sh $sid"
done
