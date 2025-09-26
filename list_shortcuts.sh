#!/bin/bash

# Script to list all custom aliases and scripts with descriptions
# Usage: ./list_shortcuts.sh

echo "========================================="
echo "       MY DEVELOPMENT SHORTCUTS"
echo "========================================="
echo ""

echo "📁 PROJECT NAVIGATION:"
echo "  cdpui        - Jump to cdp-ui project directory"
echo "  cdpbe        - Jump to cdp-behind-service project directory"
echo "  work         - Jump to work projects directory"
echo "  compose      - Jump to docker-compose services directory"
echo ""

echo "🔀 GIT SHORTCUTS:"
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

echo "🐳 DOCKER SERVICES:"
echo "  redis-up         - Start Redis container"
echo "  redis-down       - Stop Redis container"
echo "  postgres-up      - Start PostgreSQL container"
echo "  postgres-down    - Stop PostgreSQL container"
echo "  kafka-up         - Start Kafka ecosystem (takes longer)"
echo "  kafka-down       - Stop Kafka ecosystem"
echo "  dev-services-up  - Start all development services"
echo "  dev-services-down - Stop all development services"
echo ""

echo "📦 NPM SHORTCUTS:"
echo "  nrs          - npm run start"
echo "  nrt          - npm run test"
echo "  nrtu         - npm run test:unit"
echo "  nrdn         - npm run dev:nodb"
echo ""

echo "🛠️  UTILITY SCRIPTS:"
echo "  killport 3000       - Kill whatever process is running on port 3000"
echo "  update_npm_token.sh - Update NPM token in .env.local file securely"
echo "  list_shortcuts.sh   - Display this help menu"
echo ""

echo "💡 TIPS:"
echo "  - All aliases are defined in ~/.zshrc"
echo "  - Sensitive tokens are stored in ~/dotfiles/.env.local"
echo "  - Run 'source ~/.zshrc' after editing shell config"
echo "  - Use 'which aliasname' to see what an alias does"
echo ""

# Show current environment status
echo "🔍 CURRENT STATUS:"
if [ -n "$NPM_TOKEN" ]; then
    echo "  ✅ NPM_TOKEN is set and ready"
else
    echo "  ❌ NPM_TOKEN not found - run update_npm_token.sh"
fi

if command -v volta >/dev/null 2>&1; then
    echo "  ✅ Volta (Node manager) installed: $(volta --version)"
else
    echo "  ❌ Volta not found"
fi

if command -v code >/dev/null 2>&1; then
    echo "  ✅ VS Code CLI available"
else
    echo "  ❌ VS Code CLI not available - install via Command Palette"
fi

if command -v docker >/dev/null 2>&1; then
    echo "  ✅ Docker installed: $(docker --version | cut -d' ' -f3 | cut -d',' -f1)"
else
    echo "  ❌ Docker not installed"
fi

echo ""
echo "Run individual commands to test them out!"
