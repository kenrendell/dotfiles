# ZSH Interactive Shell

# Exit when in console terminal.
[[ "$SHLVL" -eq 1 ]] && return

# Initialize tools
source "$ZDOTDIR/plugins/init.zsh"

# Directory
setopt AUTO_CD                  # Use cd command automatically.
setopt AUTO_PUSHD               # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS        # Do not store duplicates in the stack.
setopt PUSHD_SILENT             # Do not print the directory stack after pushd or popd.

# History
setopt HIST_VERIFY              # Don't directly execute the line with history expansions.
setopt HIST_REDUCE_BLANKS       # Remove superfluous blanks from each command line being added.
setopt HIST_IGNORE_SPACE        # Commands with leading space aren't save to history.
setopt HIST_IGNORE_ALL_DUPS     # Remove the older duplicates of an added commands.
setopt INC_APPEND_HISTORY_TIME  # Append the history entry to the history file after the command is finished.
setopt EXTENDED_HISTORY         # Save each commands with format, ": <beginning time>:<elapsed seconds>;<command>".

# Input/Output
setopt CORRECT                  # Try to correct the spelling of commands.
setopt CORRECT_ALL              # Try to correct the spelling of all arguments in a line.
setopt PRINT_EXIT_VALUE         # Print the exit value of programs with non-zero exit status.

# Load edit-command-line function.
autoload -Uz edit-command-line
zle -N edit-command-line

# Load complist module to use menuselect.
zmodload zsh/complist

# Key Bindings
bindkey -v
bindkey -M viins      '^?'  backward-delete-char   # "BackSpace"            := Always delete single character backwards. [insert mode]
bindkey -M viins      '^ .' vi-end-of-line         # "Ctrl + Space + Dot"   := Accept suggestions. [insert mode]
bindkey -M viins      '^ ,' vi-forward-blank-word  # "Ctrl + Space + Comma" := Partial-accept suggestions. [insert mode]
bindkey -M viins      '^ e' edit-command-line      # "Ctrl + Space + e"     := Edit command line with text editor. [insert mode]
bindkey -M vicmd      '^ e' edit-command-line      # "Ctrl + Space + e"     := Edit command line with text editor. [command mode]
bindkey -M menuselect 'h'   vi-backward-char
bindkey -M menuselect 'k'   vi-up-line-or-history
bindkey -M menuselect 'l'   vi-forward-char
bindkey -M menuselect 'j'   vi-down-line-or-history

# Aliases
source "$ZDOTDIR/plugins/aliases.zsh"
