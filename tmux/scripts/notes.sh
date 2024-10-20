#!/usr/bin/env bash

cd ~/vaults/

nvim

message=$(date +"%Y-%m-%d %H:%M")
tmux new-session -d -c $(pwd) "git add .; git commit -m '$message'; git push origin main --force-with-lease"

