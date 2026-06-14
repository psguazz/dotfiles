#!/usr/bin/env bash

ncpu=$(sysctl -n hw.ncpu)
load=$(sysctl -n vm.loadavg | awk '{print $2}')
usage=$(awk -v load="$load" -v ncpu="$ncpu" 'BEGIN { u = (load / ncpu) * 100; if (u > 100) u = 100; printf "%.0f", u }')

printf "%2s%%" "$usage"
