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

    # Get the statusbar process id on the current login session.
    pattern="s/^[[:space:]]*([0-9]+)[[:space:]]+${XDG_SESSION_ID}[[:space:]]+waybar/\1/p"
    pid="$(ps -eo 'pid,lsession,comm' | sed --posix -nE "$pattern")"

    if [ -n "$pid" ]; then
        # Terminate statusbar
        printf '%s' "$pid" | xargs kill >/dev/null 2>&1

        # If the statusbar process is still exists after 10 seconds, kill it with 'SIGKILL'.
        timeout 10 sh -c \
            "while printf '$pid' | xargs ps -p >/dev/null 2>&1; do sleep 1; done" || \
                printf '%s' "$pid" | xargs kill -KILL >/dev/null 2>&1
    fi

    # 'exit' is the only allowed argument when the passed arguments is equal to 1.
    [ "$#" -eq 1 ] && exit 0

    # Execute statusbar
    mkdir -m 700 "$runtime_dir"
    exec waybar
fi
