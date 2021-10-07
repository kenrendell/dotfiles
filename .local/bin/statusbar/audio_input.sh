#!/bin/sh
# Audio input (microphone) module for statusbar
# NOTE: Only one process (per session) of this script is allowed!

script_name="${0##*/}"
runtime_dir="$XDG_RUNTIME_DIR/statusbar-modules-$XDG_SESSION_ID"
pipe="$runtime_dir/${script_name%.*}-pipe"

[ -p "$pipe" ] && { printf 'This program is already running!\n' 1>&2; exit 1; }

[ -d "$runtime_dir" ] || mkdir -m 700 "$runtime_dir"
mkfifo -m 600 "$pipe"

_exit() { printf 'exit\n' > "$pipe"; }
trap _exit INT TERM

( pactl subscribe | while read -r event; do
	[ -f "${pipe}.lock" ] && continue
	
	printf '%s\n' "$event" | grep -E -q "'(change|new|remove)' on source" && \
		{ [ -p "$pipe" ] && printf '\n' > "$pipe"; }
done ) & pid=$!

touch "${pipe}.lock"
while true; do
	while true; do
		volume="$(pactl get-source-volume @DEFAULT_SOURCE@ | \
			sed -E -n 's/^V.+\/[[:space:]]+([0-9]+)%.+$/\1/p')"
		mute="$(pactl get-source-mute @DEFAULT_SOURCE@ | cut -d ' ' -f 2)"

		[ -n "$volume" ] && [ -n "$mute" ] && break

		printf '{"text": "", "class": ""}\n'
		sleep 1
	done

	if [ "$mute" = 'yes' ]; then
		text=" $volume%"
		class='muted'
	elif [ "$volume" -gt 100 ]; then
		text=" $volume%"
		class='exceeded'
	else
		text=" $volume%"
		class=
	fi

	printf '{"text": "%s", "class": "%s"}\n' "$text" "$class"

	[ -f "${pipe}.lock" ] && { sleep 0.05; rm -f "${pipe}.lock"; }

	read -r mes < "$pipe"

	[ -n "$mes" ] && [ "$mes" != 'exit' ] && touch "${pipe}.lock"

	case $mes in
		mute) pactl set-source-mute @DEFAULT_SOURCE@ toggle ;;
		inc) pactl set-source-volume @DEFAULT_SOURCE@ +5% ;;
		dec) pactl set-source-volume @DEFAULT_SOURCE@ -5% ;;
		exit) pkill -P $pid; rm -f "$pipe"; break ;;
	esac
done & wait
