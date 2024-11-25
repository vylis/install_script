#!/bin/bash

# Update package manager
echo "Updating package database..."
sudo apt update && sudo apt upgrade -y

# Install packages via APT
apt_packages=(
    firefox
    httpie
    kitty

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
    npm
    python3
    pipx
    gcc
    gdb
    make
    ninja
    go
    sqlite3     
    kubectl
    helm   
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
    dbeaver-ce
    redisinsight
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

# Install Poetry with pipx
pipx install poetry
pipx ensurepath

# Install Rust using rustup (not via APT)
if ! command -v rustup &>/dev/null; then
    echo "Installing Rust via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
else
    echo "Rust is already installed, skipping."
fi

# Install VSCode if it's not already installed
if ! command -v code &>/dev/null; then
    echo "Installing VSCode..."
    sudo apt-get install wget gpg
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
    rm -f packages.microsoft.gpg
    sudo apt install apt-transport-https
    sudo apt update
    sudo apt install code # or code-insiders
else
    echo "VSCode is already installed, skipping."
fi

# Install Docker if it's not already installed
if ! command -v docker &>/dev/null; then
    echo "Installing Docker..."
    for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker
    sudo chmod 666 /var/run/docker.sock
else
    echo "Docker is already installed, skipping."
fi

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