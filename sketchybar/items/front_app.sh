#!/bin/bash

sketchybar --add item front_app center \
           --subscribe front_app front_app_switched \
           --set front_app \
           background.border_width=0 \
           script="$PLUGIN_DIR/front_app.sh"

