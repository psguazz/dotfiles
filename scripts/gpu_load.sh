#!/usr/bin/env bash

util=$(ioreg -r -c "IOAccelerator" -d 2 | grep "Device Utilization %" | sed -E 's/.*"Device Utilization %"=([0-9]+(\.[0-9]+)?).*/\1/')

if [[ -z "$util" ]]; then
    util="--"
fi

printf "%2s%%" "$util"
