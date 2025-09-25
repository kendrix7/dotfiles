#!/bin/bash

# Dotfiles installation script
echo "Setting up dotfiles..."

# Create symlinks for shell and environment configs
ln -sf ~/dotfiles/.bashrc ~/.bashrc
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.zshenv ~/.zshenv
ln -sf ~/dotfiles/.zprofile ~/.zprofile
ln -sf ~/dotfiles/.profile ~/.profile
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.npmrc ~/.npmrc
ln -sf ~/dotfiles/.tool-versions ~/.tool-versions
ln -sf ~/dotfiles/.fzf.bash ~/.fzf.bash
ln -sf ~/dotfiles/.fzf.zsh ~/.fzf.zsh

# Copy .config directory (some tools don't like symlinks)
echo "Setting up .config directory..."
mkdir -p ~/.config
cp -r .config/* ~/.config/ 2>/dev/null || echo "No .config files to copy"

# SSH config setup
echo "Setting up SSH config..."
mkdir -p ~/.ssh
cp ssh/config ~/.ssh/config 2>/dev/null || echo "No SSH config to copy"
chmod 600 ~/.ssh/config 2>/dev/null

# VS Code setup
echo "Setting up VS Code..."
mkdir -p ~/Library/Application\ Support/Code/User/

cp vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
cp vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json

# Copy snippets if they exist
if [ -d "vscode/snippets" ]; then
    cp -r vscode/snippets ~/Library/Application\ Support/Code/User/
fi

# Install VS Code extensions
if [ -f "vscode/extensions.txt" ]; then
    echo "Installing VS Code extensions..."
    while read extension; do
        code --install-extension $extension
    done < vscode/extensions.txt
fi

# iTerm2 setup
echo "Setting up iTerm2..."
cp iterm2/com.googlecode.iterm2.plist ~/Library/Preferences/
echo "Note: You may need to restart iTerm2 to see the settings"

# Install Homebrew packages
if [ -f "brew_packages.txt" ]; then
    echo "Installing Homebrew packages..."
    echo "This might take a while..."
    while read package; do
        brew install $package 2>/dev/null || echo "Skipped $package (already installed or unavailable)"
    done < brew_packages.txt
fi

# Install global npm packages
if [ -f "npm_global_packages.txt" ]; then
    echo "Installing global npm packages..."
    # Extract package names from npm list output
    grep -E "^├──|^└──" npm_global_packages.txt | sed 's/^[├└]── //' | cut -d'@' -f1 | while read package; do
        npm install -g $package 2>/dev/null || echo "Skipped $package"
    done
fi

echo "Dotfiles setup complete!"
echo "Don't forget to:"
echo "1. Restart your terminal"
echo "2. Restart iTerm2"
echo "3. Reload VS Code"
echo "4. If you use asdf, run 'asdf reshim' to refresh shims"
