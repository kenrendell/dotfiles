# ZSH Environment Variables

# Change default shell: sudo chsh -s "$(which zsh)" [username]
# Order: .zshenv -> .zprofile -> .zshrc -> .zlogout

# XDG Paths
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Include user local and snap binaries in PATH.
export PATH="$HOME/.local/bin:$HOME/.local/bin/statusbar:$PATH:/snap/bin"

# ZSH configuration files
export HISTFILE="$XDG_CACHE_HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
export KEYTIMEOUT=1

# Set LS_COLORS
eval "$(dircolors -b "$ZDOTDIR/colors/.dircolors")"

# Paths/settings used by zgen to manage the plugins of zsh.
export ZGEN_DIR="$XDG_DATA_HOME/zgen"
export ZGEN_INIT="$ZGEN_DIR/init.zsh"
export ZGEN_AUTOLOAD_COMPINIT=0

# Editor
export EDITOR='nvim'
export VISUAL='nvim'

# Colors
export BASE_0='#1D2025'
export BASE_1='#282D33'
export BASE_2='#363B45'
export BASE_3='#5E6878'
export BASE_4='#A1A8B5'
export BASE_5='#BAC0C9'
###
export RED_0='#DC657D'
export GREEN_0='#79B370'
export YELLOW_0='#E18051'
export BLUE_0='#5596E2'
export MAGENTA_0='#B07AB8'
export CYAN_0='#4AB0A6'
###
export RED_1='#E48698'
export GREEN_1='#98C491'
export YELLOW_1='#E79D78'
export BLUE_1='#78ACE7'
export MAGENTA_1='#C095C6'
export CYAN_1='#73C4BC'

# GO environment
export GOPATH="$HOME/go:/usr/share/gocode"

# Include FZF binaries in PATH.
export FZF_BASE="$XDG_DATA_HOME/fzf"
export PATH="$PATH:$FZF_BASE/bin"

# FZF configurations
export FZF_DEFAULT_COMMAND='fdfind --type file --hidden --follow'
export FZF_DEFAULT_OPTS="
--bind='ctrl-space:toggle-search,btab:toggle-preview'
--height=60%
--layout=reverse
--prompt='❯ '
--marker='❯ '
--pointer=' ▶'
--no-bold
--color='fg:7,bg:$BASE_0,preview-fg:7,preview-bg:$BASE_0'
--color='gutter:$BASE_0,fg+:15,bg+:0,hl:4,hl+:12'
--color='border:8,query:4,disabled:7,info:5,header:2'
--color='prompt:12,pointer:14,marker:9,spinner:3'
"

# Pager settings
export MANPAGER="sh -c \"col -b | nvim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
export PAGER='less'
export LESS='-RF'
export LESSHISTFILE="$XDG_CACHE_HOME/.lesshst"
export LESSHISTSIZE=100
export LESS_TERMCAP_mb="$(tput bold; tput setaf 5)"
export LESS_TERMCAP_md="$(tput bold; tput setaf 4)"
export LESS_TERMCAP_me="$(tput sgr0)"
export LESS_TERMCAP_so="$(tput bold; tput setaf 3)"
export LESS_TERMCAP_se="$(tput rmso; tput sgr0)"
export LESS_TERMCAP_us="$(tput setaf 1)"
export LESS_TERMCAP_ue="$(tput rmul; tput sgr0)"
export LESS_TERMCAP_mr="$(tput rev)"
export LESS_TERMCAP_mh="$(tput dim)"

# GUI settings
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export QT_QPA_PLATFORM='wayland' # 'qtwayland5' is needed for Wayland support.
export QT_QPA_PLATFORMTHEME='gtk2' # 'qt5-style-plugins' is needed to use gtk2 theme.
export MOZ_ENABLE_WAYLAND=1
