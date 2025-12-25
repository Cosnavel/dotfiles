# =============================================================================
# ZSH Configuration - Optimized
# =============================================================================
# Debugging (uncomment to profile startup time)
# zmodload zsh/zprof

# =============================================================================
# PATH Configuration
# =============================================================================
# Homebrew (Apple Silicon)
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# Ruby (Homebrew)
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

# PostgreSQL
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

# Local binaries
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH"

# Composer (PHP)
export PATH="$HOME/.composer/vendor/bin:$PATH"

# Node modules (local project)
export PATH="node_modules/.bin:vendor/bin:$PATH"

# RVM
export PATH="$PATH:$HOME/.rvm/bin"
export GEM_HOME="$HOME/.gem"
export PATH="$GEM_HOME/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# =============================================================================
# NVM Configuration (Lazy Loading for fast shell startup)
# =============================================================================
export NVM_DIR="$HOME/.nvm"
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
export NVM_AUTO_USE=true

# Fast NVM path loading (for immediate node access before lazy load triggers)
[[ -s "$NVM_DIR/alias/default" ]] && export PATH="$NVM_DIR/versions/node/v$(<$NVM_DIR/alias/default)/bin:$PATH"

# =============================================================================
# Android SDK
# =============================================================================
export ANDROID_SDK="$HOME/Library/Android/sdk"
export ANDROID_HOME="$ANDROID_SDK"
export PATH="$ANDROID_SDK/platform-tools:$PATH"

# =============================================================================
# Herd (PHP)
# =============================================================================
export PATH="$HOME/Library/Application Support/Herd/bin/:$PATH"
export PHP_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/:$PHP_INI_SCAN_DIR"

# PHP version-specific configurations
for php_version in 74 80 81 82 83 84 85; do
  export "HERD_PHP_${php_version}_INI_SCAN_DIR=$HOME/Library/Application Support/Herd/config/php/${php_version}/"
done

# =============================================================================
# Environment Variables
# =============================================================================
export DOTFILES="$HOME/.dotfiles"
export GPG_TTY=$(tty)
export HOMEBREW_NO_AUTO_UPDATE=1

# =============================================================================
# Colors & Theming
# =============================================================================
# LS_COLORS (vivid - catppuccin theme)
export LS_COLORS="$(vivid generate catppuccin-mocha)"

# bat theme
export BAT_THEME="Catppuccin Mocha"

# fzf theme (Catppuccin Mocha)
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--border='rounded' --border-label='' --preview-window='border-rounded' \
--prompt='  ' --marker='󰄴 ' --pointer=' ' \
--separator='─' --scrollbar='│' --info='right'"

# man pages colors
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# =============================================================================
# Oh My Zsh Configuration
# =============================================================================
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$DOTFILES"

# =============================================================================
# Autocomplete Configuration (MUST be before plugins load)
# =============================================================================
# Minimum chars before showing completions
zstyle ':autocomplete:*' min-input 2

# Don't show completion menu automatically on every keystroke
zstyle ':autocomplete:*' async yes
zstyle ':autocomplete:*' delay 0.1

# Limit menu size
zstyle ':autocomplete:*' list-lines 7

# Don't ask "do you wish to see all X possibilities"
zstyle ':completion:*' list-prompt ''
zstyle ':completion:*' select-prompt ''
LISTMAX=9999

# =============================================================================
# Autosuggestions Configuration
# =============================================================================
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c7086"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# =============================================================================
# Syntax Highlighting Colors (Catppuccin)
# =============================================================================
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=#89b4fa,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#a6e3a1,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#cba6f7,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=#89b4fa,bold'
ZSH_HIGHLIGHT_STYLES[path]='fg=#f9e2af,underline'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#f5c2e7'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#f38ba8'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#f5c2e7'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f38ba8'

# =============================================================================
# Plugins
# =============================================================================
plugins=(
  git
  zsh-nvm
  zsh-autocomplete
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# =============================================================================
# Load Oh My Zsh
# =============================================================================
source "$ZSH/oh-my-zsh.sh"

# =============================================================================
# Prompt (Starship)
# =============================================================================
eval "$(starship init zsh)"

# =============================================================================
# Shell Integrations
# =============================================================================
# zoxide (smart cd replacement)
eval "$(zoxide init zsh --cmd cd)"

# atuin (better shell history)
eval "$(atuin init zsh --disable-up-arrow)"

# fzf (fuzzy finder integration)
source <(fzf --zsh)

# iTerm2 integration
[[ -e "$HOME/.iterm2_shell_integration.zsh" ]] && source "$HOME/.iterm2_shell_integration.zsh"

# Bun completions
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# Fix bracketed paste issues
unset zle_bracketed_paste

# =============================================================================
# Aliases
# =============================================================================
alias claude="$HOME/.claude/local/claude"

# Quick system info
alias sysinfo="fastfetch"
alias fetch="fastfetch"

# =============================================================================
# Welcome Message (uncomment for greeting)
# =============================================================================
# fastfetch --logo small

# =============================================================================
# End of configuration
# =============================================================================
# Debugging (uncomment to see profile results)
# zprof
