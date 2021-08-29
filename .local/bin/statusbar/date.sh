#!/bin/sh

{
	sleep_pid=
	mode=0

	toggle() { mode="$(((mode + 1) % 2))"; }
	end() { ps -p "$sleep_pid" >/dev/null && kill "$sleep_pid"; exit; }

	trap toggle USR1
	trap end USR2

	while true; do
		H=0h; M=0m; S=0s
		if [ "$mode" -eq 0 ]; then
			S="$((60 - $(date +%-S)))s"
			output=" $(date +%R)"
		else
			H="$((23 - $(date +%-H)))h"
			M="$((59 - $(date +%-M)))m"
			S="$((60 - $(date +%-S)))s"
			output=" $(date +'%a %F')"
		fi

		printf '%s\n' "$output"
		sleep $H $M $S & sleep_pid=$!; wait
		ps -p $sleep_pid >/dev/null && kill $sleep_pid
	done
} &

pid=$!
script_name="${0##*/}"
pipe="$XDG_RUNTIME_DIR/bar-${script_name%.*}-pipe"
mkfifo -m 600 "$pipe"

while true; do
	read -r mes < "$pipe"
	case $mes in
		toggle) kill -USR1 $pid;;
		exit) rm -f "$pipe"; kill -USR2 $pid; exit;;
	esac
done
