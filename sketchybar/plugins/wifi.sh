#!/bin/bash

source "/Users/psg/.config/scripts/palette.sh"

SCRIPTS_DIR="/Users/psg/.config/scripts"

SSID=$($SCRIPTS_DIR/wifi_name.sh)

if [[ -z "$SSID" ]]; then
    color=$grey
    icon="󰖪"
else
    color=$blue
    icon="󰖩"
fi

sketchybar --set "$NAME" \
           label="$icon" \
           label.color=$(hex_to_rgba $color)
