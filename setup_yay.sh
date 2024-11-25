#!/bin/bash

# Update package manager
echo "Updating package database..."
yay -Syu --noconfirm

# Install necessary packages via Yay
yay_packages=(
    bitwarden
    firefox
    discord
    google-chrome
    spotify
    dbeaver
    httpie
    kitty
    redisinsight
    code           
    godot
    
    curl
    fortune
    fzf
    git
    htop
    neofetch
    neovim
    ranger
    tmux
    zsh
    nmap
    wireshark
    nodejs
    python
    python-pip
    pipx
    poetry
    rust
    gcc
    gdb
    make
    ninja
    go
    docker
    kubectl
    helm
    sqlite
    redis
)

for pkg in "${yay_packages[@]}"; do
    if ! yay -Q "$pkg" &>/dev/null; then
        echo "Installing $pkg..."
        yay -S --noconfirm "$pkg" || { echo "Failed to install $pkg"; continue; }
    else
        echo "$pkg is already installed, skipping."
    fi
done


# Setup Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Setting up Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed, skipping."
fi

# Clone dotfiles
if [ -d "$HOME/.config" ]; then
    echo "~/.config exists. Adding dotfiles contents into it..."
    git clone https://github.com/vylis/dotfiles "$HOME/.config/dotfiles" || { echo "Failed to clone dotfiles repo"; exit 1; }
    rsync -av --ignore-existing "$HOME/.config/dotfiles/" "$HOME/.config/"
    rm -rf "$HOME/.config/dotfiles"
else
    echo "~/.config doesn't exist. Creating new directory and installing configuration..."
    mkdir -p "$HOME/.config"
    git clone https://github.com/vylis/dotfiles ~/.config || { echo "Failed to clone dotfiles repo"; exit 1; }
fi

# Clone NeoVim config
if [ ! -d "$HOME/.config/nvim" ]; then
    echo "Cloning Neovim configuration..."
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
else
    echo "Neovim configuration already exists, skipping."
fi

# Source the updated ~/.zshrc
# zsh -c "source ~/.zshrc"
source ~/.zshrc

echo "Setup complete!"