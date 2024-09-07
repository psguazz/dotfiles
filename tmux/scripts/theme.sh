#!/usr/bin/env bash

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$current_dir/palette.sh"

# MISC

tmux set-option -g status-left-length 100
tmux set-option -g status-right-length 100

tmux set -g base-index 1
tmux set -g pane-base-index 1
tmux set-window-option -g pane-base-index 1
tmux set-option -g renumber-windows on

tmux set-option -g status-interval 5
tmux set-option -g automatic-rename on
tmux set-option -g automatic-rename-format "#{pane_current_command} | #{b:pane_current_path}"

tmux set-option -g mode-style "bg=${yellow},fg=${black}"
tmux set-option -g pane-active-border-style "fg=${green}"
tmux set-option -g pane-border-style "fg=${grey}"
tmux set-option -g message-style "bg=${grey_dim},fg=${fg}"
tmux set-option -g status-style "bg=${bg1},fg=${fg}"

# SESSION

left_pill="#[fg=${bg_green},bg=${bg1}]#{?client_prefix,#[fg=${orange}],}"
right_pill="#[fg=${bg_green},bg=${bg1}]#{?client_prefix,#[fg=${orange}],}"
session="#[fg=${black},bg=${bg_green}]#{?client_prefix,#[bg=${orange}],} #S"
tmux set-option -g status-left "${left_pill}${session}${right_pill} "

# WINDOWS 

left_pill="#[fg=${orange},bg=${bg1}]"
window_number="#[fg=${black},bg=${orange}]#I"
window_name=" #[fg=${fg},bg=${grey}] #W"
right_pill="#[fg=${grey},bg=${bg1}]"
tmux set-window-option -g window-status-current-format "${left_pill}${window_number}${window_name}${right_pill}"

left_pill="#[fg=${grey_dim},bg=${bg1}]"
window_number="#[fg=${fg},bg=${grey_dim}]#I"
window_name=" #[fg=${fg},bg=${bg1}] #W"
right_pill="#[fg=${bg1},bg=${bg1}]"
tmux set-window-option -g window-status-format "${left_pill}${window_number}${window_name}${right_pill}"

# PLUGINS

tmux set-option -g status-right ""

left_pill=" #[fg=${bg_green},bg=${bg1}]"
content="#[fg=${black},bg=${bg_green}]${text}"
right_pill="#[fg=${bg_green},bg=${bg1}]"
tmux set-option -ga status-right "${left_pill}${content}󰃭 %a %-e %b %-l:%M %p${right_pill}"

left_pill=" #[fg=${bg_red},bg=${bg1}]"
content="#[fg=${black},bg=${bg_red}]${text}"
right_pill="#[fg=${bg_red},bg=${bg1}]"
tmux set-option -ga status-right "${left_pill}${content}#($current_dir/battery.sh)${right_pill}"
