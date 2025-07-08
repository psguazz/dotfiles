#!/usr/bin/env bash

memory_pressure | awk '/System-wide memory free percentage/ {print $NF}'
