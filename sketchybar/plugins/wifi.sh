#!/bin/bash

airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
info=$($airport -I)

state=$(echo "$info" | awk '/state/ { print $2 }')

# Default disconnected icon
ICON=""  # Or anything you prefer for "disconnected"

if [[ "$state" == "running" ]]; then
  rssi=$(echo "$info" | awk '/agrCtlRSSI/ { print $2 }')
  
  # Determine signal strength
  if [ "$rssi" -gt -60 ]; then
    ICON="󰤨" # Excellent (full bars)
  elif [ "$rssi" -gt -70 ]; then
    ICON="󰤥" # Good (3 bars)
  elif [ "$rssi" -gt -80 ]; then
    ICON="󰤢" # Weak (2 bars)
  else
    ICON="󰤟" # Very weak (1 bar)
  fi

  # (optional) Ping test to confirm actual internet access
  if ! ping -c 1 -W 1 8.8.8.8 &> /dev/null; then
    ICON="󰖪" # Connected to Wi-Fi but no internet
  fi
fi

sketchybar --set $NAME icon="$ICON" icon.font="Monaco Nerd Font:Bold:20.0"
