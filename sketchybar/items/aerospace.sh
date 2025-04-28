#!/bin/bash

sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --monitor 1); do
  sketchybar --add item space.$sid left \
             --subscribe space.$sid aerospace_workspace_change \
             --set space.$sid \
             click_script="aerospace workspace $sid" \
             script="$PLUGIN_DIR/aerospace.sh $sid" \
             drawing=off \
             icon="$sid" \
             label.padding_right=15 \
             label.font="sketchybar-app-font:Regular:11.0" 
done
