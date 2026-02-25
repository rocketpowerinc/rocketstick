#!/usr/bin/env bash

set -e

# Update system
sudo pacman -Syu --noconfirm

# Install Go
sudo pacman -S --noconfirm go

# Add Go bin to PATH if not already present
if ! grep -q 'export PATH="$HOME/go/bin:$PATH"' "$HOME/.bashrc"; then
    echo 'export PATH="$HOME/go/bin:$PATH"' >> "$HOME/.bashrc"
fi

# Install required packages
sudo pacman -S --noconfirm git github-cli jq make bat tmux curl wget glow gum gnome-terminal

# Install go-pwr
go install -v github.com/rocketpowerinc/go-pwr/cmd/go-pwr@latest

# Reload shell config
source "$HOME/.bashrc"

# Run go-pwr
go-pwr