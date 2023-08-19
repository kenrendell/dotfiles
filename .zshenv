# ZSH Environment Variables
# NOTE: This file will be executed once.

# XDG base directory
# see 'https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html'
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_STATE_HOME="${HOME}/.local/state"
export XDG_CACHE_HOME="${HOME}/.cache"

# XDG user directory
sed -E -n 's/^[[:space:]]*([_a-zA-Z][_a-zA-Z0-9]*)=.*$/\1/p' '/etc/xdg/user-dirs.defaults' \
| while read -r userdir; do eval "export XDG_${userdir}_DIR='$(xdg-user-dir ${userdir})'"; done

# To load other ZSH configuration files
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# Source environment variables in ZDOTDIR
. "${ZDOTDIR}/.zshenv"
