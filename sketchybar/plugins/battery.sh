#!/bin/bash

SCRIPTS_DIR="/Users/psg/.config/scripts"

ICON=$($SCRIPTS_DIR/battery_status.sh)

sketchybar --set "$NAME" icon="$ICON" icon.font="Monaco Nerd Font:Bold:14.0"
