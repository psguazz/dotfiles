#!/usr/bin/env bash

cd ~/vaults/

nvim +"Telescope find_files search_dirs=.,glob_pattern=*.md"

git add .
git commit -m "$(date +"%Y-%m-%d %H:%M")"
git push origin main --force-with-lease

