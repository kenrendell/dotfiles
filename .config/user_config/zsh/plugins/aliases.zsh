# ZSH Aliases

# Use sudo with aliased commands
alias sudo='sudo '

# Editor
alias v='nvim'

# File listing
alias ls='exa -FGa --color=always -s type'
alias ll='exa -Flhamg --color=always -s type'

# Matching patterns
alias grep='grep --color=auto'

# Comparing files
alias diff='diff --color=auto'

# File manipulation
alias cp='cp -rvi'
alias mv='mv -vi'
alias rm='rm -rvf'
alias mkdir='mkdir -pv'

# Jump back to Directories
alias d='dirs -v'
for index ({0..9}) alias "$index"="cd +${index}"; unset index

# History manipulation
alias hr=' fc -R'                         # Read history from file.
alias hw=' fc -W'                         # Write history to file.
alias hl=' fc -iDl 1'                     # List all history from file.
alias he=' nvim -c "setl ft=" $HISTFILE'  # Edit the history file.

# Time
alias time='command time -f "\nProgram: %C\nReal: %e s - User: %U s - System: %S s - CPU: %P"'

# Dotfiles management
alias gitdf='git --git-dir="$HOME/.gitdf" --work-tree="$HOME"'

# Network
alias ip='ip -c'
