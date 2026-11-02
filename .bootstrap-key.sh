#!/bin/sh

export KEY_FILE="${HOME}/.config/fnox/age.txt"

# If the key already exists, exit immediately so chezmoi continues
if [ -f "$KEY_FILE" ]; then
  exit 0
fi

echo "Age key missing. Bootstrapping via Nix and Bitwarden..."

# Unified cross-platform Nix installation
if ! command -v nix-shell >/dev/null 2>&1; then
  echo "Installing Nix (Multi-user daemon)..."

  curl -L https://nixos.org/nix/install | sh -s -- --daemon

  # Source the Nix daemon profile so nix-shell works in this script
  if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
  fi
fi

# Use nix-shell to dynamically download and run Bitwarden CLI
echo "Please log into Bitwarden to fetch your age key."

# shellcheck disable=SC2016
nix-shell -p bitwarden-cli --run '
    export BW_SESSION=$(bw login --raw)
    mkdir -p "$HOME/.config/fnox"
    bw get notes "ed929e7c-a3c3-4052-ba00-b3e700f5ab68" > "$KEY_FILE"
    chmod 600 "$KEY_FILE"
'

echo "Age key securely retrieved!"
