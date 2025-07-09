#!/usr/bin/env bash

function memory_load() {
    local free=$(memory_pressure | awk '/System-wide memory free percentage/ {print $NF}')
    echo $((100 - ${free%\%}))
}

printf "M %2s%%" "$(memory_load)"
