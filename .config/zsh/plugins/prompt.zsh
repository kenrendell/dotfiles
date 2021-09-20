# Initialize prompt

[ -n "$WAYLAND_DISPLAY" ] || {
PS1='%F{8}%~%f
%(1j.%F{6}%j%f .)%(?.%F{12}▶%f.%F{1}▶%f) '
PS2='%F{8}▶%f '
return }

PS1='%F{8}%~%f
%(1j.%F{6}%j%f .)%(?.%F{12}▶%f.%F{1}▶%f) '
PS2='%F{8}▶%f '

# Emit OSC 7 escape sequence
_osc7_cwd() {
    url="file://$(hostname)$(urlencode.sh $PWD)"
    printf '\033]7;%s\033\\' "$url"
    unset url
}

# Hook function:
#   chpwd  -> Executed once the current working directory is changed.
autoload -Uz add-zsh-hook
add-zsh-hook -Uz chpwd _osc7_cwd
