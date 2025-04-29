#!/bin/bash

airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
info=$($airport -I)

state=$(echo "$info" | awk '/state/ { print $2 }')

SSID="No connection"
ICON="󰤭"

if [[ "$state" == "running" ]]; then
  rssi=$(echo "$info" | awk '/agrCtlRSSI/ { print $2 }')
  
  if [ "$rssi" -gt -60 ]; then
    ICON="󰤨"
  elif [ "$rssi" -gt -70 ]; then
    ICON="󰤥"
  elif [ "$rssi" -gt -80 ]; then
    ICON="󰤢"
  else
    ICON="󰤟"
  fi

  if ! ping -c 1 -W 1 8.8.8.8 &> /dev/null; then
    ICON="󰖪"
  fi

  SSID=$(networksetup -getairportnetwork en0 | awk -F': ' '{print $2}')
fi

sketchybar --set $NAME icon="$ICON" label="$SSID"
