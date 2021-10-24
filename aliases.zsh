
#Reload stuck touchbar
alias rtouchbar="sudo pkill "Touch Bar agent"; sudo killall "ControlStrip""

#Run Parallels Big Sur Beta
alias runparallels="export SYSTEM_VERSION_COMPAT=1 && open -a "Parallels Desktop""

#Oxygen XML
alias oxygenxml='open -a /Applications/Oxygen\ XML\ Author/Oxygen\ XML\ Author.app'

#Deckset
alias deckset='open -a /Applications/Deckset.app'


# List all files colorized in long format
#alias l="ls -lF ${colorflag}"

# List all files colorized in long format, excluding . and ..
#alias la="ls -lAF ${colorflag}"

# List only directories
#alias lsd="ls -lF ${colorflag} | grep --color=never '^d'"

# Always use color output for `ls`
#alias ls="command ls ${colorflag}"
#alias ll="/usr/local/opt/coreutils/libexec/gnubin/ls -AhlFo --color --group-directories-first"

alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

#fzf
alias fzfp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"

#rg -> ripgrep search in files

#bat
#batgrep -> ripgrep with bat
#batwatch -> bat + entr = watch on file changes
#batdiff -> bat + delta
#prettybat -> bat + prettier

#pandoc -> format markup

#tail -> show last lines

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Load Node Version Manager
alias loadnvm=". /usr/local/opt/nvm/nvm.sh"

# Google Chrome
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
alias canary='/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Hide/show dock (useful when presenting)
alias hidedock="defaults write com.apple.dock autohide-delay -float 1000; killall Dock"
alias showdock="defaults delete com.apple.dock autohide-delay; killall Dock"

# Hide/show Dock (useful when using ubar)
alias hidedock="defaults write com.apple.dock autohide-delay -float 1000 && defaults write com.apple.dock no-bouncing -bool TRUE && killall Dock"
alias showdock="defaults write com.apple.dock autohide-delay -float 0.15 && defaults write com.apple.dock no-bouncing -bool FALSE && killall Dock"

# Pump Shotcuts Hackintosh only
alias pumpstatus="liquidctl status"
alias pumpspeed="liquidctl set pump speed"
alias pumpmin="liquidctl set pump speed 20"
alias pumpmax="liquidctl set pump speed 100"
alias pumpcolor="liquidctl set sync color fixed"
alias pumpcolordefault="liquidctl set sync color fixed"
alias pumpcolorpulse="liquidctl set sync color fading 0027ed"
alias pumpcolorpulsedefault="liquidctl set sync color fading 0027ed"
alias pumpcolorfade="liquidctl set sync color fading"
alias pumpcolorfadedefault="liquidctl set sync color fading 0027ed bd1dff"



# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
	alias "${method}"="lwp-request -m '${method}'"
done

# Shortcuts
alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub"
alias reloadshell="source $HOME/.zshrc"
alias flushdns="sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder"
alias phpstorm='open -na "PhpStorm.app" "`pwd`"'
alias shrug="echo '¯\_(ツ)_/¯' | pbcopy"
alias c="clear"
alias htdocs="cd /Applications/XAMPP/xamppfiles/htdocs"

alias hostfile="sudo vi /etc/hosts"

#Laravel
alias art="php artisan"
alias cmnn="comp i && mfs && npm i && npm run dev"
alias mfs="php artisan migrate:fresh --seed"
alias seed="php artisan db:seed"
alias laravel-ide-helper="composer require --dev barryvdh/laravel-ide-helper && art ide-helper:generate "
alias dusk="php artisan dusk"
alias duskf="php artisan dusk --filter"
alias pestf="pest --filter"

# PHP
alias composer="/usr/local/bin/composer"
alias comp="composer"
alias compu="composer update"
alias compr="composer require"
alias compi="composer install"
alias compda="composer dump-autoload -o"
alias compfresh="rm -rf vendor/ composer.lock && composer i"
alias phpunitw="phpunit-watcher watch"
#alias phpunit="vendor/bin/phpunit"
#alias pest="vendor/bin/pest"

# Switch PHP versions
phpv() {
    if [ $1 = "7.4" ]; then
        valet use php
    else
        valet use php@$1
    fi
    sed -in "s/128M/512M/g" /usr/local/etc/php/$1/conf.d/php-memory-limits.ini
    composer global update
    source ~/.zshrc
}

alias php70="phpv 7.0"
alias php71="phpv 7.1"
alias php72="phpv 7.2"
alias php73="phpv 7.3"
alias php74="phpv 7.4"
alias php8="phpv 8.0"
alias php81="phpv 8.1"
alias php82="phpv 8.2"

alias usephp73="brew unlink php && brew link --overwrite --force php@7.3"
alias usephp74="brew unlink php && brew link --overwrite --force php@7.4"
alias usephp8="brew unlink php && brew link --overwrite --force php@8.0"
alias usephp81="brew unlink php && brew link --overwrite --force php@8.1"
alias usephp82="brew unlink php && brew link --overwrite --force php@8.2"

# JS
alias jestl="./node_modules/.bin/jest"
alias mochal="./node_modules/.bin/mocha"
alias npm-update="npx ncu --dep prod --dep dev --upgrade";
alias yarn-update="yarn upgrade-interactive --latest";


## npm aliases
alias ni="npm install";
alias nrs="npm run start -s --";
alias nrb="npm run build -s --";
alias nrd="npm run dev -s --";
alias nrt="npm run test -s --";
alias nrtw="npm run test:watch -s --";
alias nrv="npm run validate -s --";
alias nrw="npm run watch"
alias rmn="rm -rf node_modules";
alias npm-fresh="rm -rf node_modules package-lock.json && npm i && say NPM is done";
alias nicache="npm install --prefer-offline";
alias nioff="npm install --offline";

## yarn aliases
alias yar="yarn run";
alias yas="yarn run start";
alias yab="yarn run build";
alias yat="yarn run test";
alias yav="yarn run validate";
alias yoff="yarn add --offline";
alias ypm="echo \"Installing deps without lockfile and ignoring engines\" && yarn install --no-lockfile --ignore-engines"


#React
alias cra='npx create-react-app'
alias cna='npx create-next-app'


# Vagrant
alias v="vagrant global-status"
alias vup="vagrant up"
alias vhalt="vagrant halt"
alias vssh="vagrant ssh"
alias vreload="vagrant reload"
alias vrebuild="vagrant destroy --force && vagrant up"

# Git
alias gst="git status"
alias gb="git branch"
alias gc="git checkout"
alias gl="git log --oneline --decorate --color"
alias amend="git add . && git commit --amend --no-edit"
alias commit="git add . && git commit -m"
alias diff="git diff"
dif() { git diff --color --no-index "$1" "$2" | diff-so-fancy; }
cdiff() { code --diff "$1" "$2"; }
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
alias gityolo='git add . && git commit -m "$(curl -s http://whatthecommit.com/index.txt)";'

alias act-php='act -P ubuntu-latest=shivammathur/node:latest'

# Redis
alias flush-redis="redis-cli FLUSHALL"

# VSCode
#alias code='open -a "/Applications/Visual Studio Code.app" "`pwd`"'

#Open Laravel DB in Table Plus
opendb () {
   [ ! -f .env ] && { echo "No .env file found."; exit 1; }

   DB_CONNECTION=$(grep DB_CONNECTION .env | grep -v -e '^\s*#' | cut -d '=' -f 2-)
   DB_HOST=$(grep DB_HOST .env | grep -v -e '^\s*#' | cut -d '=' -f 2-)
   DB_PORT=$(grep DB_PORT .env | grep -v -e '^\s*#' | cut -d '=' -f 2-)
   DB_DATABASE=$(grep DB_DATABASE .env | grep -v -e '^\s*#' | cut -d '=' -f 2-)
   DB_USERNAME=$(grep DB_USERNAME .env | grep -v -e '^\s*#' | cut -d '=' -f 2-)
   DB_PASSWORD=$(grep DB_PASSWORD .env | grep -v -e '^\s*#' | cut -d '=' -f 2-)

   DB_URL="${DB_CONNECTION}://${DB_USERNAME}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_DATABASE}"

   echo "Opening ${DB_URL}"
   open $DB_URL
}
