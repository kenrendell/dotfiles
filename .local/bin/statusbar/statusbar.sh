#!/bin/sh
# Statusbar script
#
# Usage 1: statusbar.sh               := Start/Restart statusbar
# Usage 2: statusbar.sh exit          := Exit statusbar
# Usage 3: statusbar.sh <mes> <pipe>  := Send message to statusbar modules through pipe.

# Runtime directory
runtime_dir="$XDG_RUNTIME_DIR/statusbar-modules-$XDG_SESSION_ID"

if [ "$#" -eq 2 ] && [ -d "$runtime_dir" ] && [ -p "$runtime_dir/$2" ]; then
    # Send message to pipe
    printf '%s\n' "$1" > "$runtime_dir/$2"
else
    # Validate arguments
    [ "$#" -eq 0 ] || { { [ "$#" -eq 1 ] && [ "$1" = 'exit' ]; } || exit 1; }

    # Terminate all statusbar custom modules.
    if [ -d "$runtime_dir" ]; then
        for pipe in "$runtime_dir"/*; do
            [ -p "$pipe" ] && printf 'exit\n' > "$pipe"
        done

        rm -rf "$runtime_dir"
    fi

    # Get the statusbar process on the current login session.
    regex="\s+[0-9]+\s+$XDG_SESSION_ID\s+waybar"
    ps="$(ps -e -o 'pid,lsession,comm' | grep -E "$regex")"

    if [ -n "$ps" ]; then
        # Extract the process ID
        pid="$(printf '%s' "$ps" | awk '{ print $1 }' | tr '\n' ' ' | sed 's/[[:space:]]*$//')"

        # Terminate statusbar
        kill $pid 2>/dev/null

        # If the statusbar process is still exists after 10 seconds, kill it with 'SIGKILL'.
        timeout 10 sh -c \
            "while ps -p '$pid' >/dev/null; do sleep 0.5; done" || \
                kill -KILL $pid 2>/dev/null
    fi

    # 'exit' is the only allowed argument when the passed arguments is equal to 1.
    [ "$#" -eq 1 ] && exit 0

    # Execute statusbar
    mkdir -m 700 "$runtime_dir"
    exec waybar
fi
