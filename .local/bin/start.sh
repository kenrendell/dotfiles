#!/bin/sh
# Start programs

# Usage: start.sh [exit]
{ [ "$#" -eq 0 ] || { [ "$#" -eq 1 ] && [ "$1" = 'exit' ]; }; } || \
	{ printf 'Usage: start.sh [exit]\n' 1>&2; exit 1; }

get_pid() {
	# Substitution patterns for 'sed'
	s="s/^[[:space:]]*([0-9]+)[[:space:]]+${XDG_SESSION_ID}[[:space:]]+"
	e='[[:space:]]*$/\1/p'

	# Get the PID with respect to 'XDG_SESSION_ID' variable
	ps -N -o 'pid,lsession,comm' --ppid=$$ | sed -E -n "${s}${1}${e}" | xargs
}

terminate() {
	for name in "$@"; do pid_list="${pid_list} $(get_pid "$name")"; done
	[ -z "${pid_list##*[[:digit:]]*}" ] && env kill -TERM --timeout 10000 KILL ${pid_list}
}

spawn() { [ -n "$(get_pid "$1")" ] || "$@" & }

if [ "$#" -eq 1 ]; then
	statusbar.sh exit
	terminate fnott
	swaymsg exit
else
	update-colors.sh
	spawn fnott
	statusbar.sh
fi

