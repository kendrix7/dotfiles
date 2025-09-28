#!/bin/bash

SHORTCUTS_FILE="$HOME/dotfiles/list_shortcuts.sh"
ZSHRC_FILE="$HOME/.zshrc"
DOTFILES_DIR="$HOME/dotfiles"

# Create the shortcuts script header
cat > "$SHORTCUTS_FILE" << 'HEADER'
#!/bin/bash
echo "========================================="
echo "       MY DEVELOPMENT SHORTCUTS"
echo "========================================="
echo ""
HEADER

# 🌐 FRONTEND ENVIRONMENTS SECTION
echo 'echo "🌐 FRONTEND ENVIRONMENTS:"' >> "$SHORTCUTS_FILE"
frontend_functions=$(grep -E "^frontend-[a-zA-Z0-9_-]+\(\)" "$ZSHRC_FILE" | sed 's/().*//')
if [ -n "$frontend_functions" ]; then
    echo "$frontend_functions" | while read -r func_name; do
        case "$func_name" in
            frontend-local) echo 'echo "  frontend-local   - Start frontend with local backend"' >> "$SHORTCUTS_FILE" ;;
            frontend-dev) echo 'echo "  frontend-dev     - Start frontend with dev backend"' >> "$SHORTCUTS_FILE" ;;
            frontend-stage) echo 'echo "  frontend-stage   - Start frontend with stage backend"' >> "$SHORTCUTS_FILE" ;;
            frontend-branch) echo 'echo "  frontend-branch  - Start frontend with branch backend: frontend-branch <name>"' >> "$SHORTCUTS_FILE" ;;
            frontend-status) echo 'echo "  frontend-status  - Check frontend environment status"' >> "$SHORTCUTS_FILE" ;;
            *) echo "echo \"  $func_name    - Frontend function\"" >> "$SHORTCUTS_FILE" ;;
        esac
    done
fi

echo 'echo ""' >> "$SHORTCUTS_FILE"
# 🚀 BACKEND ENVIRONMENT SECTION
echo 'echo "🚀 BACKEND ENVIRONMENT:"' >> "$SHORTCUTS_FILE"
backend_functions=$(grep -E "^backend-[a-zA-Z0-9_-]+\(\)" "$ZSHRC_FILE" | sed 's/().*//')
if [ -n "$backend_functions" ]; then
    echo "$backend_functions" | while read -r func_name; do
        case "$func_name" in
            backend-start) echo 'echo "  backend-start    - Start backend with current environment and VS Code"' >> "$SHORTCUTS_FILE" ;;
            *) echo "echo \"  $func_name    - Backend function\"" >> "$SHORTCUTS_FILE" ;;
        esac
    done
fi

echo 'echo ""' >> "$SHORTCUTS_FILE"
echo 'echo "📁 PROJECT NAVIGATION:"' >> "$SHORTCUTS_FILE"

nav_aliases=$(grep -E "^alias [a-zA-Z0-9_-]+='cd [^&]*'$" "$ZSHRC_FILE" | sed "s/alias \([^=]*\)=.*/\1/")
if [ -n "$nav_aliases" ]; then
    echo "$nav_aliases" | while read -r alias_name; do
        nav_command=$(grep "^alias $alias_name=" "$ZSHRC_FILE" | sed "s/alias $alias_name='//;s/'$//" | sed "s/alias $alias_name=\"//;s/\"$//")
        dir_path=$(echo "$nav_command" | sed 's/cd //')
        
        padded_name=$(printf "%-12s" "$alias_name")
        
        case "$alias_name" in
            root) echo "echo \"  $padded_name - Jump to home directory\"" >> "$SHORTCUTS_FILE" ;;
            work) echo "echo \"  $padded_name - Jump to work projects directory\"" >> "$SHORTCUTS_FILE" ;;
            *) echo "echo \"  $padded_name - Jump to $dir_path\"" >> "$SHORTCUTS_FILE" ;;
        esac
    done
fi

echo 'echo ""' >> "$SHORTCUTS_FILE"
echo 'echo "🔀 GIT SHORTCUTS:"' >> "$SHORTCUTS_FILE"

git_aliases=$(grep -E "^alias [a-zA-Z0-9_-]+=.*git " "$ZSHRC_FILE" | sed "s/alias \([^=]*\)=.*/\1/")
if [ -n "$git_aliases" ]; then
    echo "$git_aliases" | while read -r alias_name; do
        git_command=$(grep "^alias $alias_name=" "$ZSHRC_FILE" | sed "s/alias $alias_name='//;s/'$//" | sed "s/alias $alias_name=\"//;s/\"$//")
        
        padded_name=$(printf "%-12s" "$alias_name")
        
        if [[ "$git_command" == *"function"* ]]; then
            case "$alias_name" in
                gcp) echo "echo \"  $padded_name - git add, commit, and push\"" >> "$SHORTCUTS_FILE" ;;
                *) echo "echo \"  $padded_name - custom git function\"" >> "$SHORTCUTS_FILE" ;;
            esac
        else
            echo "echo \"  $padded_name - $git_command\"" >> "$SHORTCUTS_FILE"
        fi
    done
fi

echo 'echo ""' >> "$SHORTCUTS_FILE"
echo 'echo "🐳 DOCKER SERVICES:"' >> "$SHORTCUTS_FILE"

docker_aliases=$(grep -E "^alias [a-zA-Z0-9_-]+=.*docker-compose (up|down)" "$ZSHRC_FILE" | sed "s/alias \([^=]*\)=.*/\1/")

compound_docker_aliases=$(grep -E "^alias (dev-services|all-services)" "$ZSHRC_FILE" | sed "s/alias \([^=]*\)=.*/\1/")

all_docker_aliases=$(echo -e "$docker_aliases\n$compound_docker_aliases" | grep -v '^$')

if [ -n "$all_docker_aliases" ]; then
    echo "$all_docker_aliases" | while read -r alias_name; do
        docker_command=$(grep "^alias $alias_name=" "$ZSHRC_FILE" | sed "s/alias $alias_name='//;s/'$//" | sed "s/alias $alias_name=\"//;s/\"$//")
        
        padded_name=$(printf "%-17s" "$alias_name")
        
        if [[ "$alias_name" == *"-up" ]]; then
            service_name=$(echo "$alias_name" | sed 's/-up$//')
            case "$service_name" in
                dev-services) echo "echo \"  $padded_name - Start all development services\"" >> "$SHORTCUTS_FILE" ;;
                *) echo "echo \"  $padded_name - Start $service_name container\"" >> "$SHORTCUTS_FILE" ;;
            esac
        elif [[ "$alias_name" == *"-down" ]]; then
            service_name=$(echo "$alias_name" | sed 's/-down$//')
            case "$service_name" in
                dev-services) echo "echo \"  $padded_name - Stop all development services\"" >> "$SHORTCUTS_FILE" ;;
                *) echo "echo \"  $padded_name - Stop $service_name container\"" >> "$SHORTCUTS_FILE" ;;
            esac
        else
            echo "echo \"  $padded_name - $docker_command\"" >> "$SHORTCUTS_FILE"
        fi
    done
fi

echo 'echo ""' >> "$SHORTCUTS_FILE"
echo 'echo "🔑 TOKEN GENERATION:"' >> "$SHORTCUTS_FILE"

for alias_name in token-local token-dev token-stage token-prod; do
    if grep -q "^alias $alias_name=" "$ZSHRC_FILE"; then
        case "$alias_name" in
            token-local) echo 'echo "  token-local      - Generate token for local environment"' >> "$SHORTCUTS_FILE" ;;
            token-dev) echo 'echo "  token-dev        - Generate token for dev environment"' >> "$SHORTCUTS_FILE" ;;
            token-stage) echo 'echo "  token-stage      - Generate token for stage environment"' >> "$SHORTCUTS_FILE" ;;
            token-prod) echo 'echo "  token-prod       - Generate token for prod environment"' >> "$SHORTCUTS_FILE" ;;
        esac
    fi
done

echo 'echo ""' >> "$SHORTCUTS_FILE"
echo 'echo "📦 NPM SHORTCUTS:"' >> "$SHORTCUTS_FILE"

npm_aliases=$(grep -E "^alias [a-zA-Z0-9_-]+=.*npm run " "$ZSHRC_FILE" | sed "s/alias \([^=]*\)=.*/\1/")
if [ -n "$npm_aliases" ]; then
    echo "$npm_aliases" | while read -r alias_name; do
        npm_command=$(grep "^alias $alias_name=" "$ZSHRC_FILE" | sed "s/alias $alias_name='//;s/'$//" | sed "s/alias $alias_name=\"//;s/\"$//")
        
        padded_name=$(printf "%-12s" "$alias_name")
        
        script_name=$(echo "$npm_command" | sed 's/npm run //')
        
        case "$script_name" in
            start) echo "echo \"  $padded_name - npm run start\"" >> "$SHORTCUTS_FILE" ;;
            test) echo "echo \"  $padded_name - npm run test\"" >> "$SHORTCUTS_FILE" ;;
            dev) echo "echo \"  $padded_name - npm run dev\"" >> "$SHORTCUTS_FILE" ;;
            build) echo "echo \"  $padded_name - npm run build\"" >> "$SHORTCUTS_FILE" ;;
            *) echo "echo \"  $padded_name - npm run $script_name\"" >> "$SHORTCUTS_FILE" ;;
        esac
    done
fi

echo 'echo ""' >> "$SHORTCUTS_FILE"
echo 'echo "📋 CLIPBOARD UTILITIES:"' >> "$SHORTCUTS_FILE"

for alias_name in copy-setup copy-screenshot; do
    if grep -q "^alias $alias_name=" "$ZSHRC_FILE"; then
        case "$alias_name" in
            copy-setup) echo 'echo "  copy-setup       - Copy full development environment context to clipboard"' >> "$SHORTCUTS_FILE" ;;
            copy-screenshot) echo 'echo "  copy-screenshot  - Copy most recent screenshot to clipboard"' >> "$SHORTCUTS_FILE" ;;
        esac
    fi
done

echo 'echo ""' >> "$SHORTCUTS_FILE"
echo 'echo "🛠️  UTILITY SCRIPTS:"' >> "$SHORTCUTS_FILE"

echo 'echo "  dev-status       - Check development environment status (-v for verbose)"' >> "$SHORTCUTS_FILE"
echo 'echo "  update-shortcuts - Auto-update shortcuts list and push to git"' >> "$SHORTCUTS_FILE"
echo 'echo "  add-alias        - Add new alias: add-alias <name> <command>"' >> "$SHORTCUTS_FILE"
echo 'echo "  remove-alias     - Remove alias: remove-alias <name>"' >> "$SHORTCUTS_FILE"

for alias_name in screenshots dotfiles-push reload shortcuts; do
    if grep -q "^alias $alias_name=" "$ZSHRC_FILE"; then
        case "$alias_name" in
            screenshots) echo 'echo "  screenshots      - Open screenshots folder"' >> "$SHORTCUTS_FILE" ;;
            dotfiles-push) echo 'echo "  dotfiles-push    - Commit and push dotfiles changes"' >> "$SHORTCUTS_FILE" ;;
            reload) echo 'echo "  reload           - Reload shell configuration"' >> "$SHORTCUTS_FILE" ;;
            shortcuts) echo 'echo "  shortcuts        - Display this help menu"' >> "$SHORTCUTS_FILE" ;;
        esac
    fi
done

if grep -q "killport()" "$ZSHRC_FILE"; then
    echo 'echo "  killport 3000    - Kill process on port 3000"' >> "$SHORTCUTS_FILE"
fi

cat >> "$SHORTCUTS_FILE" << 'FOOTER'
echo ""
echo "💡 TIPS:"
echo "  - All aliases and functions are defined in ~/.zshrc"
echo "  - Run 'source ~/.zshrc' after editing shell config"
echo "  - Use 'which aliasname' to see what an alias does"
echo "  - Use 'declare -f functionname' to see function definition"
echo "  - Run 'dev-status' for environment health check"
echo ""
echo "Run individual commands to test them out!"
FOOTER

chmod +x "$SHORTCUTS_FILE"

cd "$DOTFILES_DIR"
if ! git diff --quiet HEAD -- list_shortcuts.sh 2>/dev/null; then
    echo "📝 Changes detected, committing to git..."
    git add list_shortcuts.sh
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    git commit -m "Auto-update shortcuts list - $TIMESTAMP"
    
    if git remote get-url origin &> /dev/null; then
        echo "📤 Pushing changes to GitHub..."
        git push
        echo "✅ Changes pushed to GitHub successfully!"
    fi
else
    echo "📋 No changes detected in shortcuts"
fi

echo "✅ Shortcuts list updated successfully!"
