# ZSH Environment Variables

# System Backlight (see '/sys/class/backlight/')
export BACKLIGHT_DEVICE='intel_backlight'

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
# See https://github.com/folke/tokyonight.nvim/blob/main/extras/foot/tokyonight_night.ini
export \
	COLOR_00='15161e' \
	COLOR_01='f7768e' \
	COLOR_02='9ece6a' \
	COLOR_03='e0af68' \
	COLOR_04='7aa2f7' \
	COLOR_05='bb9af7' \
	COLOR_06='7dcfff' \
	COLOR_07='a9b1d6' \
	COLOR_08='414868' \
	COLOR_09='f7768e' \
	COLOR_10='9ece6a' \
	COLOR_11='e0af68' \
	COLOR_12='7aa2f7' \
	COLOR_13='bb9af7' \
	COLOR_14='7dcfff' \
	COLOR_15='c0caf5' \
	COLOR_16='ff9e64' \
	COLOR_17='db4b4b' \
	COLOR_FG='c0caf5' \
	COLOR_BG='1a1b26' \
	COLOR_SFG='c0caf5' \
	COLOR_SBG='283457' \
	COLOR_URL='73daca'

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

# export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
#   --highlight-line \
#   --info=inline-right \
#   --ansi \
#   --layout=reverse \
#   --border=none
#   --color=bg+:#283457 \
#   --color=bg:#16161e \
#   --color=border:#27a1b9 \
#   --color=fg:#c0caf5 \
#   --color=gutter:#16161e \
#   --color=header:#ff9e64 \
#   --color=hl+:#2ac3de \
#   --color=hl:#2ac3de \
#   --color=info:#545c7e \
#   --color=marker:#ff007c \
#   --color=pointer:#ff007c \
#   --color=prompt:#2ac3de \
#   --color=query:#c0caf5:regular \
#   --color=scrollbar:#27a1b9 \
#   --color=separator:#ff9e64 \
#   --color=spinner:#ff007c \
# "

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
export SDL_VIDEODRIVER='wayland,x11'
export ELECTRON_OZONE_PLATFORM_HINT='wayland'

# Appearance
export QT_QPA_PLATFORMTHEME='qt5ct'
export QT_STYLE_OVERRIDE='kvantum'
export GTK_THEME='Arc-Dark'

# Zettelkasten
export ZK_NOTEBOOK_DIR="$XDG_DOCUMENTS_DIR/kenrendell-wiki"

# Lynx
export LYNX_CFG_PATH="$XDG_CONFIG_HOME/lynx"
export LYNX_CFG="$LYNX_CFG_PATH/lynx.cfg"
export LYNX_LSS="$LYNX_CFG_PATH/lynx.lss"

# Task-warrior default data location
export TASKDATA="${XDG_DATA_HOME}/task"

# Xschem PDK
# http://repo.hu/projects/xschem/xschem_man/tutorial_xschem_sky130.html
export PDK_ROOT="${XDG_DATA_HOME}/pdk"
export PDK='sky130B'

# Nix Package Manager
export NIXPKGS_ALLOW_UNFREE=1
