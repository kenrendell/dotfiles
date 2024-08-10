# My Dotfiles on Arch Linux

## Installation

``` sh
git clone --bare 'https://github.com/kenrendell/dotfiles.git' "${HOME}/.dotfiles"
alias dotfiles='git --git-dir="${HOME}/.dotfiles" --work-tree="$HOME"'
dotfiles config status.showUntrackedFiles no
dotfiles checkout
```

### Installing Nix Packages

```sh
# Build and install nix packages
nix run "${XDG_CONFIG_HOME}/nix/pkgs#profile.switch"

# Update nix packages
nix flake update --flake "${XDG_CONFIG_HOME}/nix/pkgs"
nix run "${XDG_CONFIG_HOME}/nix/pkgs#profile.switch"
```

See [Declarative profiles with Nix flakes](https://github.com/lf-/flakey-profile)
