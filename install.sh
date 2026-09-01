#!/usr/bin/env bash
# =============================================================================
# install.sh — Rundum-Setup auf einem frischen Mac
# =============================================================================
# Richtet alles aus diesem Repo ein: Homebrew + Pakete, Zsh (Oh My Zsh,
# Starship, Plugins), Symlinks, NPM-/Composer-Globals, Laravel Herd,
# Cursor (beide Instanzen), Claude Code, Obsidian, Raycast, iTerm2.
#
# Idempotent: vorhandene Dateien werden nicht überschrieben (Ausnahme:
# Symlinks werden immer korrekt gesetzt). Mit --force werden auch
# vorhandene Configs durch die Repo-Versionen ersetzt (Backup als *.bak).
#
#   ./install.sh            # normale Installation
#   ./install.sh --force    # Repo-Configs erzwingen
# =============================================================================
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FORCE=0
[ "${1:-}" = "--force" ] && FORCE=1

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$1"; }
note() { printf '    %s\n' "$1"; }
warn() { printf '    \033[1;33mHINWEIS:\033[0m %s\n' "$1"; }

# Datei/Ordner aus dem Repo an Ziel kopieren — vorhandene Ziele nur mit --force ersetzen
place() {
  local src="$1" dst="$2"
  if [ -e "$dst" ] && [ "$FORCE" -eq 0 ]; then
    note "übersprungen (existiert): $dst"
    return 0
  fi
  [ -e "$dst" ] && cp -R "$dst" "$dst.bak" 2>/dev/null || true
  mkdir -p "$(dirname "$dst")"
  cp -R "$src" "$dst"
  note "installiert: $dst"
}

# Symlink setzen — ersetzt vorhandene Datei (mit Backup), Symlinks immer neu
link() {
  local src="$1" dst="$2"
  if [ -L "$dst" ]; then
    ln -sfn "$src" "$dst"
  elif [ -e "$dst" ]; then
    mv "$dst" "$dst.bak"
    note "Backup: $dst → $dst.bak"
    ln -s "$src" "$dst"
  else
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
  fi
  note "verlinkt: $dst → $src"
}

# -----------------------------------------------------------------------------
step "Homebrew + Pakete (Brewfile)"
# -----------------------------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
brew bundle --file="$DOTFILES/Brewfile" || warn "brew bundle mit Fehlern beendet — Ausgabe prüfen"

# -----------------------------------------------------------------------------
step "Oh My Zsh + Plugins"
# -----------------------------------------------------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
git -C "$DOTFILES" submodule update --init --recursive
note "zsh-autosuggestions + zsh-syntax-highlighting bereit"

# -----------------------------------------------------------------------------
step "Symlinks (Shell, Git, Tools)"
# -----------------------------------------------------------------------------
link "$DOTFILES/.zshrc"                    "$HOME/.zshrc"
link "$DOTFILES/.zprofile"                 "$HOME/.zprofile"
link "$DOTFILES/.gitconfig"                "$HOME/.gitconfig"
link "$DOTFILES/.yarnrc.yml"               "$HOME/.yarnrc.yml"
link "$DOTFILES/git-templates"             "$HOME/.git-templates"
link "$DOTFILES/starship.toml"             "$HOME/.config/starship.toml"
link "$DOTFILES/config/fastfetch"          "$HOME/.config/fastfetch"
mkdir -p "$HOME/.config/atuin"
link "$DOTFILES/config/atuin/config.toml"  "$HOME/.config/atuin/config.toml"

# -----------------------------------------------------------------------------
step "Node (nvm) + globale NPM-Pakete"
# -----------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"
if [ -s "$(brew --prefix nvm)/nvm.sh" ]; then
  # shellcheck disable=SC1091
  . "$(brew --prefix nvm)/nvm.sh"
  if ! nvm ls default >/dev/null 2>&1; then
    nvm install --lts
    nvm alias default 'lts/*'
  fi
  while IFS= read -r package || [ -n "$package" ]; do
    case "$package" in ''|\#*) continue ;; esac
    if npm install -g "$package" --silent; then
      note "npm -g: $package"
    else
      warn "npm -g fehlgeschlagen: $package"
    fi
  done < "$DOTFILES/npm-globals.txt"
else
  warn "nvm nicht gefunden — Node/NPM-Globals übersprungen"
fi

# -----------------------------------------------------------------------------
step "Composer Globals"
# -----------------------------------------------------------------------------
if command -v composer >/dev/null 2>&1 || [ -x "$HOME/Library/Application Support/Herd/bin/composer" ]; then
  place "$DOTFILES/composer/composer.json" "$HOME/.composer/composer.json"
  (cd "$HOME/.composer" && composer install --no-interaction) || warn "composer install fehlgeschlagen — später manuell: cd ~/.composer && composer install"
else
  warn "composer fehlt (kommt mit Herd) — nach Herd-Installation erneut ausführen"
fi

# -----------------------------------------------------------------------------
step "Laravel Herd"
# -----------------------------------------------------------------------------
if [ ! -d "/Applications/Herd.app" ]; then
  brew install --cask herd || warn "Herd-Cask fehlgeschlagen — manuell laden: https://herd.laravel.com"
  warn "Herd einmal starten (initialisiert Services), dann ./install.sh erneut für die Configs"
fi
HERD_CONFIG="$HOME/Library/Application Support/Herd/config"
if [ -d "$HERD_CONFIG" ]; then
  place "$DOTFILES/herd/valet/config.json" "$HERD_CONFIG/valet/config.json"
  for ini_dir in "$DOTFILES/herd/php/"*/; do
    version="$(basename "$ini_dir")"
    [ -d "$HERD_CONFIG/php/$version" ] || continue
    for f in "$ini_dir"*; do
      if [ -f "$f" ]; then
        place "$f" "$HERD_CONFIG/php/$version/$(basename "$f")"
      fi
    done
  done
  note "Herd-Configs übernommen — Lizenz + PHP-Versionen in der Herd-App aktivieren"
  note "Verlinkte Sites (zum Nachziehen per 'herd link'): herd/valet/linked-sites.txt"
fi

# -----------------------------------------------------------------------------
step "Cursor (Haupt-Instanz)"
# -----------------------------------------------------------------------------
CURSOR_USER="$HOME/Library/Application Support/Cursor/User"
if [ ! -d "/Applications/Cursor.app" ]; then
  brew install --cask cursor || warn "Cursor-Cask fehlgeschlagen — manuell laden: https://cursor.com"
fi
place "$DOTFILES/cursor/settings.json"    "$CURSOR_USER/settings.json"
place "$DOTFILES/cursor/keybindings.json" "$CURSOR_USER/keybindings.json"
place "$DOTFILES/cursor/cli-config.json"  "$HOME/.cursor/cli-config.json"
mkdir -p "$HOME/.cursor"
rsync -a "$DOTFILES/cursor/rules/"    "$HOME/.cursor/rules/"
rsync -a "$DOTFILES/cursor/commands/" "$HOME/.cursor/commands/"
rsync -a "$DOTFILES/cursor/skills/"   "$HOME/.cursor/skills/"
note "rules/ commands/ skills/ → ~/.cursor/"
if [ ! -f "$HOME/.cursor/mcp.json" ]; then
  cp "$DOTFILES/cursor/mcp.json.example" "$HOME/.cursor/mcp.json"
  warn "~/.cursor/mcp.json angelegt — REDACTED-Platzhalter durch echte API-Keys ersetzen!"
fi
if command -v cursor >/dev/null 2>&1 && [ "${CURSOR_INSTALL_EXTENSIONS:-0}" = "1" ]; then
  while IFS= read -r ext; do
    [ -z "$ext" ] && continue
    if cursor --install-extension "$ext" >/dev/null 2>&1; then
      note "Extension: $ext"
    else
      warn "Extension fehlgeschlagen: $ext"
    fi
  done < "$DOTFILES/cursor/extensions.txt"
else
  note "Extensions installieren mit: CURSOR_INSTALL_EXTENSIONS=1 ./install.sh (186 Stück, dauert)"
fi

# -----------------------------------------------------------------------------
step "Cursor Cosnavel (Zweit-Instanz)"
# -----------------------------------------------------------------------------
mkdir -p "$HOME/.cursor-cosnavel/User"
place "$DOTFILES/cursor/cosnavel/settings.json"    "$HOME/.cursor-cosnavel/User/settings.json"
place "$DOTFILES/cursor/cosnavel/keybindings.json" "$HOME/.cursor-cosnavel/User/keybindings.json"
if [ -d "/Applications/Cursor.app" ]; then
  bash "$DOTFILES/cursor/cosnavel/create-app.sh"
fi

# -----------------------------------------------------------------------------
step "Claude Code"
# -----------------------------------------------------------------------------
if ! command -v claude >/dev/null 2>&1 && [ ! -x "$HOME/.claude/local/claude" ]; then
  curl -fsSL https://claude.ai/install.sh | bash || warn "Claude-Code-Installer fehlgeschlagen"
fi
mkdir -p "$HOME/.claude"
place "$DOTFILES/claude/settings.json" "$HOME/.claude/settings.json"
place "$DOTFILES/claude/CLAUDE.md"     "$HOME/.claude/CLAUDE.md"
rsync -a "$DOTFILES/claude/tools/" "$HOME/.claude-tools/"
chmod +x "$HOME/.claude-tools/bin/"* "$HOME/.claude-tools/"*.sh 2>/dev/null || true
note "Multi-Account-Setup: ~/.claude-tools/setup_claude_instances.sh"
note "Skills syncen (Cursor → Claude): python3 ~/.claude-tools/sync_cursor_skills.py"
note "MCP-Server übernehmen: python3 ~/.claude-tools/install_mcp_servers.py"

# -----------------------------------------------------------------------------
step "Obsidian"
# -----------------------------------------------------------------------------
if [ -d "$HOME/wiki" ]; then
  mkdir -p "$HOME/wiki/.obsidian"
  rsync -a --ignore-existing "$DOTFILES/obsidian/wiki-vault/" "$HOME/wiki/.obsidian/"
  note "wiki-Vault-Config übernommen"
else
  warn "~/wiki fehlt — Vault erst klonen/anlegen, dann Config aus obsidian/wiki-vault/ kopieren"
fi
note "Learning-Vault kommt über iCloud; Config-Referenz: obsidian/learning-vault/"

# -----------------------------------------------------------------------------
step "Raycast + iTerm2"
# -----------------------------------------------------------------------------
note "Raycast: Settings → Advanced → Import (.rayconfig aus backup/), Script-Verzeichnis auf ~/.dotfiles/raycast zeigen"
note "Raycast-Extensions reinstallieren nach Liste: raycast/extensions.txt"
if ! defaults read com.googlecode.iterm2 >/dev/null 2>&1; then
  defaults import com.googlecode.iterm2 "$DOTFILES/iterm/com.googlecode.iterm2.plist"
  note "iTerm2-Preferences importiert"
else
  note "iTerm2 hat schon Einstellungen — bei Bedarf: defaults import com.googlecode.iterm2 $DOTFILES/iterm/com.googlecode.iterm2.plist"
fi

# -----------------------------------------------------------------------------
step "Fertig"
# -----------------------------------------------------------------------------
cat <<'EOF'
    Manuelle Restschritte (Logins/Secrets sind bewusst NICHT im Repo):
      1. ~/.cursor/mcp.json        → echte API-Keys eintragen
      2. ~/.npmrc                  → NPM-/GitHub-Registry-Tokens (aus 1Password)
      3. ~/.composer/auth.json     → Composer-Tokens (aus 1Password)
      4. Logins: Cursor (beide Instanzen), Claude, Herd-Lizenz, Raycast, 1Password
      5. Neue Shell öffnen — fertig.
EOF
