# ZSH Profile

# To execute user binaries without specifying the relative/absolute path
# append_path () {
# 	if [ -n "$1" ] && [ "$1" = "${1#*:}" ]; then
# 		case ":${PATH}:" in
# 			(*":${1}:"*)
# 				lpath="${PATH%:${1}*}"; [ "$lpath" = "$PATH" ] && lpath=
# 				rpath="${PATH#*${1}:}"; [ "$rpath" = "$PATH" ] && rpath=
#
# 				{ [ -n "$lpath" ] && PATH="${lpath}:"; } || PATH=
# 				[ -n "$rpath" ] && PATH="${PATH}${rpath}:"
#
# 				PATH="${PATH}${1}";;
# 			(*) PATH="${PATH}:${1}";;
# 		esac;
# 	fi
# }

# Function to modify paths
prepend_envv () {
	{ [ -n "$2" ] && [ "$2" = "${2#*:}" ]; } || { printf "No ':' character is allowed!\n"; return 1; }

	# Extract the value from the variable
	envv="$(eval printf "'%s'" '"${'"${1}"'}"')" || return 1

	# Remove redundant colons ':'
	while [ "${envv#*::}" != "${envv}" ]; do
		envv="$(printf '%s' "${envv}" | sed -E -n 's/(:{2,})/:/p')"
	done; envv="${envv#:}"; envv="${envv%:}"

	# Prepend the entry
	case ":${envv}:" in
		(*":${2}:"*) # delete entry if exists
			lpath="${envv%:"${2}"*}"; [ "${lpath}" = "${envv}" ] && lpath=
			rpath="${envv#*"${2}":}"; [ "${rpath}" = "${envv}" ] && rpath=

			{ [ -n "${rpath}" ] && envv=":${rpath}"; } || envv=
			[ -n "${lpath}" ] && envv=":${lpath}${envv}"

			envv="${2}${envv}" ;;
		(*) envv="${2}$(test -n "${envv}" && printf ':')${envv}" ;;
	esac;

	# Assign the resulting value
	eval "${1}='${envv}'"
}


# append_path "${HOME}/.local/bin" # must be appended first since we are using nixGL wrapper for nix programs
# append_path "${XDG_STATE_HOME}/nix/profile/bin"
# append_path "${HOME}/.local/bin/statusbar"
# export PATH

# Additional binaries
prepend_envv PATH '/nix/var/nix/profiles/default/bin' || return 1
prepend_envv PATH "${XDG_STATE_HOME}/nix/profile/bin" || return 1
prepend_envv PATH "${HOME}/.local/bin" || return 1
prepend_envv PATH "${HOME}/.local/bin/statusbar" || return 1
export PATH

# Additional data files
prepend_envv XDG_DATA_DIRS '/nix/var/nix/profiles/default/share' || return 1
prepend_envv XDG_DATA_DIRS "${XDG_STATE_HOME}/nix/profile/share" || return 1
export XDG_DATA_DIRS

# XDG user directory (not included in XDG base directories)
sed -E -n 's/^[[:space:]]*([_a-zA-Z][_a-zA-Z0-9]*)=.*$/\1/p' '/etc/xdg/user-dirs.defaults' | \
	while read -r userdir; do eval "export XDG_${userdir}_DIR='$(xdg-user-dir ${userdir})'"; done

# Execute wayland compositor
[ "$(tty)" = '/dev/tty1' ] && {
	exec 1> "${XDG_STATE_HOME}/.sway-session.log" 2>&1
	exec sway
}
