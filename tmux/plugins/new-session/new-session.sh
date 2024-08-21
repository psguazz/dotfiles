#!/usr/bin/env bash

START_PATH=$1
SESSION_NAME="$(basename $START_PATH)"

tmux has-session -t "$SESSION_NAME" 2>/dev/null

if [ $? != 0 ]; then
    tmux new-session -d -s $SESSION_NAME -c "$START_PATH"
fi

tmux switch-client -t "$SESSION_NAME"
