# ZSH Environment Variables
# NOTE: This file will be executed once.

# XDG base directory
# see 'https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html'
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# To execute user binaries without specifying the relative/absolute path
export PATH="$PATH:$HOME/.local/bin:$HOME/.local/bin/statusbar"

# To load other ZSH configuration files
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Source environment variables in ZDOTDIR
. "$ZDOTDIR/.zshenv"
