#!/bin/bash

sketchybar --add item volume right \
           --subscribe volume volume_change \
           --set volume script="$PLUGIN_DIR/volume.sh" \
           icon="!" \
           icon.padding_left=10 \
           icon.color=$(hex_to_rgba $fg) \
           label.padding_left=0 \
           background.corner_radius=5 \
           background.drawing=on \
           background.height=16 \
           background.color=$(hex_to_rgba $diff_green)
