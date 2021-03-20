#!/bin/sh

port1='analog-input-internal-mic'
port2='analog-input-mic'
inc=5; dec=5
signal="$XDG_RUNTIME_DIR/$$-signal"
label1='IAI' # Internal audio input
label2='EAI' # External audio input

list_source_info () { pactl list sources | sed "s/^$/\\&/g" | cut -z -d '&' -f "$((SOURCE + 1))"; }
trap "printf ''" USR1

while true; do
	if [ -f "$signal" ]; then case "$(cat "$signal")" in
		1) pactl set-source-mute "$SOURCE" toggle ;;
		3)
			port="$(list_source_info | grep -a "Active Port" | cut -d ' ' -f 3)"

			case "$port" in
				"$port1") pactl set-source-port "$SOURCE" "$port2" ;;
				"$port2") pactl set-source-port "$SOURCE" "$port1" ;;
			esac
			;;
		4) pactl set-source-volume "$SOURCE" +"$inc"% ;;
		5) pactl set-source-volume "$SOURCE" -"$dec"% ;;
	esac; rm "$signal"; fi

	audio_in_info="$(list_source_info)"
	port="$(printf '%s' "$audio_in_info" | grep -a "Active Port" | cut -d ' ' -f 3)"
	mute="$(printf '%s' "$audio_in_info" | grep -a "Mute" | cut -d ' ' -f 2)"
	volume="$(printf '%s' "$audio_in_info" | grep -a "Volume: front-left" | cut -d '/' -f 2 | tr -d ' %')"

	case "$port" in
		"$port1")
			if [ "$mute" = 'yes' ]; then output="%{F$YELLOW_1}$label1 0 $volume%%{F-}"
			elif [ "$volume" -gt 100 ]; then output="%{F$RED_0}$label1 1 $volume%%{F-}"
			else output="$label1 1 $volume%"; fi ;;
		"$port2")
			if [ "$mute" = 'yes' ]; then output="%{F$YELLOW_1}$label2 0 $volume%%{F-}"
			elif [ "$volume" -gt 100 ]; then output="%{F$RED_0}$label2 1 $volume%%{F-}"
			else output="$label2 1 $volume%"; fi ;;
	esac

	cmd="kill -USR1 $$"
	printf '%s\n' "%{A1:printf 1 > $signal; $cmd:}%{A3:printf 3 > $signal; $cmd:}%{A4:printf 4 > $signal; $cmd:}%{A5:printf 5 > $signal; $cmd:}$output%{A A A A}"
	read -r REPLY
done
