#!/bin/sh
# Statusbar script
# Usage: statusbar.sh [exit|<command> <pipe-name>]

# Match the usage restrictions
{ [ "$#" -le 2 ] && { [ "$#" -ne 1 ] || [ "$1" = 'exit' ]; }; } || \
	{ printf 'Usage: statusbar.sh [exit|<command> <pipe-name>]\n' 1>&2; exit 1; }

# Runtime directory
runtime_dir="$XDG_RUNTIME_DIR/statusbar-modules-$XDG_SESSION_ID"

if [ "$#" -eq 2 ]; then
	# Send the command to pipe
	[ -d "$runtime_dir" ] && [ -p "$runtime_dir/$2" ] && \
		printf '%s' "$1" > "$runtime_dir/$2"
else
	# Get the list of processes
	ps_output="$(ps -eo 'pid,lsession,comm')"

	# Substitution patterns for 'sed'
	s="s/^[[:space:]]*([0-9]+)[[:space:]]+${XDG_SESSION_ID}[[:space:]]+"
	e='[[:space:]]*$/\1/p'

	# Prevent the multiple execution of this script.
	[ "$(printf '%s\n' "$ps_output" | sed -E -n "${s}statusbar\.sh${e}")" = "$$" ] || exit 1

	# Terminate all statusbar custom modules.
	if [ -d "$runtime_dir" ]; then
		for pipe in "$runtime_dir"/*; do
			[ -p "$pipe" ] && printf 'exit' > "$pipe"
		done

		rm -rf "$runtime_dir"
	fi

	# Get the pid of statusbar
	pid="$(printf '%s\n' "$ps_output" | sed -E -n "${s}waybar${e}" | xargs)"

	# shellcheck disable=SC2086
	if [ -n "$pid" ]; then
		# Terminate statusbar
		kill $pid 2>/dev/null

		# Wait until the process is fully terminated.
		while ps -p "$pid" >/dev/null 2>&1; do sleep 1; done
	fi

	# Execute statusbar
	[ "$#" -eq 1 ] || { mkdir -m 700 "$runtime_dir"; exec waybar; }
fi
