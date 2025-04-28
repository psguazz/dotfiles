#!/bin/bash

sketchybar --add item clock right \
           --set clock update_freq=10 script="$PLUGIN_DIR/clock.sh" \
           icon="󰃭" \
           icon.color=$(hex_to_rgba $grey) \
           label.padding_right=10 \
           background.color=$(hex_to_rgba $diff_blue)

