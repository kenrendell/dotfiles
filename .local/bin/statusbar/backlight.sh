#!/bin/sh
# Backlight module for statusbar
# Dependencies: light
# NOTE: Only one process (per session) of this script is allowed!

script_name="${0##*/}"
runtime_dir="$XDG_RUNTIME_DIR/statusbar-modules-$XDG_SESSION_ID"
pipe="$runtime_dir/${script_name%.*}-pipe"

[ -p "$pipe" ] && { printf 'This program is already running!\n' 1>&2; exit 1; }

[ -d "$runtime_dir" ] || mkdir -m 700 "$runtime_dir"
mkfifo -m 600 "$pipe"

_exit() { printf 'exit' > "$pipe"; }
trap _exit INT TERM

while true; do
	text=" $(printf '%.f' "$(light)")%"
	printf '{"text": "%s"}\n' "$text"

	while true; do read -r mes < "$pipe"
		case "$mes" in
			inc) light -A 5; break ;;
			dec) light -U 5; break ;;
			exit) rm -f "$pipe"; break ;;
		esac
	done; [ "$mes" = 'exit' ] && break
done & wait
