#!/bin/bash

# FIRST, GO TO VS CODE CMD + SHIFT + P
# CMD + SHIFT + P, AND SELECT INSTALL CODE COMMAND IN PATH

# List of extensions to install
extensions=(
    "aaron-bond.better-comments"
    "wayou.vscode-todo-highlight"
    "gruntfuggly.todo-tree"
    "christian-kohler.path-intellisense"
    "mcright.auto-save"
    "eamodio.gitlens"
    "donjayamanne.githistory"
    "usernamehw.errorlens"
    "ms-python.python"
    "ms-python.black-formatter"
    "esbenp.prettier-vscode"
    "dbaeumer.vscode-eslint"
    "ms-vscode.cpptools"
    "ms-vscode.makefile-tools"
    "ms-vscode.cmake-tools"
    "xaver.clang-format"
    "redis.redis-for-vscode"
    # "illixion.vscode-vibrancy-continued"
    "jdinhlife.gruvbox"
)

# Loop through the extensions and install them
for extension in "${extensions[@]}"; do
    echo "Installing $extension"
    code --install-extension $extension
done

echo "Extensions installed!"
