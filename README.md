# My Dotfiles

Personal configuration files for macOS development environment.

## Setup Instructions

1. Clone this repo: `git clone https://github.com/yourusername/dotfiles.git ~/dotfiles`
2. Run the setup script: `cd ~/dotfiles && ./install.sh`

## What's Included

- **Shell configurations**: `.bashrc`, `.zshrc`, `.zshenv`, `.zprofile`, `.profile`
- **Development tools**: `.gitconfig`, `.npmrc`, `.tool-versions` (asdf)
- **VS Code**: Settings, extensions, snippets, keybindings
- **iTerm2**: Preferences and profiles
- **SSH**: Configuration (keys not included)
- **FZF**: Shell integration
- **Package lists**: Homebrew and npm global packages

## Notes

- The install script creates symlinks for most dotfiles
- `.config` directory contents are copied (not symlinked)
- SSH config is copied with proper permissions
- Package installation may take some time
