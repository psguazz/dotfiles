#!/bin/bash

if [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --set "$NAME" label="$INFO" icon="$(/Users/psg/.config/scripts/icon_map_fn.sh "$INFO")" icon.font="sketchybar-app-font:Regular:16.0"
fi
