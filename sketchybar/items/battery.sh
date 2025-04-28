#!/bin/bash

sketchybar --add item battery right \
           --set battery update_freq=10 script="$PLUGIN_DIR/battery.sh" \
           icon="!" \
           icon.padding_left=10 \
           icon.color=$(hex_to_rgba $fg) \
           label.padding_left=2 \
           background.corner_radius=5 \
           background.drawing=on \
           background.height=16 \
           background.color=$(hex_to_rgba $diff_red)
