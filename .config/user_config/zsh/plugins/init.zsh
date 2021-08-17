# Initialize ZSH Tools

# Enable Powerlevel10k instant prompt.
_instant_prompt() {
    # Initialization code that may require console input (password prompts, [y/n]
    # confirmations, etc.) must go above this block; everything else may go below.
    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
        source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi

    # Load prompt configurations
    [[ -f "$ZDOTDIR/plugins/prompt.zsh" ]] && source "$ZDOTDIR/plugins/prompt.zsh"
}

_zgen_init() {
    # Manage the position of instant prompt.
    if [[ ! -f "$ZGEN_INIT" ]]; then
        # Load zgen
        source "$ZGEN_DIR/zgen.zsh"

        # Load plugins
        zgen load romkatv/powerlevel10k powerlevel10k
        zgen load zsh-users/zsh-autosuggestions
        zgen load zsh-users/zsh-syntax-highlighting

        # Install/Update fzf
        if ping -c 1 8.8.8.8 > /dev/null 2>&1; then
            if whence fzf > /dev/null; then
                git -C "$FZF_BASE" pull && "$FZF_BASE/install" --bin
            else
                rm -rf "$FZF_BASE"
                git clone --depth 1 https://github.com/junegunn/fzf.git "$FZF_BASE" && \
                    "$FZF_BASE/install" --bin
            fi
        fi

        # Load fzf wrapper
        if whence fzf > /dev/null; then
            zgen load "$FZF_BASE/shell/key-bindings.zsh"
            zgen load "$FZF_BASE/shell/completion.zsh"
        fi

        # Load completions
        zgen load "$ZDOTDIR/plugins/completions.zsh"

        # Generate the init script from plugins above
        zgen save

        _instant_prompt
    else
        _instant_prompt

        # Load zgen silently to avoid disturbing instant prompt
        source "$ZGEN_DIR/zgen.zsh" >/dev/null 2>&1
    fi

    source "$ZDOTDIR/plugins/plugin_opts.zsh"
}

# ZGEN - Plugin Manager
# zgen commands:
# 'zgen load <repo>' - load plugins
# 'zgen save'        - generate init script
# 'zgen reset'       - remove init script
# 'zgen saved'       - check for an init script
# 'zgen update'      - update all plugins and reset
# 'zgen selfupdate'  - update zgen

# Install zgen
[[ -f "$ZGEN_DIR/zgen.zsh" ]] || { rm -rf "$ZGEN_DIR"; \
    git clone https://github.com/tarjoilija/zgen.git "$ZGEN_DIR"; } && _zgen_init

# Set window title
_set_title() { local title="\033]0;${PWD/$HOME/~}\007"; printf '%b' "$title"; }

# Configure zsh to emit the OSC 7 escape sequence for 'foot terminal'.
# See 'https://codeberg.org/dnkl/foot/wiki#user-content-how-to-configure-my-shell-to-emit-the-osc-7-escape-sequence'
# Bug: Can't `exit` Ctrl+Shift+N spawned foot termminal.
_urlencode() {
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:$i:1}"
        case $c in
            %) printf '%%%02X' "'$c" ;;
            *) printf "%s" "$c" ;;
        esac
    done
}

_osc7_cwd() { printf '\e]7;file://%s%s\e\\' "$HOSTNAME" "$(_urlencode "$PWD")"; }

autoload -Uz add-zsh-hook
add-zsh-hook -Uz chpwd _osc7_cwd
add-zsh-hook -Uz precmd _set_title
