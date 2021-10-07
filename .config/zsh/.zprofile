# ZSH Profile

# Include user local binaries in PATH.
export PATH="$PATH:$HOME/.local/bin:$HOME/.local/bin/statusbar"

# Execute wayland compositor
[ "$(tty)" = '/dev/tty1' ] && exec sway >/dev/null 2>&1
