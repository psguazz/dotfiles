#!/bin/bash

sketchybar --add item widget.left_padding right \
           --set widget.left_padding \
           width=20 \
           background.drawing=off

sketchybar --add item widget.clock right \
           --set widget.clock \
           background.color=$(hex_to_rgba $diff_blue) \
           icon.color=$(hex_to_rgba $purple) \
           icon="󰃭" \
           script="$PLUGIN_DIR/clock.sh" \
           update_freq=10

sketchybar --add item widget.battery right \
           --set widget.battery \
           background.color=$(hex_to_rgba $diff_red) \
           icon.color=$(hex_to_rgba $red) \
           script="$PLUGIN_DIR/battery.sh" \
           update_freq=10

sketchybar --add item widget.volume right \
           --subscribe widget.volume volume_change \
           --set widget.volume \
           background.color=$(hex_to_rgba $diff_green) \
           icon.color=$(hex_to_rgba $green) \
           script="$PLUGIN_DIR/volume.sh"

sketchybar --add item widget.wifi right \
           --subscribe widget.wifi wifi_change \
           --set widget.wifi \
           background.color=$(hex_to_rgba $diff_blue) \
           icon.color=$(hex_to_rgba $blue) \
           script="$PLUGIN_DIR/wifi.sh" \
           update_freq=10

sketchybar --add item widget.right_padding right \
           --set widget.right_padding \
           width=0 \
           padding_right=-15 \
           background.drawing=off

sketchybar --add bracket widgets '/widget\..*/' \
           --set widgets \
           background.color="$(hex_to_rgba $bg_dim 'aa')" \
           background.height=48 \
           background.border_width=0
           

