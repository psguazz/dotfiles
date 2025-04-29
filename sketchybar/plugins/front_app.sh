#!/bin/bash

ICON=$(/Users/psg/.config/scripts/icon_map_fn.sh "$INFO")

sketchybar --set "$NAME" label="$INFO" icon="$ICON" icon.font="sketchybar-app-font:Regular:12.0"
