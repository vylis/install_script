#!/bin/bash

# Update and upgrade system packages
echo "Updating package database..."
sudo apt update && sudo apt upgrade -y

# Install packages via APT if not installed
apt_packages=(
    firefox
    httpie
    kitty

    curl
    fortune
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
    npm
    python3
    pipx
    gcc
    gdb
    make
    go
    sqlite3
)

for pkg in "${apt_packages[@]}"; do
    if ! dpkg -l | grep -qw "$pkg"; then
        echo "Installing $pkg..."
        sudo apt install -y "$pkg" || { echo "Failed to install $pkg"; continue; }
    else
        echo "$pkg is already installed, skipping."
    fi
done

# Install Snap if not installed
if ! command -v snap &>/dev/null; then
    echo "Snap is not installed. Installing Snap..."
    sudo apt install -y snapd
else
    echo "Snap is already installed, skipping."
fi

# Install packages via Snap if not installed
snap_packages=(
    bitwarden
    discord
    chromium
    spotify
    dbeaver-ce
    redisinsight
)

for snap_pkg in "${snap_packages[@]}"; do
    if ! snap list | grep -qw "$snap_pkg"; then
        echo "Installing Snap package $snap_pkg..."
        sudo snap install "$snap_pkg" || { echo "Failed to install Snap package $snap_pkg"; continue; }
    else
        echo "$snap_pkg is already installed via Snap, skipping."
    fi
done

# Install packages --classic via Snap if not installed
snap_packages_classic=(
    godot

    kubectl
    helm
    minikube
)

for snap_pkg in "${snap_packages_classic[@]}"; do
    if ! snap list | grep -qw "$snap_pkg"; then
        echo "Installing Snap package $snap_pkg..."
        sudo snap install "$snap_pkg" --classic || { echo "Failed to install Snap package $snap_pkg"; continue; }
    else
        echo "$snap_pkg is already installed via Snap, skipping."
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

# Install VS Code if not installed
if ! command -v code &>/dev/null; then
    echo "Installing VSCode..."
    sudo apt-get install -y wget gpg
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
    rm -f packages.microsoft.gpg
    sudo apt install -y apt-transport-https
    sudo apt update
    sudo apt install -y code # or code-insiders
else
    echo "Visual Studio Code is already installed, skipping."
fi

# Install Docker if not installed
if ! command -v docker &>/dev/null; then
    echo "Installing Docker..."
    for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo groupadd docker
    sudo usermod -aG docker $USER
    sudo chmod 666 /var/run/docker.sock
else
    echo "Docker is already installed, skipping."
fi

# Install Oh My Zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Setting up Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed, skipping."
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

# Check if /snap/bin is already in ~/.zshrc
if ! grep -q '/snap/bin' ~/.zshrc; then
    echo 'export PATH=$PATH:/snap/bin' >> ~/.zshrc
    echo "Added /snap/bin to PATH in ~/.zshrc"
else
    echo "/snap/bin is already in PATH in ~/.zshrc"
fi

# Check if "fortune | cowsay" is already in ~/.zshrc
if ! grep -q 'fortune | cowsay' ~/.zshrc; then
    echo 'fortune | cowsay' >> ~/.zshrc
    echo "Added 'fortune | cowsay' to ~/.zshrc"
else
    echo "'fortune | cowsay' is already in ~/.zshrc"
fi

# Source the updated ~/.zshrc
echo "Sourcing ~/.zshrc..."
source ~/.zshrc

echo "Setup complete!"