DOTFILES with Wayland (Sway) on Arch Linux

### Installation:
``` sh
git clone --bare https://github.com/kenrendell/dotfiles.git "$HOME/.dotfiles"  
alias dotfiles='git --git-dir="$HOME/.dotfiles" --work-tree="$HOME"'  
dotfiles checkout
```
