#!/bin/bash

sketchybar --add item clock right \
           --set clock update_freq=10 script="$PLUGIN_DIR/clock.sh" \
           background.border_color=$(hex_to_rgba $purple) \
           icon.color=$(hex_to_rgba $grey) \
           icon="󰃭" \
           label.color=$(hex_to_rgba $purple) \
           label.padding_right=10

