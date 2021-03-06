# ZSH Aliases

# To use the command without an alias:
#   -> \<command>
#   -> command <command>

# Use sudo with aliased commands
alias sudo='sudo '

# Open a file or URL in the user's preferred application.
alias o='xdg-open'

# Editor
alias v='nvim'

# Edit history file
alias vh=' nvim -c "setl ft=" "$HISTFILE"'

# File listing
alias ls='exa -FGa --color=auto -s type'
alias ll='exa -Flhamg --color=auto -s type'

# Estimate file space usage
alias du='du -csh'

# Viewing files
alias cat='bat'

# Finding files
alias fd='fd --color auto --hidden --follow'

# Calculator
alias bc='bc -ql'

# Comparing files
alias diff='diff --color=auto'

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
alias ip='ip -c'

# Memory
alias free='free -ht'

# Disk filesystem
alias df='df -hT --sync'

# Run programs and summarize system resource usage.
alias time='command time -f "Program: %C\nReal: %e s - User: %U s - System: %S s - CPU: %P"'

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
