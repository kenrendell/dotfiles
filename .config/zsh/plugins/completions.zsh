# Completions

# Completion behavior
set -o menucomplete \
	-o completealiases \
	-o nocaseglob \
	-o globdots

# Key bindings for completion menu
zmodload zsh/complist
bindkey -M menuselect '^u' undo
bindkey -M menuselect '^i' vi-insert
bindkey -M menuselect '^ ' accept-and-hold
bindkey -M menuselect 'h'  vi-backward-char
bindkey -M menuselect 'k'  vi-up-line-or-history
bindkey -M menuselect 'l'  vi-forward-char
bindkey -M menuselect 'j'  vi-down-line-or-history

# Load compinit for completion system
# To update compinit, run 'update_compinit'
autoload -Uz compinit
compinit -C -d "$ZCOMPDUMP"

##############################
## Completion Configuration ##
##############################

# General
zstyle ':completion:*' menu select
zstyle ':completion:*' verbose true
zstyle ':completion:*' numbers true
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' list-separator ':='

# Completion caching
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path "$ZCOMPCACHE"

# Colors
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} '=(#b)*(:=)(*)=00;38;5;5=00;38;5;8=00;38;5;4'
zstyle ':completion:*:options' list-colors '=*=00;38;5;5'

# Completion order: case-sensitive -> case-insensitive -> partial-word -> sub-string
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
