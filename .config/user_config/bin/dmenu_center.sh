#!/bin/sh

width="$1"
lines="$2"

lineheight="$((BAR_HEIGHT + 2 * BORDER))"
height="$(((lines + 1) * lineheight))"
dimension="$(xrandr | grep -F '*' | awk '{ print $1 }')"
mon_width="$(printf '%s' "$dimension" | cut -d 'x' -f 1)"
mon_height="$(printf '%s' "$dimension" | cut -d 'x' -f 2)"

x="$(calc.sh "( $mon_width - $width ) / 2 + $BORDER")"
y="$(calc.sh "( $mon_height - $height ) / 2 + $BORDER")"

printf '%s' "-x $x -y $y -z $width -l $lines -bw $BORDER -h $lineheight"
