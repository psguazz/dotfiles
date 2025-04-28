#!/bin/bash

sketchybar --add item volume right \
           --subscribe volume volume_change \
           --set volume script="$PLUGIN_DIR/volume.sh" \
           background.color=$(hex_to_rgba $diff_green)
