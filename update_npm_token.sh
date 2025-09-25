#!/bin/bash

# Script to update NPM_TOKEN in .env.local file
# Usage: ./update_npm_token.sh "your_new_token_here"

if [ $# -eq 0 ]; then
    echo "Usage: $0 <new_token>"
    echo "Example: $0 ghp_abc123xyz"
    exit 1
fi

NEW_TOKEN="$1"
ENV_LOCAL_FILE="$HOME/dotfiles/.env.local"

# Check if the new token looks like a GitHub token
if [[ ! $NEW_TOKEN =~ ^ghp_[A-Za-z0-9]{36}$ ]]; then
    echo "Warning: Token doesn't match expected GitHub token format (ghp_xxxxx)"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 1
    fi
fi

# Create .env.local file if it doesn't exist
if [ ! -f "$ENV_LOCAL_FILE" ]; then
    echo "Creating new .env.local file at $ENV_LOCAL_FILE"
    touch "$ENV_LOCAL_FILE"
fi

# Check if NPM_TOKEN variable already exists
if grep -q "^export NPM_TOKEN=" "$ENV_LOCAL_FILE"; then
    echo "Found existing NPM_TOKEN, replacing it..."
    # Use sed to replace the existing line
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS version
        sed -i '' "s/^export NPM_TOKEN=.*/export NPM_TOKEN=\"$NEW_TOKEN\"/" "$ENV_LOCAL_FILE"
    else
        # Linux version
        sed -i "s/^export NPM_TOKEN=.*/export NPM_TOKEN=\"$NEW_TOKEN\"/" "$ENV_LOCAL_FILE"
    fi
else
    echo "Adding new NPM_TOKEN variable..."
    echo "export NPM_TOKEN=\"$NEW_TOKEN\"" >> "$ENV_LOCAL_FILE"
fi

# Set proper permissions
chmod 600 "$ENV_LOCAL_FILE"

echo "Token updated successfully!"
echo "Run 'source ~/.zshrc' to reload your environment."

# Verify the update
echo ""
echo "Current .env.local contents:"
cat "$ENV_LOCAL_FILE"
