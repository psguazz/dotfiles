#!/bin/bash

sketchybar --add item volume right \
           --subscribe volume volume_change \
           --set volume \
           background.border_color=$(hex_to_rgba $green) \
           label.color=$(hex_to_rgba $green) \
           script="$PLUGIN_DIR/volume.sh"
