# ZSH Profile

# Start GPG agent
eval "$(ssh-agent -sk)"
eval "$(gpg-agent --sh --daemon)"

# Execute wayland compositor
[ "$(tty)" = '/dev/tty1' ] && exec sway
