#!/bin/bash

sketchybar --add item clock right \
           --set clock \
           background.border_color=$(hex_to_rgba $purple) \
           icon="󰃭" \
           label.color=$(hex_to_rgba $purple) \
           script="$PLUGIN_DIR/clock.sh" \
           update_freq=10
