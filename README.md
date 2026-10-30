# My dotfiles using [chezmoi](https://www.chezmoi.io/)

## Macos
```bash
# Homebrew is needed for git
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Install git
brew install git
# Rosetta
softwareupdate --install-rosetta
# Nix
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
# chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply lchagnoleau
# In a new shell:
mise install
mise plugin install fnox-env https://github.com/jdx/mise-env-fnox
podman machine init
podman machine start
```

## Linux
```bash
# Nix
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
# chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply lchagnoleau
# In a new shell:
echo $(which zsh) | sudo tee -a /etc/shells
chsh -s $(which zsh)
```


## Upgrade everything

Everything tracks the latest versions. To pull the dotfiles and upgrade Nix
packages, Homebrew, mise tools, zsh plugins and tmux plugins:

```bash
dotup
```

To only update and rebuild the Nix configuration: `nix-switch`.

The Nix configuration is also rebuilt automatically by `chezmoi apply` whenever
a file in `dot_config/nix/` changes.
