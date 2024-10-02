#!/usr/bin/env bash

function level_icon() {
    local level=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)

    if [[ "$level" -ge 90 ]]; then
        echo "󰁹"
    elif [[ "$level" -ge 80 ]]; then
        echo "󰂁"
    elif [[ "$level" -ge 70 ]]; then
        echo "󰂀"
    elif [[ "$level" -ge 60 ]]; then
        echo "󰁿"
    elif [[ "$level" -ge 50 ]]; then
        echo "󰁾"
    elif [[ "$level" -ge 40 ]]; then
        echo "󰁽"
    elif [[ "$level" -ge 30 ]]; then
        echo "󰁼"
    elif [[ "$level" -ge 20 ]]; then
        echo "󰁻"
    elif [[ "$level" -ge 10 ]]; then
        echo "󰁺"
    else
        echo "󰂎"
    fi
}

function battery_status() {
    local status=$(pmset -g batt | sed -n 2p | cut -d ";" -f 2 | tr -d " ")

    case $status in
        charging|charged)
            echo "󱐌"
            ;;
        acattached|ACattached)
            echo ""
            ;;
        *)
            echo $(level_icon)
            ;;
    esac
}

echo "$(battery_status)"
