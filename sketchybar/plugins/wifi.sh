#!/bin/bash

SCRIPTS_DIR="/Users/psg/.config/scripts"

SSID=$($SCRIPTS_DIR/wifi_name.sh)

if [[ -z "$SSID" ]]; then
    SSID="No WiFi"
    ICON="󰖪"
else
    ICON="󰖩"
fi

sketchybar --set "$NAME" icon="$ICON" label="$SSID"
