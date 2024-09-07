#!/usr/bin/env bash

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SESSION=$(tmux list-sessions -F "#{session_name}" | fzf --prompt "Switch Session > " --exit-0 --reverse --preview "$current_dir/tmux-tree.sh {}")

tmux switch-client -t $SESSION 2>/dev/null

