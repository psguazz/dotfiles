#!/usr/bin/env bash

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$current_dir/palette.sh"

function pill () {
    local icon_color=$1
    local content_color=$2
    local icon=$3
    local content=$4

    left_pill="#[fg=${icon_color}]#[bg=${bg_dim}]"
    left_content="#[fg=${black}]#[bg=${icon_color}]${icon} "
    right_content="#[fg=${fg}]#[bg=${content_color}] ${content} "
    right_pill="#[fg=${content_color}]#[bg=${bg_dim}]"

    echo "${left_pill}${left_content}${right_content}${right_pill}"
}

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
tmux set-option -g status-style "bg=${bg_dim},fg=${fg}"
tmux set -g popup-border-style "fg=${grey}"
tmux set -g popup-border-lines rounded

# SESSION

session_prefix=$(pill $orange $diff_yellow "" "#S")
session_regular=$(pill $bg_green $diff_green "" "#S")
separator="#[fg=${grey_dim}] | "

tmux set-option -g status-left "#{?client_prefix,${session_prefix},${session_regular}}${separator}"

# WINDOWS 

current_window=$(pill $yellow $diff_yellow "#I" "#W")
tmux set-window-option -g window-status-current-format "$current_window"

other_windows=$(pill $grey_dim $bg_dim "#[fg=${fg}]#I" "#W")
tmux set-window-option -g window-status-format "$other_windows"

# PLUGINS

tmux set-option -g status-right ""

time=$(pill $blue $diff_blue "󰃭" "%a %-e %b %-l:%M %p")
tmux set-option -ga status-right " $time"

battery=$(pill $bg_red $diff_red "#($current_dir/battery_status.sh)" "#($current_dir/battery_level.sh)")
tmux set-option -ga status-right " $battery"
