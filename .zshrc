# =============================================================================
# ZSH Configuration - SPEED OPTIMIZED
# =============================================================================
# Debugging (uncomment to profile startup time)
# zmodload zsh/zprof

# =============================================================================
# PATH Configuration (consolidated for speed)
# =============================================================================
typeset -U PATH  # Remove duplicates

# All paths in one go (faster than multiple exports)
export PATH="\
$HOME/.local/bin:\
$HOME/bin:\
/opt/homebrew/bin:\
/opt/homebrew/sbin:\
/opt/homebrew/opt/ruby/bin:\
/opt/homebrew/opt/postgresql@17/bin:\
$HOME/.composer/vendor/bin:\
$HOME/.bun/bin:\
$HOME/.gem/bin:\
$HOME/.rvm/bin:\
$HOME/Library/Android/sdk/platform-tools:\
$HOME/Library/Application Support/Herd/bin:\
/usr/local/bin:\
/usr/local/sbin:\
node_modules/.bin:\
vendor/bin:\
$PATH"

# =============================================================================
# NVM Configuration (INSTANT - only loads on 'nvm' command)
# =============================================================================
export NVM_DIR="$HOME/.nvm"

# Add default node to PATH instantly (no NVM load needed)
[[ -s "$NVM_DIR/alias/default" ]] && \
  export PATH="$NVM_DIR/versions/node/v$(<$NVM_DIR/alias/default)/bin:$PATH"

# Ultra-fast lazy loader - NVM only loads when you actually call 'nvm'
nvm() {
  unfunction nvm node npm npx yarn pnpm 2>/dev/null
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
  nvm "$@"
}

# Lazy load for node commands (optional - uncomment if needed)
# for cmd in node npm npx yarn pnpm; do
#   eval "$cmd() { unfunction nvm node npm npx yarn pnpm 2>/dev/null; [[ -s \"\$NVM_DIR/nvm.sh\" ]] && source \"\$NVM_DIR/nvm.sh\"; $cmd \"\$@\" }"
# done

# =============================================================================
# Environment Variables
# =============================================================================
export DOTFILES="$HOME/.dotfiles"
export GPG_TTY=$(tty)
export HOMEBREW_NO_AUTO_UPDATE=1
export ANDROID_SDK="$HOME/Library/Android/sdk"
export ANDROID_HOME="$ANDROID_SDK"
export GEM_HOME="$HOME/.gem"
export BUN_INSTALL="$HOME/.bun"

# Herd PHP
export PHP_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/:$PHP_INI_SCAN_DIR"

# =============================================================================
# Colors & Theming (CACHED for speed)
# =============================================================================
# LS_COLORS - cached to file for instant load
_ls_colors_cache="$HOME/.cache/ls_colors"
if [[ ! -f "$_ls_colors_cache" ]] || [[ $(find "$_ls_colors_cache" -mtime +7 2>/dev/null) ]]; then
  mkdir -p "$HOME/.cache"
  vivid generate catppuccin-mocha > "$_ls_colors_cache" 2>/dev/null
fi
[[ -f "$_ls_colors_cache" ]] && export LS_COLORS="$(<$_ls_colors_cache)"

# bat theme
export BAT_THEME="Catppuccin Mocha"

# fzf theme (Catppuccin Mocha)
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--border='rounded' --preview-window='border-rounded' \
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

# Disable update checks (do manually with: omz update)
zstyle ':omz:update' mode disabled

# Skip compfix checks (faster)
ZSH_DISABLE_COMPFIX=true

# =============================================================================
# Completion Configuration
# =============================================================================
# Cache completions for speed
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zsh/compcache"

# Don't ask "do you wish to see all"
zstyle ':completion:*' list-prompt ''
zstyle ':completion:*' select-prompt ''
LISTMAX=9999

# =============================================================================
# Plugin Configuration (before loading)
# =============================================================================
# Autosuggestions
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c7086"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_MANUAL_REBIND=true  # Faster

# Syntax Highlighting (Catppuccin)
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
# Plugins (order matters: syntax-highlighting must be last!)
# =============================================================================
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# =============================================================================
# Load Oh My Zsh
# =============================================================================
source "$ZSH/oh-my-zsh.sh"

# =============================================================================
# Shell Integrations (CACHED for instant load)
# =============================================================================
_zsh_cache="$HOME/.cache/zsh"
[[ -d "$_zsh_cache" ]] || mkdir -p "$_zsh_cache"

# Cache shell integrations (regenerate weekly or if missing)
_cache_init() {
  local name=$1 cmd=$2 cache="$_zsh_cache/${name}.zsh"
  if [[ ! -f "$cache" ]] || [[ $(find "$cache" -mtime +7 2>/dev/null) ]]; then
    eval "$cmd" > "$cache" 2>/dev/null
  fi
  source "$cache"
}

_cache_init "starship" "starship init zsh"
_cache_init "zoxide" "zoxide init zsh --cmd cd"
_cache_init "atuin" "atuin init zsh --disable-up-arrow"
_cache_init "fzf" "fzf --zsh"

unfunction _cache_init

# iTerm2 integration (disabled for speed - uncomment if needed)
# [[ -e "$HOME/.iterm2_shell_integration.zsh" ]] && source "$HOME/.iterm2_shell_integration.zsh"
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# Fix bracketed paste
unset zle_bracketed_paste

# Disable history expansion with ! (fixes issues with ! in commands)
setopt NO_BANG_HIST

# =============================================================================
# Aliases
# =============================================================================
alias claude="$HOME/.claude/local/claude"
alias sysinfo="fastfetch"
alias fetch="fastfetch"

# =============================================================================
# End of configuration
# =============================================================================
# zprof
