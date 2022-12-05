#!/bin/sh
# Select and capture the screen
# Dependencies: grim, slurp, swappy, imagemagick, xdg-user-dirs
#
# Usage: screenshot.sh [--all|--pixel]

[ "$#" -eq 0 ] || { [ "$#" -eq 1 ] && \
	{ [ "$1" = '--all' ] || [ "$1" = '--pixel' ]; }; } || \
	{ printf 'Usage: screenshot.sh [--all|--pixel]\n' 1>&2; exit 1; }

directory="$(xdg-user-dir PICTURES)"
slurp_opts='-b 00000077 -c 00000099 -s 00000022 -w 2'
mkdir -p "$directory"

case "$1" in
	'') region="$(slurp $slurp_opts)"
		[ -z "$region" ] || grim -g "$region" -t png -l 6 - | swappy -f - ;;
	'--all') grim -t png -l 6 - | swappy -f - ;;
	'--pixel') region="$(slurp $slurp_opts -p)"
		[ -z "$region" ] || grim -g "$region" -t ppm - | \
			magick - -format '%[hex:p{0,0}]' info:- | wl-copy ;;
esac
