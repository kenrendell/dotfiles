# ZSH Interactive Shell

# Prompt
. "$ZDOTDIR/plugins/prompt.zsh"

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
