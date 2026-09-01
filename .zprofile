# =============================================================================
# .zprofile - Login Shell Configuration (runs BEFORE .zshrc)
# =============================================================================
# Keep this minimal for fast startup!

# Homebrew (needed here for login shells)
eval "$(/opt/homebrew/bin/brew shellenv)"

# JetBrains Toolbox
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

# OrbStack (lazy load - only if using orbstack)
# source ~/.orbstack/shell/init.zsh 2>/dev/null || :
