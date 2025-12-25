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
# Oh My Zsh Configuration
# =============================================================================
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$DOTFILES"

# Plugins (loaded from $ZSH_CUSTOM/plugins/)
# - git: Git aliases and functions
# - zsh-autosuggestions: Fish-like autosuggestions
# - zsh-syntax-highlighting: Syntax highlighting (must be last!)
# - zsh-nvm: Lazy loading NVM for fast shell startup
plugins=(
  git
  zsh-nvm
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# =============================================================================
# Autosuggestions Configuration
# =============================================================================
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#9e9e9e"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

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

# =============================================================================
# End of configuration
# =============================================================================
# Debugging (uncomment to see profile results)
# zprof
