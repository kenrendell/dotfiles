#!/bin/sh

value=5
scontrol='Capture'
script_name="${0##*/}"
pipe="$XDG_RUNTIME_DIR/bar-${script_name%.*}-pipe"
mkfifo -m 600 "$pipe"

while true; do
	audio_info="$(amixer sget "$scontrol" | tail -1)"
	volume="$(printf '%s' "$audio_info" | grep -oE '[0-9]+%' | tr -d '%')"

	if printf '%s' "$audio_info" | grep -q '\[off\]'; then
		output="<span fgcolor=\"#E79D78\"> $volume%</span>"
	elif [ "$volume" -gt 100 ]; then
		output="<span fgcolor=\"#DC657D\"> $volume%</span>"
	else output=" $volume%"; fi;

	printf '%s\n' "$output"

	read -r mes < "$pipe"
	case $mes in
		mute) amixer -q sset "$scontrol" toggle;;
		inc) amixer -q sset "$scontrol" ${value}%+;;
		dec) amixer -q sset "$scontrol" ${value}%-;;
        exit) rm -f "$pipe"; exit;;
	esac
done
