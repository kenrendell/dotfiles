#!/bin/sh
# Audio output (speaker) module for statusbar
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
	
	printf '%s\n' "$event" | grep -E -q "'(change|new|remove)' on sink" && \
		{ [ -p "$pipe" ] && printf '\n' > "$pipe"; }
done ) & pid=$!

touch "${pipe}.lock"
while true; do
	while true; do
		volume="$(pactl get-sink-volume @DEFAULT_SINK@ | \
			sed -E -n 's/^V.+\/[[:space:]]+([0-9]+)%.+$/\1/p')"
		mute="$(pactl get-sink-mute @DEFAULT_SINK@ | cut -d ' ' -f 2)"

		[ -n "$volume" ] && [ -n "$mute" ] && break

		printf '{"text": "", "class": ""}\n'
		sleep 1
	done

	if [ "$mute" = 'yes' ]; then
		text=" $volume%"
		class='muted'
	elif [ "$volume" -gt 100 ]; then
		text=" $volume%"
		class='exceeded'
	else
		text=" $volume%"
		class=
	fi

	printf '{"text": "%s", "class": "%s"}\n' "$text" "$class"

	[ -f "${pipe}.lock" ] && { sleep 0.05; rm -f "${pipe}.lock"; }

	read -r mes < "$pipe"

	[ -n "$mes" ] && [ "$mes" != 'exit' ] && touch "${pipe}.lock"

	case $mes in
		mute) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
		inc) pactl set-sink-volume @DEFAULT_SINK@ +5% ;;
		dec) pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
		exit) pkill -P $pid; rm -f "$pipe"; break ;;
	esac
done & wait
