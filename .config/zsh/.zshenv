# ZSH Environment Variables

# ZSH configuration files
export HISTFILE="$XDG_STATE_HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
export KEYTIMEOUT=1
export ZCOMPCACHE="$XDG_CACHE_HOME/.zcompcache"
export ZCOMPDUMP="$XDG_CACHE_HOME/.zcompdump"

# Default programs
export EDITOR='nvim'
export VISUAL='nvim'
export BROWSER='lynx'

# Sudo
export SUDO_ASKPASS="$HOME/.local/bin/ask-passwd.sh"

# GO environment
export GOPATH="$XDG_DATA_HOME/go"

# Set LS_COLORS
eval "$(dircolors -b "$ZDOTDIR/colors/.dircolors")"

# Colors
export \
	COLOR_00='1E1E1E' \
	COLOR_01='9D535D' \
	COLOR_02='5D9D53' \
	COLOR_03='9D9353' \
	COLOR_04='535D9D' \
	COLOR_05='93539D' \
	COLOR_06='539D93' \
	COLOR_07='787878' \
	COLOR_08='383838' \
	COLOR_09='B37079' \
	COLOR_10='79B370' \
	COLOR_11='B3AA70' \
	COLOR_12='7079B3' \
	COLOR_13='AA70B3' \
	COLOR_14='70B3AA' \
	COLOR_15='929292' \
	COLOR_FG='787878' \
	COLOR_BG='000000'

# Dynamic Menu
export BEMENU_OPTS="\
--wrap \
--prompt menu \
--line-height 24 \
--fn 'JetBrains Mono 9' \
--tf '#${COLOR_02}' --tb '#${COLOR_BG}' \
--ff '#${COLOR_04}' --fb '#${COLOR_BG}' \
--nf '#${COLOR_07}' --nb '#${COLOR_BG}' \
--hf '#${COLOR_03}' --hb '#${COLOR_BG}' \
--sf '#${COLOR_05}' --sb '#${COLOR_15}'"

# FZF configurations
export FZF_DEFAULT_COMMAND='fd --type file --hidden --follow'
export FZF_DEFAULT_OPTS="\
--bind='ctrl-space:toggle-search,btab:toggle-preview'
--height=60%
--reverse
--prompt='▶ '
--marker='> '
--pointer=' ▶'
--color='fg:8,bg:-1,preview-fg:7,preview-bg:-1,hl:4,hl+:4'
--color='fg+:8,bg+:-1,gutter:-1,query:4,disabled:8,info:5'
--color='border:0,prompt:8,pointer:12,marker:9,spinner:3,header:2'
--no-bold$(tty | grep -q '^/dev/tty' && printf '\n--no-unicode')"

# Pager settings
export MANPAGER='nvim +Man!'
export PAGER='less'
export LESS='-RF'
export LESSHISTFILE='/dev/null'

# Music Player Daemon (for MPD clients)
export MPD_HOST='::'
export MPD_PORT=6600

# Git
export GIT_CONFIG_COUNT=6
export GIT_CONFIG_KEY_0='init.defaultbranch' GIT_CONFIG_VALUE_0='main'
export GIT_CONFIG_KEY_1='user.name' GIT_CONFIG_VALUE_1='Ken Rendell L. Caoile'
export GIT_CONFIG_KEY_2='user.email' GIT_CONFIG_VALUE_2='kaoile.cenrendell@gmail.com'
export GIT_CONFIG_KEY_3='user.signingkey' GIT_CONFIG_VALUE_3="$GIT_CONFIG_VALUE_1 <${GIT_CONFIG_VALUE_2}>"
export GIT_CONFIG_KEY_4='commit.gpgsign' GIT_CONFIG_VALUE_4=true
export GIT_CONFIG_KEY_5='tag.gpgsign' GIT_CONFIG_VALUE_5=true

# Wayland
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM='wayland;xcb'
export QT_QPA_PLATFORMTHEME='qt5ct'
export SDL_VIDEODRIVER='wayland,x11'
export ELECTRON_OZONE_PLATFORM_HINT='wayland'

# Zettelkasten
export ZK_NOTEBOOK_DIR="$XDG_DOCUMENTS_DIR/kenrendell-wiki"

# Lynx
export LYNX_CFG_PATH="$XDG_CONFIG_HOME/lynx"
export LYNX_CFG="$LYNX_CFG_PATH/lynx.cfg"
export LYNX_LSS="$LYNX_CFG_PATH/lynx.lss"

# Task-warrior default data location
export TASKDATA="${XDG_DATA_HOME}/task"
