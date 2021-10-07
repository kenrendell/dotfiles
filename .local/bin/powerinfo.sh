#!/bin/sh
# Show info about power sources
# Usage: powerinfo.sh

[ "$#" -eq 0 ] || { printf 'Usage: powerinfo.sh\n' 1>&2; exit 1; }

for device in $(upower --enumerate | xargs); do
	upower --show-info "$device"
done
