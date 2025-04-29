#!/bin/bash

sketchybar --add item battery right \
           --set battery update_freq=10 script="$PLUGIN_DIR/battery.sh" \
           background.border_color=$(hex_to_rgba $red) \
           label.color=$(hex_to_rgba $red)
