#!/bin/sh
# Audio input (microphone) module for statusbar
# Dependencies: pipewire, pipewire-pulse
# NOTE: Only one process (per session) of this script is allowed!

ps -e -o comm | grep -q '^pipewire$' || \
	{ printf "'pipewire' is not running!\n" 1>&2; exit 1; }

script_name="${0##*/}"
runtime_dir="$XDG_RUNTIME_DIR/statusbar-modules-$XDG_SESSION_ID"
pipe="$runtime_dir/${script_name%.*}-pipe"
pipe_lock="${pipe}.lock"

[ -p "$pipe" ] && { printf 'This program is already running!\n' 1>&2; exit 1; }

[ -d "$runtime_dir" ] || mkdir -m 700 "$runtime_dir"
mkfifo -m 600 "$pipe"

_exit() { printf 'exit' > "$pipe"; }
trap _exit INT TERM

( pactl subscribe | while read -r event; do
	! [ -f "$pipe_lock" ] && { \
		[ -z "${event##*\'change\' on source*}" ] || \
		[ -z "${event##*\'remove\' on source*}" ] || \
		[ -z "${event##*\'new\' on source*}" ]; } && \
		{ [ -p "$pipe" ] && printf '' > "$pipe"; }
done ) & pid=$!

touch "$pipe_lock"
while true; do
	volume="$(pactl get-source-volume @DEFAULT_SOURCE@)" || { sleep 1; continue; }
	volume="${volume%%\%*}"; volume="${volume##*[[:space:]]}"
	mute="$(pactl get-source-mute @DEFAULT_SOURCE@)" || { sleep 1; continue; }

	if [ "${mute##*[[:space:]]}" = 'yes' ]; then
		text=" $volume%"; class='muted'
	elif [ "$volume" -gt 100 ]; then
		text=" $volume%"; class='exceeded'
	else text=" $volume%"; class=''; fi

	printf '{"text": "%s", "class": "%s"}\n' "$text" "$class"

	rm -f "$pipe_lock"
	while true; do read -r mes < "$pipe"
		case "$mes" in '') break ;;
			mute) touch "$pipe_lock"
				pactl set-source-mute @DEFAULT_SOURCE@ toggle; break ;;
			inc) touch "$pipe_lock"
				pactl set-source-volume @DEFAULT_SOURCE@ '+5%'; break ;;
			dec) touch "$pipe_lock"
				pactl set-source-volume @DEFAULT_SOURCE@ '-5%'; break ;;
			exit) ps -o pid= --ppid=$pid | xargs kill 2>/dev/null
				rm -f "$pipe"; break ;;
		esac
	done; [ "$mes" = 'exit' ] && break
done & wait
