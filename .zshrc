# If you come from bash you might have to change your $PATH.
# export export PATH="$HOME/.volta/bin:$HOME/bin:/usr/local/bin:$PATH"


# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="fino-time"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git
	web-search
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="$HOME/.volta/bin:$HOME/bin:/usr/local/bin:$PATH"
source ~/dotfiles/.env.local 2>/dev/null || true

# Project shortcuts
alias cdpui='cd ~/code/work/cdp-ui'
alias cdpbe='cd ~/code/work/cdp-behind-service'
alias work='cd ~/code/work'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias glog='git log --oneline --graph'

# NPM shortcuts
alias nrs='npm run start'
alias nrt='npm run test'
alias nrtu='npm run test:unit'
alias nrdn='npm run dev:nodb'

# Useful development scripts
# Kill whatever is running on a specific port (usage: killport 3000)
alias killport='function _killport() { lsof -ti:$1 | xargs kill -9; }; _killport'
# Quick commit and push (usage: gcp "commit message")
alias gcp='function _gcp() { git add . && git commit -m "$1" && git push; }; _gcp'
alias shortcuts="~/dotfiles/list_shortcuts.sh"
alias updatetoken="~/dotfiles/update_npm_token.sh"
alias reload="source ~/.zshrc"

# Enhanced ideas management function
idea() {
    local IDEAS_FILE="$HOME/dotfiles/ideas.txt"
    
    # Create ideas file if it doesn't exist
    if [ ! -f "$IDEAS_FILE" ]; then
        touch "$IDEAS_FILE"
    fi
    
    # Handle delete command
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
        
        # Show what we're deleting
        local deleted_idea=$(sed -n "${line_num}p" "$IDEAS_FILE")
        echo "Deleting idea #$line_num: $deleted_idea"
        
        # Delete the line
        sed -i '' "${line_num}d" "$IDEAS_FILE"
        echo "Idea deleted successfully"
        return 0
    fi
    
    # If no arguments, list all ideas
    if [ $# -eq 0 ]; then
        if [ ! -s "$IDEAS_FILE" ]; then
            echo "No ideas yet. Add one with: idea \"your idea here\""
            echo "Delete ideas with: idea rm <number>"
            return 0
        fi
        
        echo "=== MY WORKFLOW IDEAS ==="
        # Number the ideas and display them
        cat -n "$IDEAS_FILE"
        echo ""
        echo "Total ideas: $(wc -l < "$IDEAS_FILE")"
        echo "Delete with: idea rm <number>"
    else
        # Add new idea (join all arguments into one string)
        local NEW_IDEA="$*"
        
        # Add timestamp and idea to file
        echo "$(date '+%Y-%m-%d') - $NEW_IDEA" >> "$IDEAS_FILE"
        echo "Added idea: $NEW_IDEA"
    fi
}
