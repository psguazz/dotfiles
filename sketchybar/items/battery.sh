#!/bin/bash

sketchybar --add item battery right \
           --set battery \
           icon.color=$(hex_to_rgba $red) \
           script="$PLUGIN_DIR/battery.sh" \
           update_freq=10
