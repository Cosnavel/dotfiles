# =============================================================================
# Custom Aliases - Organized & Optimized
# =============================================================================

# =============================================================================
# Applications
# =============================================================================
alias oxygenxml='open -a /Applications/Oxygen\ XML\ Author/Oxygen\ XML\ Author.app'
alias deckset='open -a /Applications/Deckset.app'
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'

# Editors - Cursor IDE
alias c.='cursor .'                    # Open current dir
alias cn='cursor -n'                   # New window
alias cr='cursor -r'                   # Reuse window
alias ca='cursor --add'                # Add folder to workspace
alias cdiff='cursor --diff'            # Diff two files
alias cw='cursor --wait'               # Wait for close
alias ce='cursor --goto'               # Go to file:line:column

# Cursor project shortcuts
alias cproj='cursor ~/Projects'
alias cdot='cursor ~/.dotfiles'

# =============================================================================
# Cursor Agent (AI Terminal)
# =============================================================================
alias ai='cursor-agent'                # Start interactive AI session
alias aic='cursor-agent'               # Alias for cursor-agent
alias aip='cursor-agent -p'            # Non-interactive (print mode)
alias ail='cursor-agent ls'            # List previous chats
alias air='cursor-agent resume'        # Resume last conversation
alias aiu='cursor-agent update'        # Update cursor-agent

# Quick AI tasks
alias aifix='cursor-agent "find and fix bugs in this code"'
alias aireview='cursor-agent "review this code for improvements"'
alias aitest='cursor-agent "write tests for this code"'
alias aidocs='cursor-agent "add documentation to this code"'
alias airefactor='cursor-agent "refactor this code for better readability"'

# Code Insiders (legacy)
alias cs='code-insiders'

# =============================================================================
# File Listing (using eza - modern ls)
# =============================================================================
alias ls='eza --icons --group-directories-first'
alias l='eza -l --icons --group-directories-first'
alias la='eza -a --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first --git'
alias lla='eza -la --icons --group-directories-first --git'
alias lt='eza --tree --icons --level=2'
alias lta='eza --tree --icons --level=2 -a'
alias ltl='eza --tree --icons --level=3'

# =============================================================================
# Search & Text Processing
# =============================================================================
# fd (fast find replacement)
alias find='fd'

# Fuzzy finder with bat preview
alias fzfp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"

# Quick file search with preview
alias f="fd --type f | fzf --preview 'bat --style=numbers --color=always {}'"

# Quick directory jump
alias d="fd --type d | fzf"

# Colored grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# =============================================================================
# Network
# =============================================================================
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"

# HTTP Methods (using lwp-request)
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
	alias "${method}"="lwp-request -m '${method}'"
done

# =============================================================================
# macOS Utilities
# =============================================================================
# Desktop icons
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Dock (hide/show with no-bouncing)
alias hidedock="defaults write com.apple.dock autohide-delay -float 1000 && defaults write com.apple.dock no-bouncing -bool TRUE && killall Dock"
alias showdock="defaults write com.apple.dock autohide-delay -float 0.15 && defaults write com.apple.dock no-bouncing -bool FALSE && killall Dock"

# Rosetta (for x86_64 compatibility)
alias userosetta="arch -x86_64 zsh"

# =============================================================================
# Navigation (zoxide)
# =============================================================================
alias cdi="cd -i"  # Interactive directory picker

# =============================================================================
# Quick Commands
# =============================================================================
alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub"
alias reloadshell="source $HOME/.zshrc"
alias shrug="echo '¯\_(ツ)_/¯' | pbcopy"
alias c="clear"
alias hostfile="sudo vi /etc/hosts"

# =============================================================================
# Laravel / PHP
# =============================================================================
alias art="php artisan"
alias mfs="php artisan migrate:fresh --seed"
alias seed="php artisan db:seed"
alias dusk="php artisan dusk"
alias duskf="php artisan dusk --filter"
alias laravel-ide-helper="composer require --dev barryvdh/laravel-ide-helper && art ide-helper:generate"

# Fresh install helper (composer + migrate + yarn)
alias cmnn="comp i && mfs && yi && yd"

# =============================================================================
# Pest (PHP Testing)
# =============================================================================
alias pestf="pest --filter"
alias pestw="pest --watch"
alias pestp="pest --parallel"
alias pestpw="pest --watch --parallel"
alias pestd="pest --order-by=defects --stop-on-defect"

# =============================================================================
# Composer (PHP)
# =============================================================================
alias comp="composer"
alias compu="composer update"
alias compr="composer require"
alias compi="composer install"
alias compda="composer dump-autoload -o"
alias compfresh="rm -rf vendor/ composer.lock && composer i"

# =============================================================================
# Yarn (Primary Package Manager)
# =============================================================================
# Installation
alias y="yarn"
alias yi="yarn install"
alias ya="yarn add"
alias yad="yarn add --dev"
alias yrm="yarn remove"

# Run scripts
alias yr="yarn run"
alias ys="yarn start"
alias yb="yarn build"
alias yd="yarn dev"
alias yt="yarn test"
alias ytw="yarn test --watch"
alias yv="yarn validate"
alias yw="yarn watch"

# Utilities
alias yoff="yarn add --offline"
alias yup="yarn upgrade-interactive --latest"
alias yfresh="rm -rf node_modules yarn.lock && yarn install && say Yarn is done"
alias rmn="rm -rf node_modules"
alias ypm="echo 'Installing deps without lockfile and ignoring engines' && yarn install --no-lockfile --ignore-engines"

# Cache & Offline
alias ycache="yarn install --prefer-offline"
alias yioff="yarn install --offline"

# =============================================================================
# NPM → Yarn Redirects (muscle memory helpers)
# =============================================================================
alias npm="yarn"
alias ni="yarn install"
alias nrs="yarn start"
alias nrb="yarn build"
alias nrd="yarn dev"
alias nrt="yarn test"

# =============================================================================
# Global NPM Packages Management
# =============================================================================
# Install all global packages from dotfiles
npm-globals-install() {
    local globals_file="$HOME/.dotfiles/npm-globals.txt"
    if [[ ! -f "$globals_file" ]]; then
        echo "❌ $globals_file not found"
        return 1
    fi

    echo "📦 Installing global npm packages..."
    local count=0
    while IFS= read -r package || [[ -n "$package" ]]; do
        # Skip comments and empty lines
        [[ "$package" =~ ^#.*$ || -z "$package" ]] && continue
        echo "  → Installing $package..."
        npm install -g "$package" --silent
        ((count++))
    done < "$globals_file"

    echo "✅ Installed $count global packages!"
}

# Save current global packages to dotfiles
npm-globals-save() {
    local globals_file="$HOME/.dotfiles/npm-globals.txt"
    local temp_file=$(mktemp)

    echo "📝 Saving global npm packages..."

    # Header
    cat > "$temp_file" << 'EOF'
# =============================================================================
# Global NPM Packages
# =============================================================================
# Diese Packages werden global installiert mit: npm-globals-install
# Liste aktualisieren mit: npm-globals-save
#
# Format: package-name (eine pro Zeile)
# Kommentare mit # werden ignoriert
# =============================================================================

EOF

    # Get global packages (exclude npm itself)
    npm list -g --depth=0 --json 2>/dev/null | \
        jq -r '.dependencies | keys[]' 2>/dev/null | \
        grep -v "^npm$" | \
        grep -v "^corepack$" | \
        sort >> "$temp_file"

    mv "$temp_file" "$globals_file"
    echo "✅ Saved to $globals_file"
    echo ""
    cat "$globals_file"
}

# List current global packages
alias npm-globals-list="npm list -g --depth=0"

# =============================================================================
# JavaScript Testing
# =============================================================================
alias jestl="./node_modules/.bin/jest"
alias mochal="./node_modules/.bin/mocha"

# =============================================================================
# React / Next.js
# =============================================================================
alias cra='npx create-react-app'
alias cna='npx create-next-app'

# =============================================================================
# Vagrant
# =============================================================================
alias v="vagrant global-status"
alias vup="vagrant up"
alias vhalt="vagrant halt"
alias vssh="vagrant ssh"
alias vreload="vagrant reload"
alias vrebuild="vagrant destroy --force && vagrant up"

# =============================================================================
# Git
# =============================================================================
# lazygit (terminal UI for git)
alias lg="lazygit"

alias gst="git status"
alias gb="git branch"
alias gc="git checkout"
alias gl="git log --oneline --decorate --color"
alias amend="git add . && git commit --amend --no-edit"
alias commit="git add . && git commit -m"
alias diff="git diff"
alias force="git push --force"
alias nah='git reset --hard; git clean -df'
alias pop="git stash pop"
alias pull="git pull"
alias pullauh="git pull --allow-unrelated-histories"
alias push="git push"
alias resolve="git add . && git commit --no-edit"
alias stash="git stash -u"
alias unstage="git restore --staged ."
alias wip="commit wip"
alias grmcache="git rm -r --cached ."
alias gitrmmerged='git branch --merged | egrep -v "(^\*|master|main|dev)" | xargs git branch -d'
alias gityolo='git add . && git commit -m "$(curl -s http://whatthecommit.com/index.txt)"'

# Git diff functions
dif() { git diff --color --no-index "$1" "$2" | diff-so-fancy; }
cdiff() { code --diff "$1" "$2"; }

# =============================================================================
# GitHub Actions
# =============================================================================
alias act-php='act -P ubuntu-latest=shivammathur/node:latest'

# =============================================================================
# Redis
# =============================================================================
alias flush-redis="redis-cli FLUSHALL"

# =============================================================================
# Pump (Hackintosh AIO Cooler)
# =============================================================================
alias pumpstatus="liquidctl status"
alias pumpspeed="liquidctl set pump speed"
alias pumpmin="liquidctl set pump speed 20"
alias pumpmax="liquidctl set pump speed 100"
alias pumpcolor="liquidctl set sync color fixed"
alias pumpcolorpulse="liquidctl set sync color fading 0027ed"
alias pumpcolorfade="liquidctl set sync color fading 0027ed bd1dff"

# =============================================================================
# Functions
# =============================================================================

# Fuzzy open file in Cursor
cf() {
    local file
    file=$(fd --type f --hidden --exclude .git | fzf --preview 'bat --style=numbers --color=always {}')
    [[ -n "$file" ]] && cursor "$file"
}

# Fuzzy open directory in Cursor
cfd() {
    local dir
    dir=$(fd --type d --hidden --exclude .git | fzf --preview 'eza --tree --level=2 --icons {}')
    [[ -n "$dir" ]] && cursor "$dir"
}

# Open recent Cursor projects (from zoxide)
cz() {
    local dir
    dir=$(zoxide query -l | fzf --preview 'eza --tree --level=2 --icons {}')
    [[ -n "$dir" ]] && cursor "$dir"
}

# Open Laravel DB in TablePlus
opendb() {
    [[ ! -f .env ]] && { echo "No .env file found."; return 1; }

    local DB_CONNECTION DB_HOST DB_PORT DB_DATABASE DB_USERNAME DB_PASSWORD DB_URL

    DB_CONNECTION=$(grep DB_CONNECTION .env | grep -v -e '^\s*#' | cut -d '=' -f 2-)
    DB_HOST=$(grep DB_HOST .env | grep -v -e '^\s*#' | cut -d '=' -f 2-)
    DB_PORT=$(grep DB_PORT .env | grep -v -e '^\s*#' | cut -d '=' -f 2-)
    DB_DATABASE=$(grep DB_DATABASE .env | grep -v -e '^\s*#' | cut -d '=' -f 2-)
    DB_USERNAME=$(grep DB_USERNAME .env | grep -v -e '^\s*#' | cut -d '=' -f 2-)
    DB_PASSWORD=$(grep DB_PASSWORD .env | grep -v -e '^\s*#' | cut -d '=' -f 2-)

    DB_URL="${DB_CONNECTION}://${DB_USERNAME}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_DATABASE}"

    echo "Opening ${DB_URL}"
    open "$DB_URL"
}
