#!/bin/bash

sketchybar --add item wifi right \
           --subscribe wifi wifi_change \
           --set wifi \
           icon.color=$(hex_to_rgba $blue) \
           script="$PLUGIN_DIR/wifi.sh" \
           update_freq=10
