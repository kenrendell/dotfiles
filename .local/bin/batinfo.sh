#!/bin/sh
# Show battery status and other information
# Usage: batinfo.sh

[ "$#" -eq 0 ] || return 1

bat_path="$(upower --enumerate | grep -E 'battery_BAT[0-9]+$' | tr '\n' ' ')"
[ -n "$bat_path" ] || return 1

for battery in $bat_path; do
    upower --show-info "$battery"
done
