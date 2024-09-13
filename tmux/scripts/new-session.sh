#!/usr/bin/env bash

START_PATH=$(find ~ ~/paradem ~/projects ~/master_ai -mindepth 1 -maxdepth 1 -type d | fzf --prompt "New Session ❯ " --exit-0 --reverse)

TARGET_SESSION="$(basename $START_PATH)"
TARGET_SESSION=${TARGET_SESSION//\./}

tmux has-session -t="$TARGET_SESSION" 2>/dev/null

if [ $? != 0 ]; then
    tmux new-session -d -s $TARGET_SESSION -c $START_PATH
fi

tmux switch-client -t=$TARGET_SESSION
