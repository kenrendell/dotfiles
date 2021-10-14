#!/bin/sh
# CPU module for statusbar
# NOTE: Only one process (per session) of this script is allowed!

mode=0
batn="${1:-0}"
runtime_dir="$XDG_RUNTIME_DIR/statusbar-modules-$XDG_SESSION_ID"
pipe="$runtime_dir/BAT${batn}-pipe"
cmd_dir="${0%/*}/bin"

[ -p "$pipe" ] && { printf 'This program is already running!\n' 1>&2; exit 1; }

[ -d "$runtime_dir" ] || mkdir -m 700 "$runtime_dir"
mkfifo -m 600 "$pipe"

_exit() { printf 'exit' > "$pipe"; }
trap _exit INT TERM

while true; do
	if [ "$mode" -eq 1 ]; then
		"$cmd_dir/bat_status.py" "$batn" & pid=$!
	else
		"$cmd_dir/bat_status.py" "$batn" --design & pid=$!
	fi

	read -r mes < "$pipe"
	kill -TERM $pid 2>/dev/null

	case "$mes" in
		toggle) mode="$(((mode + 1) % 2))" ;;
		exit) rm -f "$pipe"; break ;;
	esac
done & wait
