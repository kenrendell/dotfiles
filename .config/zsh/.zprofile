# ZSH Profile

# Default PATH
{ [ -z "$PATH" ] || [ "$PATH" = '/bin:/usr/bin' ]; } && \
    export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"

# Include user local binaries in PATH.
export PATH="$PATH:$HOME/.local/bin:$HOME/.local/bin/statusbar"

# Include binaries and desktop files from snap packages.
command -v snap >/dev/null 2>&1 && {
    export PATH="$PATH:/snap/bin"
    export XDG_DATA_DIRS="$XDG_DATA_DIRS:/var/lib/snapd/desktop"
}

# Execute wayland compositor
[ "$(tty)" = '/dev/tty1' ] && exec sway >/dev/null 2>&1
