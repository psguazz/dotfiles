#!/bin/bash

sketchybar --add item volume right \
           --subscribe volume volume_change \
           --set volume script="$PLUGIN_DIR/volume.sh" \
           background.border_color=$(hex_to_rgba $green) \
           label.color=$(hex_to_rgba $green)
