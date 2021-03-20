#!/bin/sh

method="${1:-randr}"
temp_min=1000
temp_max=6500
increment=5
decrement=5
redshift_temp="$XDG_DATA_HOME/redshift-temp"
signal="$XDG_RUNTIME_DIR/$$-signal"
active='false'
temp_mode='false'
label='BF' # Backlight filter

calc_perc_temp () { calc.sh "$1 + (100 - $3) * ($2 - $1) / 100"; }
calc_temp_perc () { calc.sh "100 - (($(cat "$3") - $1) * 100 / ($2 - $1))"; }

# Uncomment if the temperature adjustment does not working properly
#if systemctl is-active -q --user redshift.service; then
	#systemctl stop -q --user redshift.service
	#systemctl disable -q --user redshift.service
	#systemctl mask -q --user redshift.service
#fi

[ ! -f "$redshift_temp" ] && printf '%s' "$temp_max" > "$redshift_temp"
redshift -x -m "$method"
trap "printf ''" USR1

while true; do
	temp_perc="$(calc_temp_perc "$temp_min" "$temp_max" "$redshift_temp")"
	temp="$(calc_perc_temp "$temp_min" "$temp_max" "$temp_perc")"
	inc="$increment"
	dec="$decrement"

	if [ -f "$signal" ]; then case "$(cat "$signal")" in
		1)
			if "$active"; then redshift -x -m "$method"; active='false'
			else redshift -P -O "$temp" -m "$method"; active='true'; fi
			printf ''
			;;
		3)
			if "$temp_mode"; then temp_mode='false'; else temp_mode='true'; fi
			printf ''
			;;
		4)
			new_inc="$((100 - temp_perc))"
			[ "$new_inc" -lt "$inc" ] && inc="$new_inc"

			temp="$(calc_perc_temp "$temp_min" "$temp_max" "$((temp_perc + inc))")"
			printf '%s' "$temp" > "$redshift_temp"
			temp_perc="$(calc_temp_perc "$temp_min" "$temp_max" "$redshift_temp")"

			"$active" && redshift -P -O "$temp" -m "$method"
			printf ''
			;;
		5)
			[ "$temp_perc" -lt "$dec" ] && dec="$temp_perc"

			temp="$(calc_perc_temp "$temp_min" "$temp_max" "$((temp_perc - dec))")"
			printf '%s' "$temp" > "$redshift_temp"
			temp_perc="$(calc_temp_perc "$temp_min" "$temp_max" "$redshift_temp")"

			"$active" && redshift -P -O "$temp" -m "$method"
			printf ''
			;;
	esac; rm "$signal"; fi

	if "$temp_mode"; then value="${temp}K"; else value="$temp_perc%"; fi
	if "$active"; then output="%{F$BLUE_0}$label 1 $value%{F-}"
	else output="$label 0 $value"; fi

	cmd="kill -USR1 $$"
	printf '%s\n' "%{A1:printf 1 > $signal; $cmd:}%{A3:printf 3 > $signal; $cmd:}%{A4:printf 4 > $signal; $cmd:}%{A5:printf 5 > $signal; $cmd:}$output%{A A A A}"
	read -r REPLY
done
