#!/bin/bash

sketchybar --add item widget.clock right \
           --set widget.clock \
           background.color=$(hex_to_rgba $bg_blue) \
           icon.color=$(hex_to_rgba $purple) \
           icon="󰃭" \
           script="$PLUGIN_DIR/clock.sh" \
           update_freq=10

sketchybar --add item widget.battery right \
           --set widget.battery \
           background.color=$(hex_to_rgba $bg_red) \
           icon.color=$(hex_to_rgba $red) \
           script="$PLUGIN_DIR/battery.sh" \
           update_freq=10

sketchybar --add item widget.volume right \
           --subscribe widget.volume volume_change \
           --set widget.volume \
           background.color=$(hex_to_rgba $bg_green) \
           icon.color=$(hex_to_rgba $green) \
           script="$PLUGIN_DIR/volume.sh"

sketchybar --add item widget.wifi right \
           --set widget.wifi \
           background.color=$(hex_to_rgba $bg_blue) \
           icon.padding_left=5 \
           script="$PLUGIN_DIR/wifi.sh" \
           update_freq=10
