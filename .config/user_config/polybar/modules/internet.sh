#!/bin/sh

interval=10
label='NET' # Network

while true; do
	if ping -c 1 8.8.8.8 >/dev/null 2>&1; then output="%{F$BLUE_0}$label 1%{F-}"
	else output="$label 0"; fi

	printf '%s\n' "$output"
	sleep "$interval"
done
