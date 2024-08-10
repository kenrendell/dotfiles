# ZSH Interactive Shell

# Prompt
PS1=$'%{\e[38;5;8m%}%~%{\e[m%}\n%(1j.%{\e[38;5;6m%}%j%{\e[m%} .)%(?.%{\e[38;5;12m%}.%{\e[38;5;1m%})▶%{\e[m%} '
PS2=$'%{\e[38;5;8m%}▶%{\e[m%} '

# Tell ssh to use gpg-agent for ssh authentication
unset SSH_AGENT_PID; export GPG_TTY="$(tty)"
[ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne "$$" ] && \
	export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"

# Emit OSC 7 escape sequence
_osc7_cwd() ( str="$PWD"
	while [ -n "${char:="${str%"${str#?}"}"}" ]; do
		[ "$char" = '%' ] && char='%25'
		cwd="${cwd}${char}"; str="${str#?}"; char=
	done; printf '\033]7;%s\033\\' "file://$(hostname)$cwd"
)
autoload -Uz add-zsh-hook
add-zsh-hook -Uz chpwd _osc7_cwd

# Changing directories
set -o autocd \
	-o cdsilent \
	-o autopushd \
	-o pushdsilent \
	-o pushdignoredups

# History
set -o histverify \
	-o histreduceblanks \
	-o histignorespace \
	-o histignorealldups \
	-o histsavenodups \
	-o extendedhistory \
	-o sharehistory

# Key bindings
bindkey -M viins '^?' backward-delete-char

# Aliases
. "$ZDOTDIR/plugins/aliases.zsh"

# Completions
. "$ZDOTDIR/plugins/completions.zsh"

# Load FZF bindings
command -v fzf >/dev/null 2>&1 && {
	. '/usr/share/fzf/key-bindings.zsh'
	. '/usr/share/fzf/completion.zsh'
}

# Syntax Highlighting (must be sourced at the end of this file)
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
. '/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'

# Load and unload environment variables depending on the current directory.
eval "$(direnv hook zsh)"
