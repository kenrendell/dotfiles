#!/bin/sh

label='NF' # Notification

toggle() { dunstctl set-paused toggle; printf ''; }
trap "toggle" USR1

while true; do
	if [ "$(dunstctl is-paused)" = 'false' ]; then output="$label 1"
	else output="%{F$YELLOW_1}$label 0%{F-}"; fi

	printf '%s\n' "%{A1:kill -USR1 $$:}$output%{A}"
	read -r REPLY
done
