#!/usr/bin/env bash

function battery_level() {
    local level=$(pmset -g batt | grep -o "\d*%" | head -n 1)

    echo "${level}"
}

echo "$(battery_level)"
