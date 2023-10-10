# ZSH Aliases

# To use the command without an alias:
#   -> \<command>
#   -> command <command>

# Use sudo with aliased commands
alias sudo='sudo '

# Open a file or URL in the user's preferred application.
alias o='xdg-open'

# Markup
alias pandoc='pandoc --pdf-engine=tectonic'

# Editor
alias v='nvim'

# Edit history file
alias vh=' nvim -c "setl ft=" "$HISTFILE"'

# File listing
alias ls='eza -FGa --color=auto -s type'
alias ll='eza -Flhamg --color=auto -s type'

# Viewing files
alias cat='bat'

# Finding files
alias fd='fd --color auto --hidden --follow'

# Calculator
alias bc='bc -ql'

# Matching patterns
alias rg='rg --color=auto'
alias grep='grep --color=auto'

# File manipulation
alias ln='ln -iv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'
alias mkdir='mkdir -pv'

# Managing dotfiles
alias dotfiles='git --git-dir="$HOME/.dotfiles" --work-tree="$HOME"'

# Network
alias wan='drill -Q myip.opendns.com @resolver1.opendns.com'
alias ip='ip -color'

# Memory
alias free='free -ht'

# Disk usage
alias df='duf'
alias du='dust'

alias ps='procs'

# Update compinit
update_compinit() {
	command rm -rf "$ZCOMPDUMP"
	compinit -i -d "$ZCOMPDUMP"
}

# Fix corrupted zsh history file
fix_zsh_history() {
	command mv "$HISTFILE" "${HISTFILE}.bak"
	strings --encoding=S "${HISTFILE}.bak" > "$HISTFILE"
	fc -R "$HISTFILE"
}
