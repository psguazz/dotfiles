#!/bin/bash

sketchybar --add item clock right \
           --set clock \
           background.color=$(hex_to_rgba $diff_blue) \
           icon.color=$(hex_to_rgba $purple) \
           icon="󰃭" \
           script="$PLUGIN_DIR/clock.sh" \
           update_freq=10

sketchybar --add item battery right \
           --set battery \
           background.color=$(hex_to_rgba $diff_red) \
           icon.color=$(hex_to_rgba $red) \
           script="$PLUGIN_DIR/battery.sh" \
           update_freq=10

sketchybar --add item volume right \
           --subscribe volume volume_change \
           --set volume \
           background.color=$(hex_to_rgba $diff_green) \
           icon.color=$(hex_to_rgba $green) \
           script="$PLUGIN_DIR/volume.sh"

sketchybar --add item wifi right \
           --subscribe wifi wifi_change \
           --set wifi \
           background.color=$(hex_to_rgba $diff_blue) \
           icon.color=$(hex_to_rgba $blue) \
           script="$PLUGIN_DIR/wifi.sh" \
           padding_left=2 \
           update_freq=10
