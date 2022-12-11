#!/bin/sh
# Select and capture the screen
# Dependencies: grim, slurp, swappy, imagemagick, xdg-user-dirs
#
# Usage: screenshot.sh [--edit|--all|--all-edit|--pixel]

slurp_opts='-b 00000077 -c 00000099 -s 00000022 -w 2'

fail() { printf 'Usage: screenshot.sh [--edit|--all|--all-edit|--pixel]\n' 1>&2; exit 1; }

output_file() { printf '%s' "$XDG_PICTURES_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"; }

[ "$#" -ge 2 ] && fail

case "$1" in
	'') region="$(slurp $slurp_opts)"
		[ -z "$region" ] || grim -g "$region" -t png -l 6 "$(output_file)" ;;
	'--edit') region="$(slurp $slurp_opts)"
		[ -z "$region" ] || grim -g "$region" -t png -l 6 - | swappy -f - ;;
	'--all') grim -t png -l 6 "$(output_file)" ;;
	'--all-edit') grim -t png -l 6 - | swappy -f - ;;
	'--pixel') region="$(slurp $slurp_opts -p)"
		[ -z "$region" ] || grim -g "$region" -t ppm - | \
			magick - -format '%[hex:p{0,0}]' info:- | wl-copy ;;
	*) fail ;;
esac
