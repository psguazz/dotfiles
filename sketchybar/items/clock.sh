#!/bin/bash

sketchybar --add item clock right \
           --set clock update_freq=10 script="$PLUGIN_DIR/clock.sh" \
           icon="󰃭" \
           icon.padding_left=10 \
           icon.color=$(hex_to_rgba $grey) \
           label.padding_right=10 \
           label.padding_left=5 \
           background.corner_radius=5 \
           background.drawing=on \
           background.height=16 \
           background.color=$(hex_to_rgba $diff_blue)

