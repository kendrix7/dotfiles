#!/bin/bash

# Script to list all custom aliases and scripts with descriptions
# Usage: ./list_shortcuts.sh

echo "========================================="
echo "       MY DEVELOPMENT SHORTCUTS"
echo "========================================="
echo ""

echo "PROJECT NAVIGATION:"
echo "  cdpui        - Jump to cdp-ui project directory"
echo "  cdpbe        - Jump to cdp-behind-service project directory"
echo "  work         - Jump to work projects directory"
echo ""

echo "GIT SHORTCUTS:"
echo "  gs           - git status"
echo "  ga           - git add"
echo "  gc 'msg'     - git commit -m 'msg'"
echo "  gp           - git push"
echo "  gl           - git pull"
echo "  gco          - git checkout"
echo "  gb           - git branch"
echo "  gd           - git diff"
echo "  glog         - git log --oneline --graph"
echo "  gcp 'msg'    - git add . && git commit -m 'msg' && git push (all-in-one)"
echo ""

echo "NPM SHORTCUTS:"
echo "  nrs          - npm run start"
echo "  nrt          - npm run test"
echo "  nrtu         - npm run test:unit"
echo "  nrdn         - npm run dev:nodb"
echo ""

echo "UTILITY SCRIPTS:"
echo "  reload              - Reload shell configuration (.zshrc)"
echo "  killport 3000       - Kill whatever process is running on port 3000"
echo "  updatetoken <token> - Update NPM token in .env.local file securely in .env.local file securely"
echo "  list_shortcuts.sh   - Display this help menu"
echo ""

echo "TIPS:"
echo "  - All aliases are defined in ~/.zshrc"
echo "  - Sensitive tokens are stored in ~/dotfiles/.env.local"
echo "  - Run 'source ~/.zshrc' after editing shell config"
echo "  - Use 'which aliasname' to see what an alias does"
