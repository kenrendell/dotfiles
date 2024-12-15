# ZSH Profile

# To execute user binaries without specifying the relative/absolute path
append_path () {
	if [ -n "$1" ] && [ "$1" = "${1#*:}" ]; then
		case ":${PATH}:" in
			(*":${1}:"*)
				lpath="${PATH%:${1}*}"; [ "$lpath" = "$PATH" ] && lpath=
				rpath="${PATH#*${1}:}"; [ "$rpath" = "$PATH" ] && rpath=

				{ [ -n "$lpath" ] && PATH="${lpath}:"; } || PATH=
				[ -n "$rpath" ] && PATH="${PATH}${rpath}:"

				PATH="${PATH}${1}";;
			(*) PATH="${PATH}:${1}";;
		esac;
	fi
}

append_path "${HOME}/.local/bin" # must be appended first since we are using nixGL wrapper for nix programs
append_path "${XDG_STATE_HOME}/nix/profile/bin"
append_path "${HOME}/.local/bin/statusbar"
export PATH

# Additional XDG directory to search for data files. 
append_data () { [ "$1" = "${1#*:}" ] && case ":${XDG_DATA_DIRS}:" in (*":${1}:"*);; (*) XDG_DATA_DIRS="${XDG_DATA_DIRS}:${1}";; esac; }
append_data "${XDG_STATE_HOME}/nix/profile/share"
export XDG_DATA_DIRS

# XDG user directory (not included in XDG base directories)
sed -E -n 's/^[[:space:]]*([_a-zA-Z][_a-zA-Z0-9]*)=.*$/\1/p' '/etc/xdg/user-dirs.defaults' | \
	while read -r userdir; do eval "export XDG_${userdir}_DIR='$(xdg-user-dir ${userdir})'"; done

# Execute wayland compositor
[ "$(tty)" = '/dev/tty1' ] && {
	exec 1> "${XDG_STATE_HOME}/.sway-session.log" 2>&1
	exec sway
}
