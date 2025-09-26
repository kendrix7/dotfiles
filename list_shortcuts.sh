#!/bin/bash

echo "========================================="
echo "       MY DEVELOPMENT SHORTCUTS"
echo "========================================="
echo ""
echo "📁 PROJECT NAVIGATION:"
echo "  dotfiles     - Jump to dotfiles directory"
echo ""
echo "🔀 GIT SHORTCUTS:"
echo "  gcp 'msg'    - git add . && git commit -m 'msg' && git push"
echo ""
echo "🐳 DOCKER SERVICES:"
echo "  dev-services-down - Stop all development services"
echo ""
echo "🔑 TOKEN GENERATION:"
echo "  token-prod       - Generate token for prod environment"
echo ""
echo "📦 NPM SHORTCUTS:"
echo "  nrdn         - npm run dev:nodb"
echo ""
echo "🛠️  UTILITY SCRIPTS:"
echo "  update-shortcuts - Auto-update shortcuts list and push to git"
echo ""
echo "💡 TIPS:"
echo "  - All aliases are defined in ~/.zshrc"
echo "  - Run 'source ~/.zshrc' after editing shell config"
echo "  - Use 'which aliasname' to see what an alias does"
echo ""

echo "🔍 CURRENT STATUS:"
if [ -n "$NPM_TOKEN" ]; then
    echo "  ✅ NPM_TOKEN is set and ready"
else
    echo "  ❌ NPM_TOKEN not found"
fi

if command -v volta >/dev/null 2>&1; then
    echo "  ✅ Volta (Node manager) installed: $(volta --version)"
else
    echo "  ❌ Volta not found"
fi

if command -v code >/dev/null 2>&1; then
    echo "  ✅ VS Code CLI available"
else
    echo "  ❌ VS Code CLI not available"
fi

if command -v docker >/dev/null 2>&1; then
    echo "  ✅ Docker installed: $(docker --version | cut -d' ' -f3 | cut -d',' -f1)"
else
    echo "  ❌ Docker not installed"
fi

echo ""
echo "Run individual commands to test them out!"
