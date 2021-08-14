# .gitdf
Configurations (dotfiles) for Debian Sid

## Installation
git clone -c status.showUntrackedFiles=no --bare https://github.com/kenrendell/.gitdf "$HOME/.gitdf"<br />
git --git-dir="$HOME/.gitdf" --work-tree="$HOME" checkout
