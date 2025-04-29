#!/bin/bash

sketchybar --add item wifi right \
           --subscribe wifi wifi_change \
           --set wifi \
           background.border_color=$(hex_to_rgba $orange) \
           label.color=$(hex_to_rgba $orange) \
           script="$PLUGIN_DIR/wifi.sh" \
           update_freq=10
