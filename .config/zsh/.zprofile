# ZSH Profile

# Start GPG agent
# https://gist.github.com/mcattarinussi/834fc4b641ff4572018d0c665e5a94d3
eval "$(ssh-agent -sk)"
eval "$(gpg-agent --sh --daemon)"

# Execute wayland compositor
[ "$(tty)" = '/dev/tty1' ] && exec sway
