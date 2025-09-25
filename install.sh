#!/bin/bash
echo "Setting up dotfiles..."

# Create symlinks for configs
ln -sf ~/dotfiles/.bashrc ~/.bashrc
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.zshenv ~/.zshenv  
ln -sf ~/dotfiles/.zprofile ~/.zprofile
ln -sf ~/dotfiles/.profile ~/.profile
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.npmrc ~/.npmrc
ln -sf ~/dotfiles/.fzf.bash ~/.fzf.bash
ln -sf ~/dotfiles/.fzf.zsh ~/.fzf.zsh

# Copy .config and SSH
mkdir -p ~/.config ~/.ssh
cp -r .config/* ~/.config/ 2>/dev/null
cp ssh/config ~/.ssh/config 2>/dev/null && chmod 600 ~/.ssh/config

# VS Code setup
mkdir -p ~/Library/Application\ Support/Code/User/
cp vscode/* ~/Library/Application\ Support/Code/User/ 2>/dev/null
cp -r vscode/snippets ~/Library/Application\ Support/Code/User/ 2>/dev/null

# iTerm2
cp iterm2/com.googlecode.iterm2.plist ~/Library/Preferences/

# Install Volta if needed
if ! command -v volta >/dev/null 2>&1; then
    curl https://get.volta.sh | bash
fi

echo "Setup complete! Restart terminal and run: volta install node"
git config --global push.autoSetupRemote true
