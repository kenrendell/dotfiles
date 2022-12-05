#!/bin/sh
# Get the weather forecast
# Usage: weather.sh [LOCATION]

if [ -n "$1" ]; then
	location="$(urlencode.lua "$1")"
	[ "${location#*/}" = "$location" ] || \
		{ printf 'Invalid location!\n' 1>&2; exit 1; }
fi; curl "https://wttr.in/$location"
