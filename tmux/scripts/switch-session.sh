#!/usr/bin/env bash

SESSION_DESC=$(tmux list-sessions | fzf --exit-0 --reverse)
SESSION=${SESSION_DESC%%:*}

tmux switch-client -t $SESSION
