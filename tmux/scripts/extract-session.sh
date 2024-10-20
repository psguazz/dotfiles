#!/usr/bin/env bash

start_path=$1

current_session="$(tmux display-message -p "#S")"

target_session="$(basename $start_path)"
target_session=${target_session//\./}

tmux has-session -t="$target_session" 2>/dev/null

if [ $? != 0 ]; then
    tmux new-session -d -s $target_session -c $start_path
    tmux switch-client -t $target_session
    tmux switch-client -t $current_session

    tmux move-window -t $target_session
    tmux switch-client -t $target_session:2
    tmux kill-window -a
else
    tmux move-window -t $target_session
    tmux switch-client -t $target_session
fi

