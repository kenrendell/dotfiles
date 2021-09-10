#!/bin/sh
# Backlight module for statusbar
# NOTE: Only one process (per session) of this script is allowed!

value=5
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
    while true; do
        text=" $(printf '%.f' "$(light)")%"
        printf '{"text": "%s"}\n' "$text"

        read -r mes < "$pipe"
        case $mes in
            inc) light -A "$value";;
            dec) light -U "$value";;
            exit) rm -f "$pipe"; exit;;
        esac
    done
} & wait
