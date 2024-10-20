#!/usr/bin/env bash

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$current_dir/palette.sh"

selected_session=$1

tmux ls -F "#{session_name}: #{T:tree_mode_format}" | while read -r desc; do
    name=${desc%%:*}

    if [[ "$selected_session" == "$name" ]]; then
        color_echo $yellow $desc
    else
        color_echo $fg $desc
    fi

    set_color $grey
    tmux lsw -t "$name" -F "   󱞩 #{window_name}"
    reset_color
done
