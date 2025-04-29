#!/bin/bash

sketchybar --add item front_app center \
           --subscribe front_app front_app_switched \
           --set front_app script="$PLUGIN_DIR/front_app.sh" \
           icon.color=$(hex_to_rgba $fg) \
           label.color=$(hex_to_rgba $fg)

