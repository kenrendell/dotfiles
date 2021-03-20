#!/bin/sh

port1='analog-output-speaker'
port2='analog-output-headphones'
inc=5; dec=5
signal="$XDG_RUNTIME_DIR/$$-signal"
label1='IAO' # Internal audio output
label2='EAO' # External audio output

list_sink_info () { pactl list sinks | sed "s/^$/\\&/g" | cut -z -d '&' -f "$((SINK + 1))"; }
trap "printf ''" USR1

while true; do
	if [ -f "$signal" ]; then case "$(cat "$signal")" in
		1) pactl set-sink-mute "$SINK" toggle ;;
		3)
			port="$(list_sink_info | grep -a "Active Port" | cut -d ' ' -f 3)"

			case "$port" in
				"$port1") pactl set-sink-port "$SINK" "$port2" ;;
				"$port2") pactl set-sink-port "$SINK" "$port1" ;;
			esac
			;;
		4) pactl set-sink-volume "$SINK" +"$inc"% ;;
		5) pactl set-sink-volume "$SINK" -"$dec"% ;;
	esac; rm "$signal"; fi

	audio_out_info="$(list_sink_info)"
	port="$(printf '%s' "$audio_out_info" | grep -a "Active Port" | cut -d ' ' -f 3)"
	mute="$(printf '%s' "$audio_out_info" | grep -a "Mute" | cut -d ' ' -f 2)"
	volume="$(printf '%s' "$audio_out_info" | grep -a "Volume: front-left" | cut -d '/' -f 2 | tr -d ' %')"

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
