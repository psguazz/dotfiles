#!/bin/bash

sketchybar --add item wifi right \
           --subscribe wifi wifi_change \
           --set wifi script="$PLUGIN_DIR/wifi.sh" \
           background.border_color=$(hex_to_rgba $orange) \
           icon.color=$(hex_to_rgba $orange)
