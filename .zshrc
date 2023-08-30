# Debugging
# zmodload zsh/zprof

export PATH=$HOME/bin:/usr/local/bin:$PATH

# Composer
export PATH="$HOME/.composer/vendor/bin:$PATH"
# export PATH="$PATH:$HOME/.composer/vendor/bin"
# export PATH="./vendor/bin:$PATH"

# Node & NPM
export PATH="$HOME/.node/bin:$PATH"
export PATH="node_modules/.bin:vendor/bin:$PATH"
export PATH="/usr/local/lib/node_modules:$PATH"
export NODE_PATH='/usr/local/lib/node_modules'


export PATH="/opt/homebrew/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

# XDebug
export XDEBUG_CONFIG="idekey=VSCODE"
export XDEBUG_CONFIG="idekey=vscode"

# Android
export ANDROID_SDK=/Users/niclaskahlmeier/Library/Android/sdk
export ANDROID_HOME=/Users/niclaskahlmeier/Library/Android/sdk
export PATH=/Users/niclaskahlmeier/Library/Android/sdk/platform-tools:$PATH


# NVM
export NVM_DIR=$HOME/.nvm
export PATH="$NVM_DIR/versions/node/v$(<$NVM_DIR/alias/default)/bin:$PATH"

export DOTFILES=$HOME/.dotfiles
export GPG_TTY=$(tty)



# Path to your oh-my-zsh installation.
export ZSH="/Users/niclaskahlmeier/.oh-my-zsh"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export GEM_HOME=/Users/niclaskahlmeier/.gem
export PATH="$GEM_HOME/bin:$PATH"

#p10k Prompt
#ZSH_THEME="powerlevel10k/powerlevel10k"
# To customize prompt, run `p10k configure` or edit ~/.dotfiles/.p10k.zsh.
#[[ ! -f ~/.dotfiles/.p10k.zsh ]] || source ~/.dotfiles/.p10k.zsh

# Spaceship Promt
eval "$(starship init zsh)"

# Github Copilot CLI
eval "$(github-copilot-cli alias -- "$0")"

# fnm node manager
# eval "$(fnm env)"

ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#9e9e9e"
#ZSH_AUTOSUGGEST_COMPLETION_IGNORE="git *"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
#ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
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
ZSH_CUSTOM=$DOTFILES

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

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

# alias ohmyzsh="mate ~/.oh-my-zsh"

#source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#source /Users/niclaskahlmeier/.dotfiles/plugins/zsh-autocomplete//zsh-autocomplete.plugin.zsh
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
unset zle_bracketed_paste

export HOMEBREW_NO_AUTO_UPDATE=1

export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
