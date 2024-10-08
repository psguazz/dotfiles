#!/usr/bin/env bash

cd ~/vaults/

nvim +"Telescope git_files find_command=git,ls-files,*.md"

MESSAGE=$(date +"%Y-%m-%d %H:%M")
tmux new-session -d -c $(pwd) "git add .; git commit -m '$MESSAGE'; git push origin main --force-with-lease"

