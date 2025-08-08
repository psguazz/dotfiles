#!/usr/bin/env bash

function wifi_name() {
    local name=$(ipconfig getsummary en0 | grep " SSID :" | sed "s/.*SSID : //")
    echo "${name}"
}

echo "$(wifi_name)"
