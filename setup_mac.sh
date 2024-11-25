#!/bin/bash

# Install Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "Please complete the installation and then re-run this script."
    exit 1
fi

# Install Homebrew if it's not installed
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || { echo "Homebrew installation failed"; exit 1; }
fi

# Update package manager
echo "Updating package database..."
brew update && brew upgrade

# Install packages via Brew
brew_packages=(
    koekeishiya/formulae/yabai
    koekeishiya/formulae/skhd
    cmacrae/formulae/spacebar

    bitwarden
    firefox
    discord
    google-chrome
    spotify
    dbeaver-community
    httpie
    kitty
    redisinsight
    visual-studio-code
    godot
    
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
    node
    python@3.13
    pipx
    gcc
    gdb
    make
    ninja
    go
    sqlite
    kubectl
    helm
    docker
    docker-compose
)

for pkg in "${brew_packages[@]}"; do
    if ! brew list "$pkg" &>/dev/null; then
        echo "Installing $pkg..."
        brew install "$pkg" || { echo "Failed to install $pkg"; continue; }
    else
        echo "$pkg is already installed, skipping."
    fi
done

# Install Poetry with pipx
pipx install poetry
pipx ensurepath

# Install Rust using rustup 
if ! command -v rustup &>/dev/null; then
    echo "Installing Rust via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
else
    echo "Rust is already installed, skipping."
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

# Symlink python3 and pip3 if they do not already exist
if [ ! -L /usr/local/bin/python ]; then
    echo "Creating symlink for python..."
    ln -s /usr/local/bin/python3.13 /usr/local/bin/python
fi

if [ ! -L /usr/local/bin/pip ]; then
    echo "Creating symlink for pip..."
    ln -s /usr/local/bin/pip3 /usr/local/bin/pip
fi

# Source the updated ~/.zshrc
# zsh -c "source ~/.zshrc"
source ~/.zshrc

# Start yabai, skhd and spacebar services
echo "Starting yabai, skhd and spacebar..."
yabai --start-service || { echo "Failed to start yabai"; }
skhd --start-service || { echo "Failed to start skhd"; }
brew services start spacebar || { echo "Failed to start spacebar service"; }

echo "Setup complete!"
