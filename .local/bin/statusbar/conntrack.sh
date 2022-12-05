#!/bin/sh
# Memory module for statusbar
# NOTE: Only one process (per session) of this script is allowed!

mode=0
script_name="${0##*/}"
runtime_dir="$XDG_RUNTIME_DIR/statusbar-modules-$XDG_SESSION_ID"
pipe="$runtime_dir/${script_name%.*}-pipe"
cmd_dir="${0%/*}/bin"

[ -p "$pipe" ] && { printf 'This program is already running!\n' 1>&2; exit 1; }

[ -d "$runtime_dir" ] || mkdir -m 700 "$runtime_dir"
mkfifo -m 600 "$pipe"

_exit() { printf 'exit' > "$pipe"; }
trap _exit INT TERM

while true; do
	if [ "$mode" -eq 1 ]; then
		"$cmd_dir/conntrack-usage.lua" --expand & pid=$!
	else
		"$cmd_dir/conntrack-usage.lua" & pid=$!
	fi

	while true; do read -r mes < "$pipe"
		case "$mes" in
			toggle) mode="$(((mode + 1) % 2))"; break ;;
			exit) rm -f "$pipe"; break ;;
		esac
	done; kill -TERM $pid 2>/dev/null
	[ "$mes" = 'exit' ] && break
done & wait
