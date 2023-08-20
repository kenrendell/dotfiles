# ZSH Environment Variables
# NOTE: This file will be executed once.
#
# For XDG base directories, see "https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html".

# XDG home directory
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_STATE_HOME="${HOME}/.local/state"
export XDG_CACHE_HOME="${HOME}/.cache"

# XDG system directory
export XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
export XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS:-/etc/xdg}"

# To load other ZSH configuration files
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# Source environment variables in ZDOTDIR
. "${ZDOTDIR}/.zshenv"
