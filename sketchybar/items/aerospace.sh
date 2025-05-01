#!/bin/bash

sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --monitor 1); do
  sketchybar --add item space.$sid left \
             --subscribe space.$sid space_windows_change aerospace_workspace_change \
             --set space.$sid \
             background.drawing=off \
             drawing=off \
             icon.font="Monaco Nerd Font:Bold:12.0" \
             icon="$sid" \
             padding_left=0 \
             padding_right=0 \
             label.font="sketchybar-app-font:Regular:11.0" \
             script="$PLUGIN_DIR/aerospace.sh $sid"
done

sketchybar --add bracket spaces '/space\..*/' \
           --set spaces \
           background.padding_left=100 \
           background.padding_right=0
