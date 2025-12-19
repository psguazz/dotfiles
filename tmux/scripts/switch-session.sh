#!/usr/bin/env bash

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

session=$(tmux list-sessions -F "#{session_name}" | fzf --prompt "Switch Session ❯ " --exit-0 --reverse --preview "$current_dir/tmux-tree.sh {} {q}" --preview-label " Sessions ")

tmux switch-client -t=$session 2>/dev/null

