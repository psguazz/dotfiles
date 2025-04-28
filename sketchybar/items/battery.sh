#!/bin/bash

sketchybar --add item battery right \
           --set battery update_freq=10 script="$PLUGIN_DIR/battery.sh" \
           background.color=$(hex_to_rgba $diff_red)
