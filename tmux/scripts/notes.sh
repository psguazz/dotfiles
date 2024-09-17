#!/usr/bin/env bash

cd ~/vaults/

nvim +ObsidianToday

git add .
git commit -m "$(date +"%Y-%m-%d %H:%M")"
git push origin main --force-with-lease

