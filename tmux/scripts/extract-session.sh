#!/usr/bin/env bash

START_PATH=$1

CURRENT_SESSION="$(tmux display-message -p '#S')"

TARGET_SESSION="$(basename $START_PATH)"
TARGET_SESSION=${TARGET_SESSION//\./}

tmux has-session -t="$TARGET_SESSION" 2>/dev/null

if [ $? != 0 ]; then
    tmux new-session -d -s $TARGET_SESSION -c $START_PATH
    tmux switch-client -t $TARGET_SESSION
    tmux switch-client -t $CURRENT_SESSION

    tmux move-window -t $TARGET_SESSION
    tmux switch-client -t $TARGET_SESSION:2
    tmux kill-window -a
else
    tmux move-window -t $TARGET_SESSION
    tmux switch-client -t $TARGET_SESSION
fi

