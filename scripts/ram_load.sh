#!/usr/bin/env bash

free_pct=$(sysctl -n kern.memorystatus_level)
pressure=$((100 - free_pct))

printf "%2s%%" "$pressure"
