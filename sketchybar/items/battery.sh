#!/bin/bash

sketchybar --add item battery right \
           --set battery \
           background.border_color=$(hex_to_rgba $red) \
           label.color=$(hex_to_rgba $red) \
           script="$PLUGIN_DIR/battery.sh" \
           update_freq=10
