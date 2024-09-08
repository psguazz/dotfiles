#!/usr/bin/env bash

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$current_dir/palette.sh"

SELECTED_SESSION=$1

tmux ls -F "#{session_name}: #{T:tree_mode_format}" | while read -r DESC; do
    NAME=${DESC%%:*}

    if [[ "$SELECTED_SESSION" == "$NAME" ]]; then
        color_echo $yellow $DESC
    else
        color_echo $fg $DESC
    fi

    set_color $grey
    tmux lsw -t "$NAME" -F "   󱞩 #{window_name}" 
    reset_color
done
