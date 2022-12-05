#!/bin/sh
# MPD module for statusbar
# Dependencies: mpd, mpc
# NOTE: Only one process (per session) of this script is allowed!

ps -e -o comm | grep -q '^mpd$' || \
	{ printf "'mpd' is not running!\n" 1>&2; exit 1; }

script_name="${0##*/}"
runtime_dir="$XDG_RUNTIME_DIR/statusbar-modules-$XDG_SESSION_ID"
pipe="$runtime_dir/${script_name%.*}-pipe"
pipe_lock="${pipe}.lock"

[ -p "$pipe" ] && { printf 'This program is already running!\n' 1>&2; exit 1; }

[ -d "$runtime_dir" ] || mkdir -m 700 "$runtime_dir"
mkfifo -m 600 "$pipe"

_exit() { printf 'exit' > "$pipe"; }
trap _exit INT TERM

( mpc idleloop player options mixer | while read -r _; do
	! [ -f "$pipe_lock" ] && { [ -p "$pipe" ] && printf '' > "$pipe"; }
done ) & pid=$!

touch "$pipe_lock"
while true; do
	eval "$(mpc status "state='%state%'; volume='%volume%'; random='%random%'
		repeat='%repeat%'; single='%single%'; consume='%consume%'")"

	volume="${volume##*-*}"
	random="${random#on}z"; repeat="${repeat#on}r"
	single="${single#on}s"; consume="${consume#on}c"
	options=" (${random#off?}${repeat#off?}${single#off?}${consume#off?})"
	{ [ "$state" = 'paused' ] && icon=''; } || icon=''
	[ -z "$volume" ] && state='no-output'

	printf '{"text": "%s %s%s", "class": "%s"}\n' \
		"$icon" ${volume:-none} "${options# ()}" "$state"

	rm -f "$pipe_lock"
	while true; do read -r mes < "$pipe"
		case "$mes" in '') break ;;
			stop) touch "$pipe_lock"; mpc --quiet stop; break ;;
			play-pause) touch "$pipe_lock"; mpc --quiet toggle; break ;;
			inc) touch "$pipe_lock"; mpc --quiet volume '+2'; break ;;
			dec) touch "$pipe_lock"; mpc --quiet volume '-2'; break ;;
			exit) ps -o pid= --ppid=$pid | xargs kill 2>/dev/null
				rm -f "$pipe"; break ;;
		esac
	done; [ "$mes" = 'exit' ] && break
done & wait
