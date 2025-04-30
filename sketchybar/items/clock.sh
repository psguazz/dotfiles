#!/bin/bash

sketchybar --add item clock right \
           --set clock \
           icon="󰃭" \
           icon.color=$(hex_to_rgba $purple) \
           script="$PLUGIN_DIR/clock.sh" \
           update_freq=10
