#!/usr/bin/env bash

function cpu_load() {
    local idle=$(top -l 1 | awk '/CPU usage/ { sub(/%/, "", $7); print $7 }')
    echo $((100 - ${idle%.*}))
}

printf "%2s%%" "$(cpu_load)"
