#!/bin/sh
# Audio output (speaker) module for statusbar
# NOTE: Only one process (per session) of this script is allowed!

value=5
scontrol='Master'
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
		while true; do
			audio_info="$(amixer sget "$scontrol" | \
				sed --posix -nE 's/^.+\[([0-9]+)%\].+\[(on|off)\].*$/\1:\2/p' | tail -1)"

			[ -z "$audio_info" ] || break
			printf '{"text": "", "class": ""}\n'
			sleep 1
		done

		volume="$(printf '%s' "$audio_info" | cut -d ':' -f 1)"
		switch="$(printf '%s' "$audio_info" | cut -d ':' -f 2)"
		class=

		if [ "$switch" = 'off' ]; then
			text=" $volume%"
			class='muted'
		elif [ "$volume" -gt 100 ]; then
			text=" $volume%"
			class='exceeded'
		else text=" $volume%"; fi

		printf '{"text": "%s", "class": "%s"}\n' "$text" "$class"

		read -r mes < "$pipe"
		case $mes in
			mute) amixer -q sset "$scontrol" toggle;;
			inc) amixer -q sset "$scontrol" ${value}%+;;
			dec) amixer -q sset "$scontrol" ${value}%-;;
			exit) rm -f "$pipe"; exit;;
		esac
	done
} & wait
