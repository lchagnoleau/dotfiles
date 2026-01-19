# My dotfiles using [chezmoi](https://www.chezmoi.io/)

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
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake ~/.config/nix#BigMac
```

## Ugrade Nix pacakages

```bash
#update packages
nix flake update
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake ~/.config/nix#BigMac
```
