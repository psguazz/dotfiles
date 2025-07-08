#!/usr/bin/env bash

uptime | awk -F'load averages?: ' '{print $2}' | awk '{print $1}'
