#!/bin/sh
# Backlight module for statusbar
# Dependencies: brightnessctl
# NOTE: Only one process (per session) of this script is allowed!

step=5
sysfs_backlight_file="/sys/class/backlight/${BACKLIGHT_DEVICE}/actual_brightness"

[ -f "$sysfs_backlight_file" ] || \
	{ printf "Invalid backlight device!\n" 1>&2; exit 1; }

script_name="${0##*/}"
runtime_dir="$XDG_RUNTIME_DIR/statusbar-modules-$XDG_SESSION_ID"
pipe="$runtime_dir/${script_name%.*}-pipe"
pipe_lock="${pipe}.lock"

[ -p "$pipe" ] && { printf 'This program is already running!\n' 1>&2; exit 1; }

[ -d "$runtime_dir" ] || mkdir -m 700 "$runtime_dir"
mkfifo -m 600 "$pipe"

_exit() { printf 'exit' > "$pipe"; }
trap _exit INT TERM

( inotifywait --quiet --monitor --event modify --format '' "$sysfs_backlight_file" | while read -r _; do
	! [ -f "$pipe_lock" ] && { [ -p "$pipe" ] && printf '' > "$pipe"; }
done ) & pid=$!

touch "$pipe_lock"
while true; do
	brightness="$(brightnessctl -mq --device="$BACKLIGHT_DEVICE" info | cut -d ',' -f 4)"
	text=" $(printf '%.f' "${brightness%'%'}")%"
	printf '{"text": "%s"}\n' "$text"

	rm -f "$pipe_lock"
	while true; do read -r mes < "$pipe"
		case "$mes" in '') break ;;
			inc) touch "$pipe_lock"
				brightnessctl -mq --device="$BACKLIGHT_DEVICE" set "+${step}%"; break ;;
			dec) touch "$pipe_lock"
				brightness="$(brightnessctl -mq --device="$BACKLIGHT_DEVICE" info | cut -d ',' -f 4)"
				if [ "${brightness%'%'}" -gt "$step" ]; then
					brightnessctl -mq --device="$BACKLIGHT_DEVICE" set "${step}%-"
				else brightnessctl -mq --device="$BACKLIGHT_DEVICE" set '1%'; fi
				break ;;
			exit) ps -o pid= --ppid=$pid | xargs kill 2>/dev/null
				rm -f "$pipe"; break ;;
		esac
	done; [ "$mes" = 'exit' ] && break
done & wait
