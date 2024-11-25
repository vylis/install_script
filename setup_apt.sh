#!/bin/bash

# Update package manager
echo "Updating package database..."
sudo apt update && sudo apt upgrade -y

# Install packages via APT
apt_packages=(
    # bitwarden
    firefox
    # discord
    # google-chrome
    # spotify
    # dbeaver
    httpie
    kitty
    # redisinsight
    # code           
    # godot
    
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
    python3
    python3-pip
    pipx
    poetry
    rustc
    cargo
    gcc
    gdb
    make
    ninja
    go
    docker
    kubectl
    helm
    sqlite3        
    redis
)

for pkg in "${apt_packages[@]}"; do
    if ! dpkg -l | grep -qw "$pkg"; then
        echo "Installing $pkg..."
        sudo apt install -y "$pkg" || { echo "Failed to install $pkg"; continue; }
    else
        echo "$pkg is already installed, skipping."
    fi
done

# Install Snap if it's not installed
if ! command -v snap &>/dev/null; then
    echo "Snap is not installed. Installing Snap..."
    sudo apt install -y snapd
else
    echo "Snap is already installed, skipping."
fi

# Install packages via Snap
snap_packages=(
    bitwarden
    discord
    google-chrome
    spotify
    dbeaver
    redisinsight
    code
    godot
)

for snap_pkg in "${snap_packages[@]}"; do
    if ! snap list | grep -qw "$snap_pkg"; then
        echo "Installing Snap package $snap_pkg..."
        sudo snap install "$snap_pkg" || { echo "Failed to install Snap package $snap_pkg"; continue; }
    else
        echo "$snap_pkg is already installed via Snap, skipping."
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