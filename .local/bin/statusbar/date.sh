#!/bin/sh
# Date module for statusbar
# NOTE: Only one process (per session) of this script is allowed!

script_name="${0##*/}"
runtime_dir="$XDG_RUNTIME_DIR/statusbar-modules-$XDG_SESSION_ID"
pipe="$runtime_dir/${script_name%.*}-pipe"

if [ -p "$pipe" ]; then
	printf 'This program is already running!\n' 1>&2
	exit 1
fi

[ -d "$runtime_dir" ] || mkdir -m 700 "$runtime_dir"
mkfifo -m 600 "$pipe"

_exit() { printf 'exit\n' > "$pipe"; }
trap _exit INT TERM

{
	sleep_pid=
	mode=0

	toggle() { mode="$(((mode + 1) % 2))"; }
	_stop() { kill $sleep_pid 2>/dev/null; exit; }

	trap toggle USR1
	trap _stop USR2

	while true; do
		H=0h; M=0m; S=0s
		if [ "$mode" -eq 0 ]; then
			S="$((60 - $(date +%-S)))s"
			text=" $(date +%R)"
		else
			H="$((23 - $(date +%-H)))h"
			M="$((59 - $(date +%-M)))m"
			S="$((60 - $(date +%-S)))s"
			text=" $(date +'%a %F')"
		fi

		printf '{"text": "%s"}\n' "$text"
		sleep $H $M $S & sleep_pid=$!; wait
		kill $sleep_pid 2>/dev/null
	done
} & pid=$!

{
	while true; do
		read -r mes < "$pipe"
		case $mes in
			toggle) kill -USR1 $pid;;
			exit) rm -f "$pipe"; kill -USR2 $pid; exit;;
		esac
	done
} & wait
