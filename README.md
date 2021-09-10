# .gitdf
Dotfiles (wayland) on Arch linux

## Installation:
user_home='/home/USER'<br />
git clone --bare https://github.com/kenrendell/.gitdf "$user_home/.gitdf"<br />
git --git-dir="$user_home/.gitdf" --work-tree="$user_home" checkout
