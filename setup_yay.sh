#!/bin/bash

# Update and upgrade system packages
echo "Updating package database..."
yay -Syu --noconfirm

# Install packages via Yay if not installed
yay_packages=(
    bitwarden
    firefox
    discord
    google-chrome
    spotify
    dbeaver
    httpie
    kitty
    code
    godot

    curl
    fortune-mod
    cowsay
    fzf
    git
    htop
    neofetch
    neovim
    emacs
    ranger
    tmux
    zsh
    nmap
    wireshark
    nodejs
    python
    python-pip
    pipx
    gcc
    gdb
    make
    go
    sqlite
    docker
    docker-compose
    kubectl
    helm
    minikube
)

for pkg in "${yay_packages[@]}"; do
    if ! yay -Q "$pkg" &>/dev/null; then
        echo "Installing $pkg..."
        yay -S --noconfirm "$pkg" || { echo "Failed to install $pkg"; continue; }
    else
        echo "$pkg is already installed, skipping."
    fi
done

# Install Poetry via pipx if not installed
if ! command -v poetry &>/dev/null; then
    echo "Installing Poetry with pipx..."
    pipx install poetry
    pipx ensurepath
else
    echo "Poetry is already installed, skipping."
fi

# Install Rust via rustup if not installed
if ! command -v rustup &>/dev/null; then
    echo "Installing Rust via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
else
    echo "Rust is already installed, skipping."
fi

# Clone dotfiles and sync them
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

# Clone NeoVim config if not installed
if [ ! -d "$HOME/.config/nvim" ]; then
    echo "Cloning Neovim configuration..."
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
else
    echo "Neovim configuration already exists, skipping."
fi

# Clone Doom Emacs if not installed
if [ ! -d "$HOME/.config/emacs" ]; then
    echo "Cloning Doom Emacs..."
    git clone https://github.com/doomemacs/doomemacs ~/.config/emacs --depth 1

    # Install Doom Emacs
    echo "Installing Doom Emacs..."
    ~/.config/emacs/bin/doom install
else
    echo "Doom Emacs is already installed, skipping."
fi

# Install Oh My Zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Setting up Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed, skipping."
fi

# Check if "fortune | cowsay" is already in ~/.zshrc
if ! grep -q 'fortune | cowsay' ~/.zshrc; then
    echo 'fortune | cowsay' >> ~/.zshrc
    echo "Added 'fortune | cowsay' to ~/.zshrc"
else
    echo "'fortune | cowsay' is already in ~/.zshrc"
fi

# Set zsh as default shell
chsh -s $(which zsh)

# Source the updated ~/.zshrc
echo "Sourcing ~/.zshrc..."
source ~/.zshrc

echo "Setup complete!"
