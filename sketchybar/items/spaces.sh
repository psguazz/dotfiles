#!/bin/bash

sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --monitor 1); do
  sketchybar --add item space.$sid left \
             --subscribe space.$sid space_windows_change aerospace_workspace_change \
             --set space.$sid \
             drawing=off \
             icon.font="Monaco Nerd Font:Bold:12.0" \
             icon="$sid" \
             label.font="sketchybar-app-font:Regular:11.0" \
             script="$PLUGIN_DIR/aerospace.sh $sid"
done
