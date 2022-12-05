#!/bin/sh
# Statusbar script
# Usage: statusbar.sh [exit|<command> <pipe-name>]

# Match the usage restrictions
{ [ "$#" -le 2 ] && { [ "$#" -ne 1 ] || [ "$1" = 'exit' ]; }; } || \
	{ printf 'Usage: statusbar.sh [exit|<command> <pipe-name>]\n' 1>&2; exit 1; }

# Runtime directory
runtime_dir="$XDG_RUNTIME_DIR/statusbar-modules-$XDG_SESSION_ID"

get_pid() {
	# Substitution patterns for 'sed'
	s="s/^[[:space:]]*([0-9]+)[[:space:]]+${XDG_SESSION_ID}[[:space:]]+"
	e='[[:space:]]*$/\1/p'

	# Get the PID with respect to 'XDG_SESSION_ID' variable
	ps -N -o 'pid,lsession,comm' --ppid=$$ | sed -E -n "${s}${1}${e}" | xargs
}

if [ "$#" -eq 2 ]; then
	# Send the command to pipe
	[ -d "$runtime_dir" ] && [ -p "$runtime_dir/$2" ] && \
		printf '%s' "$1" > "$runtime_dir/$2"
else
	# Prevent the multiple execution of this script.
	[ "$(get_pid statusbar.sh)" = "$$" ] || \
		{ printf 'This program is already running!\n' 1>&2; exit 1; }

	# Terminate all statusbar custom modules.
	if [ -d "$runtime_dir" ]; then
		for pipe in "$runtime_dir"/*; do
			[ -p "$pipe" ] && printf 'exit' > "$pipe"
		done; rm -rf "$runtime_dir"
	fi

	# Kill the statusbar
	pid="$(get_pid waybar | xargs)"
	[ -n "$pid" ] && env kill -TERM --timeout 10000 KILL ${pid}

	# Execute statusbar
	[ "$#" -eq 1 ] || { mkdir -m 700 "$runtime_dir"; exec waybar; }
fi
