# ZSH Profile

# To execute user binaries without specifying the relative/absolute path
append_path () { [ "$1" = "${1#*:}" ] && case ":${PATH}:" in (*":${1}:"*);; (*) PATH="${PATH}:${1}";; esac; }
append_path "${XDG_STATE_HOME}/nix/profile/bin"
append_path "${HOME}/.local/bin"
append_path "${HOME}/.local/bin/statusbar"
export PATH

# Execute wayland compositor
[ "$(tty)" = '/dev/tty1' ] && {
	exec 1> "${XDG_STATE_HOME}/.sway-session.log" 2>&1
	exec sway
}
