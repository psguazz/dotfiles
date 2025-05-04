#!/bin/bash

sketchybar --add event aerospace_workspace_change

sketchybar --add item space.left_padding left \
           --set space.left_padding \
           width=20 \
           background.drawing=off

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

sketchybar --add item space.right_padding left \
           --set space.right_padding \
           width=0 \
           padding_right=-15 \
           background.drawing=off

sketchybar --add bracket spaces '/space\..*/' \
           --set spaces \
           background.color="$(hex_to_rgba $bg_dim '88')" \
           background.height=48 \
           background.border_width=0
