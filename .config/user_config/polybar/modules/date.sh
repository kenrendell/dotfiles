#!/bin/sh

label='DT' # Date & time

mode=0
toggle() { mode="$(((mode + 1) % 2))"; }
trap "toggle" USR1

while true; do
	if [ "$mode" -eq 0 ]; then
		interval="$((60 - $(date +%-S)))s"; output="$label $(date +%R)"
	else
		interval="$((24 - $(date +%-H)))h"
		output="$label $(date +'%a %F')"
	fi

	printf '%s\n' "%{A1:kill -USR1 $$:}$output%{A}"
	sleep "$interval" & pid="$!"; wait
	ps -p "$pid" > /dev/null && kill "$pid"
done
