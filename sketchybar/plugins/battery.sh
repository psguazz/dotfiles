#!/bin/sh

SCRIPTS_DIR="/Users/psg/.config/scripts"

ICON=$($SCRIPTS_DIR/battery_status.sh)
PERCENTAGE=$($SCRIPTS_DIR/battery_level.sh)

sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}"
