# =============================================================================
# Custom Aliases - Organized & Optimized
# =============================================================================

# =============================================================================
# Applications
# =============================================================================
alias oxygenxml='open -a /Applications/Oxygen\ XML\ Author/Oxygen\ XML\ Author.app'
alias deckset='open -a /Applications/Deckset.app'
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'

# Editors
alias cs='code-insiders'
alias cursor='cursor'

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

# Fresh install helper
alias cmnn="comp i && mfs && yarn && yarn dev"

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
# NPM
# =============================================================================
alias ni="npm install"
alias nrs="npm run start -s --"
alias nrb="npm run build -s --"
alias nrd="npm run dev -s --"
alias nrt="npm run test -s --"
alias nrtw="npm run test:watch -s --"
alias nrv="npm run validate -s --"
alias nrw="npm run watch"
alias rmn="rm -rf node_modules"
alias npm-fresh="rm -rf node_modules package-lock.json && npm i && say NPM is done"
alias npm-update="npx ncu --dep prod --dep dev --upgrade"
alias nicache="npm install --prefer-offline"
alias nioff="npm install --offline"

# =============================================================================
# Yarn
# =============================================================================
alias yar="yarn run"
alias yas="yarn run start"
alias yab="yarn run build"
alias yat="yarn run test"
alias yav="yarn run validate"
alias yoff="yarn add --offline"
alias ypm="echo 'Installing deps without lockfile and ignoring engines' && yarn install --no-lockfile --ignore-engines"
alias yarn-update="yarn upgrade-interactive --latest"

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
