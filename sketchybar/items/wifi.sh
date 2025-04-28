#!/bin/bash

sketchybar --add item wifi right \
           --subscribe wifi wifi_change \
           --set wifi script="$PLUGIN_DIR/wifi.sh" \
           background.color=$(hex_to_rgba $diff_yellow)
