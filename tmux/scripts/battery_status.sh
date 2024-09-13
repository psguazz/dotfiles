#!/usr/bin/env bash

function battery_status() {
    local status=$(pmset -g batt | sed -n 2p | cut -d ';' -f 2 | tr -d " ")

    case $status in
        discharging|Discharging)
            echo '󰁿'
            ;;
        high|Full)
            echo '󰁹'
            ;;
        charging|Charging)
            echo '󱐌'
            ;;
        *)
            echo '󱐌'
            ;;
    esac
}

echo "$(battery_status)"
