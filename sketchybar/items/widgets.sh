#!/bin/bash

sketchybar --add item clock right \
           --set clock \
           background.color=$(hex_to_rgba $diff_blue) \
           background.border_width=0 \
           background.height=24 \
           icon.color=$(hex_to_rgba $purple) \
           icon="󰃭" \
           script="$PLUGIN_DIR/clock.sh" \
           padding_right=2 \
           update_freq=10

sketchybar --add item battery right \
           --set battery \
           background.color=$(hex_to_rgba $diff_red) \
           background.border_width=0 \
           background.height=24 \
           icon.color=$(hex_to_rgba $red) \
           script="$PLUGIN_DIR/battery.sh" \
           update_freq=10

sketchybar --add item volume right \
           --subscribe volume volume_change \
           --set volume \
           background.color=$(hex_to_rgba $diff_green) \
           background.border_width=0 \
           background.height=24 \
           icon.color=$(hex_to_rgba $green) \
           script="$PLUGIN_DIR/volume.sh"

sketchybar --add item wifi right \
           --subscribe wifi wifi_change \
           --set wifi \
           background.color=$(hex_to_rgba $diff_blue) \
           background.border_width=0 \
           background.height=24 \
           icon.color=$(hex_to_rgba $blue) \
           script="$PLUGIN_DIR/wifi.sh" \
           padding_left=2 \
           update_freq=10

sketchybar --add bracket widgets clock battery volume wifi
