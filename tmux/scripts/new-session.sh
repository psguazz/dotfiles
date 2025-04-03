#!/usr/bin/env bash

start_path=$(find ~ ~/paradem ~/projects ~/master_ai -mindepth 1 -maxdepth 1 -type d | fzf --prompt "New Session ❯ " --exit-0 --reverse)

target_session="$(basename $start_path)"
target_session=${target_session//\./}

tmux has-session -t="$target_session" 2>/dev/null

if [ $? != 0 ]; then
    tmux new-session -d -s $target_session -c $start_path
    tmux new-window -t $target_session -c $start_path
    tmux new-window -t $target_session -c $start_path
    tmux select-window -t $target_session:2
    tmux send-keys -t $target_session:2 "nvim" C-m
    tmux send-keys -t $target_session:2 ":Zoff" C-m
fi

tmux switch-client -t=$target_session
