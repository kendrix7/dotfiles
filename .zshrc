# Path configuration
export PATH="$HOME/.volta/bin:$HOME/bin:/usr/local/bin:$PATH"

# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="fino-time"
plugins=(git web-search)
source $ZSH/oh-my-zsh.sh

# Load local environment
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source ~/dotfiles/.env.local 2>/dev/null || true

# =============================================================================
# PROJECT NAVIGATION
# =============================================================================
alias cdpui='cd ~/code/work/cdp-ui'
alias cdpbe='cd ~/code/work/cdp-behind-service'
alias work='cd ~/code/work'
alias compose='cd ~/code/work/docker-compose'
alias dotfiles='cd ~/dotfiles'

# =============================================================================
# GIT SHORTCUTS
# =============================================================================
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias glog='git log --oneline --graph'
alias gcp='function _gcp() { git add . && git commit -m "$1" && git push; }; _gcp'

# =============================================================================
# NPM SHORTCUTS
# =============================================================================
alias nrs='npm run start'
alias nrt='npm run test'
alias nrtu='npm run test:unit'
alias nrdn='npm run dev:nodb'

# =============================================================================
# DOCKER SERVICES
# =============================================================================
alias redis-up='cd ~/code/work/docker-compose/Redis && docker-compose up -d'
alias redis-down='cd ~/code/work/docker-compose/Redis && docker-compose down'
alias postgres-up='cd ~/code/work/docker-compose/Postgres && docker-compose up -d'
alias postgres-down='cd ~/code/work/docker-compose/Postgres && docker-compose down'
alias kafka-up='cd ~/code/work/docker-compose/Kafka && docker-compose up -d'
alias kafka-down='cd ~/code/work/docker-compose/Kafka && docker-compose down'
alias dev-services-up='redis-up && postgres-up && kafka-up'
alias dev-services-down='redis-down && postgres-down && kafka-down'

# =============================================================================
# TOKEN GENERATION
# =============================================================================
alias token-local='cd ~/code/work/cdp-behind-service && ./bin/admin token --env local'
alias token-dev='cd ~/code/work/cdp-behind-service && ./bin/admin token --env dev'
alias token-stage='cd ~/code/work/cdp-behind-service && ./bin/admin token --env stage'
alias token-prod='cd ~/code/work/cdp-behind-service && ./bin/admin token --env prod'

# =============================================================================
# UTILITY SHORTCUTS
# =============================================================================
alias killport='function _killport() { lsof -ti:$1 | xargs kill -9; }; _killport'
alias shortcuts="~/dotfiles/list_shortcuts.sh"
alias updatetoken="~/dotfiles/update_npm_token.sh"
alias reload="source ~/.zshrc"
alias update-shortcuts='~/dotfiles/update_shortcuts.sh'
alias dev-status='~/dotfiles/dev_status.sh'
alias copy-setup='cat ~/dotfiles/ai-setup-context.md | pbcopy && echo "✅ Development setup context copied to clipboard!"'
alias copy-screenshot='~/dotfiles/copy_latest_screenshot.sh'

# =============================================================================
# ALIAS MANAGEMENT FUNCTIONS
# =============================================================================
add-alias() {
    if [ $# -ne 2 ]; then
        echo "Usage: add-alias <alias_name> <command>"
        echo "Example: add-alias ll 'ls -la'"
        return 1
    fi
    
    local alias_name="$1"
    local command="$2"
    
    echo "alias $alias_name='$command'" >> ~/dotfiles/.zshrc
    source ~/dotfiles/.zshrc
    echo "✅ Added alias: $alias_name -> $command"
    echo "🔄 Updating shortcuts list..."
    update-shortcuts
}

remove-alias() {
    if [ $# -ne 1 ]; then
        echo "Usage: remove-alias <alias_name>"
        echo "Example: remove-alias ll"
        return 1
    fi
    
    local alias_name="$1"
    
    if ! grep -q "^alias $alias_name=" ~/dotfiles/.zshrc; then
        echo "❌ Alias '$alias_name' not found in .zshrc"
        return 1
    fi
    
    sed -i.bak "/^alias $alias_name=/d" ~/dotfiles/.zshrc
    unalias "$alias_name" 2>/dev/null
    echo "✅ Removed alias: $alias_name"
    echo "🔄 Updating shortcuts list..."
    update-shortcuts
}

# =============================================================================
# IDEAS MANAGEMENT
# =============================================================================
idea() {
    local IDEAS_FILE="$HOME/dotfiles/ideas.txt"
    
    if [ ! -f "$IDEAS_FILE" ]; then
        touch "$IDEAS_FILE"
    fi
    
    if [ "$1" = "rm" ] && [ -n "$2" ]; then
        local line_num="$2"
        local total_lines=$(wc -l < "$IDEAS_FILE")
        
        if ! [[ "$line_num" =~ ^[0-9]+$ ]]; then
            echo "Error: Please provide a valid line number"
            return 1
        fi
        
        if [ "$line_num" -lt 1 ] || [ "$line_num" -gt "$total_lines" ]; then
            echo "Error: Line number must be between 1 and $total_lines"
            return 1
        fi
        
        local deleted_idea=$(sed -n "${line_num}p" "$IDEAS_FILE")
        echo "Deleting idea #$line_num: $deleted_idea"
        sed -i '' "${line_num}d" "$IDEAS_FILE"
        echo "Idea deleted successfully"
        return 0
    fi
    
    if [ $# -eq 0 ]; then
        if [ ! -s "$IDEAS_FILE" ]; then
            echo "No ideas yet. Add one with: idea \"your idea here\""
            echo "Delete ideas with: idea rm <number>"
            return 0
        fi
        
        echo "=== MY WORKFLOW IDEAS ==="
        cat -n "$IDEAS_FILE"
        echo ""
        echo "Total ideas: $(wc -l < "$IDEAS_FILE")"
        echo "Delete with: idea rm <number>"
    else
        local NEW_IDEA="$*"
        echo "$(date '+%Y-%m-%d') - $NEW_IDEA" >> "$IDEAS_FILE"
        echo "Added idea: $NEW_IDEA"
    fi
}

# =============================================================================
# FRONTEND ENVIRONMENT FUNCTIONS
# =============================================================================
backup_and_modify_frontend_env() {
    local env_file="$HOME/code/work/cdp-ui/.env"
    local backup_file="$HOME/code/work/cdp-ui/.env.backup"
    
    if [ ! -f "$backup_file" ]; then
        cp "$env_file" "$backup_file"
        echo "📋 Created backup of original .env"
    fi
}

frontend-local() {
    echo "🚀 Starting frontend with LOCAL backend..."
    backup_and_modify_frontend_env
    
    cd ~/code/work/cdp-ui
    
    # Check if VS Code is available and project isn't already open
    if command -v code &> /dev/null; then
        if ! pgrep -f "Visual Studio Code.*cdp-ui" > /dev/null; then
            code .
            echo "📝 Opened in VS Code"
        else
            echo "📝 Already open in VS Code"
        fi
    fi
    
    sed -i.tmp 's/^VITE_BEHIND_SERVICE_API_URL=/#VITE_BEHIND_SERVICE_API_URL=/' .env
    sed -i.tmp 's/^# VITE_BEHIND_SERVICE_API_URL=http:\/\/localhost:3001/VITE_BEHIND_SERVICE_API_URL=http:\/\/localhost:3001/' .env
    sed -i.tmp 's/^#VITE_BEHIND_SERVICE_API_URL=http:\/\/localhost:3001/VITE_BEHIND_SERVICE_API_URL=http:\/\/localhost:3001/' .env
    
    rm .env.tmp
    echo "✅ Frontend configured for LOCAL backend"
    npm run start
}

frontend-dev() {
    echo "🚀 Starting frontend with DEV backend..."
    backup_and_modify_frontend_env
    
    cd ~/code/work/cdp-ui
    
    # Check if VS Code is available and project isn't already open
    if command -v code &> /dev/null; then
        if ! pgrep -f "Visual Studio Code.*cdp-ui" > /dev/null; then
            code .
            echo "📝 Opened in VS Code"
        else
            echo "📝 Already open in VS Code"
        fi
    fi
    
    sed -i.tmp 's/^VITE_BEHIND_SERVICE_API_URL=/#VITE_BEHIND_SERVICE_API_URL=/' .env
    sed -i.tmp 's/^#VITE_BEHIND_SERVICE_API_URL=https:\/\/cdp-behind-service\.dev\.platform\.aws\.chgit\.com/VITE_BEHIND_SERVICE_API_URL=https:\/\/cdp-behind-service.dev.platform.aws.chgit.com/' .env
    
    rm .env.tmp
    echo "✅ Frontend configured for DEV backend"
    npm run start
}

frontend-stage() {
    echo "🚀 Starting frontend with STAGE backend..."
    backup_and_modify_frontend_env
    
    cd ~/code/work/cdp-ui
    
    # Check if VS Code is available and project isn't already open
    if command -v code &> /dev/null; then
        if ! pgrep -f "Visual Studio Code.*cdp-ui" > /dev/null; then
            code .
            echo "📝 Opened in VS Code"
        else
            echo "📝 Already open in VS Code"
        fi
    fi
    
    sed -i.tmp 's/^VITE_BEHIND_SERVICE_API_URL=/#VITE_BEHIND_SERVICE_API_URL=/' .env
    sed -i.tmp 's/^#VITE_BEHIND_SERVICE_API_URL=https:\/\/cdp-behind-service\.stage\.platform\.aws\.chgit\.com/VITE_BEHIND_SERVICE_API_URL=https:\/\/cdp-behind-service.stage.platform.aws.chgit.com/' .env
    
    rm .env.tmp
    echo "✅ Frontend configured for STAGE backend"
    npm run start
}

frontend-branch() {
    if [ $# -ne 1 ]; then
        echo "Usage: frontend-branch <branch-name>"
        return 1
    fi
    
    local branch_name="$1"
    local branch_url="https://cdp-${branch_name}--cdp-behind-service.feature.chgapi.com"
    
    echo "🚀 Starting frontend with BRANCH backend ($branch_name)..."
    backup_and_modify_frontend_env
    
    cd ~/code/work/cdp-ui
    
    # Check if VS Code is available and project isn't already open
    if command -v code &> /dev/null; then
        if ! pgrep -f "Visual Studio Code.*cdp-ui" > /dev/null; then
            code .
            echo "📝 Opened in VS Code"
        else
            echo "📝 Already open in VS Code"
        fi
    fi
    
    sed -i.tmp 's/^VITE_BEHIND_SERVICE_API_URL=/#VITE_BEHIND_SERVICE_API_URL=/' .env
    
    if grep -q "feature\.chgapi\.com" .env; then
        sed -i.tmp "s|.*feature\.chgapi\.com.*|VITE_BEHIND_SERVICE_API_URL=$branch_url|" .env
    else
        echo "VITE_BEHIND_SERVICE_API_URL=$branch_url" >> .env
    fi
    
    rm .env.tmp
    echo "✅ Frontend configured for BRANCH backend ($branch_url)"
    npm run start
}

frontend-status() {
    echo "========================================"
    echo "    FRONTEND CONFIGURATION STATUS"
    echo "========================================"
    
    cd ~/code/work/cdp-ui 2>/dev/null || return 1
    
    if [ -f .env ]; then
        local active_url=$(grep '^VITE_BEHIND_SERVICE_API_URL=' .env | cut -d'=' -f2-)
        if [ -n "$active_url" ]; then
            echo "Active: $active_url"
        else
            echo "❌ No active backend URL"
        fi
    fi
}

# =============================================================================
# BACKEND ENVIRONMENT FUNCTIONS
# =============================================================================
backend-start() {
    echo "🚀 Starting backend with current environment..."
    cd ~/code/work/cdp-behind-service || {
        echo "❌ Failed to navigate to backend directory"
        return 1
    }
    
    echo "📂 Changed to $(pwd)"
    
    if command -v code &> /dev/null; then
        if ! pgrep -f "Visual Studio Code.*cdp-behind-service" > /dev/null; then
            code .
            echo "📝 Opened in VS Code"
        else
            echo "📝 Already open in VS Code"
        fi
    fi
    
    echo "⚙️ Starting backend with current .env configuration..."
    npm run dev:nodb
}