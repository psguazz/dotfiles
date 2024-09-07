#!/usr/bin/env bash

echo "Go to Session >"

SESSION_DESC=$(tmux list-sessions | fzf --prompt "Switch Session > " --exit-0 --reverse)
SESSION=${SESSION_DESC%%:*}

tmux switch-client -t $SESSION
