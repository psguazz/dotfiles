#!/usr/bin/env bash

function gpu_load() {
    local idle=$(sudo powermetrics --samplers gpu_power -i500 -n1 | awk -F': ' '/GPU idle residency/ { print $2 }' | tr -d '%')
    echo $((100 - ${idle%.*}))
}

printf "G %2s%%" "$(gpu_load)"
