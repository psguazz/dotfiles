#!/bin/bash

sketchybar --add item volume right \
           --subscribe volume volume_change \
           --set volume \
           icon.color=$(hex_to_rgba $green) \
           script="$PLUGIN_DIR/volume.sh"
