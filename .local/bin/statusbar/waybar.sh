#!/bin/sh

[ "$#" -eq 0 ] || {
    { [ "$#" -eq 1 ] && [ "$1" = 'exit' ]; } \
        || return 1; }

# Terminate waybar custom modules.
for pipe in "$XDG_RUNTIME_DIR"/bar*pipe; do
    [ -p "$pipe" ] && printf 'exit\n' > "$pipe"
done

# If waybar process exists, terminate it.
killall -q waybar
while pidof waybar >/dev/null; do sleep 1; done

[ "$#" -eq 1 ] || exec waybar
