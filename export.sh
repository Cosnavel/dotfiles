#!/usr/bin/env bash
# =============================================================================
# export.sh — Aktuellen System-Zustand ins Dotfiles-Repo einsammeln
# =============================================================================
# Sammelt Brewfile, Composer/NPM-Globals, Herd, Cursor (beide Instanzen),
# Claude Code, Obsidian, Raycast und iTerm2 ein. Secrets werden automatisch
# redigiert (mcp.json -> mcp.json.example, SSH-Hosts aus Cursor-Settings).
#
# Idempotent — einfach erneut laufen lassen: ./export.sh
# =============================================================================
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"
step() { printf '\n\033[1;34m==> %s\033[0m\n' "$1"; }
note() { printf '    %s\n' "$1"; }

# -----------------------------------------------------------------------------
step "Homebrew → Brewfile"
# -----------------------------------------------------------------------------
brew bundle dump --force --file="$DOTFILES/Brewfile"
note "$(rg -c '^(brew|cask|tap|mas|vscode)' "$DOTFILES/Brewfile" || true) Einträge"

# -----------------------------------------------------------------------------
step "Composer Globals"
# -----------------------------------------------------------------------------
# Nur composer.json — NIE auth.json (enthält Tokens)!
cp "$HOME_DIR/.composer/composer.json" "$DOTFILES/composer/composer.json"
note "composer/composer.json aktualisiert"

# -----------------------------------------------------------------------------
step "Cursor (Haupt-Instanz)"
# -----------------------------------------------------------------------------
mkdir -p "$DOTFILES/cursor/cosnavel"
CURSOR_USER="$HOME_DIR/Library/Application Support/Cursor/User"

# settings.json: remote.SSH.remotePlatform strippen (interne Hosts/IPs — Repo ist öffentlich)
sanitize_vscode_settings() {
  python3 - "$1" "$2" <<'PY'
import re, sys
src, dst = sys.argv[1], sys.argv[2]
text = open(src).read()
text = re.sub(r'\s*"remote\.SSH\.remotePlatform"\s*:\s*\{[^}]*\},?', '', text)
open(dst, 'w').write(text)
PY
}

sanitize_vscode_settings "$CURSOR_USER/settings.json" "$DOTFILES/cursor/settings.json"
cp "$CURSOR_USER/keybindings.json" "$DOTFILES/cursor/keybindings.json"
cp "$HOME_DIR/.cursor/cli-config.json" "$DOTFILES/cursor/cli-config.json"

# Extension-Liste (gemeinsames Extension-Verzeichnis beider Instanzen)
python3 - "$HOME_DIR/.cursor/extensions/extensions.json" "$DOTFILES/cursor/extensions.txt" <<'PY'
import json, sys
data = json.load(open(sys.argv[1]))
ids = sorted({e['identifier']['id'] for e in data})
open(sys.argv[2], 'w').write('\n'.join(ids) + '\n')
print(f'    {len(ids)} Extensions')
PY

# Rules, Commands, Skills (User-Level)
rsync -a --delete --exclude '.DS_Store' "$HOME_DIR/.cursor/rules/"    "$DOTFILES/cursor/rules/"
rsync -a --delete --exclude '.DS_Store' "$HOME_DIR/.cursor/commands/" "$DOTFILES/cursor/commands/"
rsync -a --delete --exclude '.DS_Store' "$HOME_DIR/.cursor/skills/"   "$DOTFILES/cursor/skills/"
note "rules/ commands/ skills/ synchronisiert"

# mcp.json: Werte von Key/Token/Authorization-Feldern redigieren → Template
python3 - "$HOME_DIR/.cursor/mcp.json" "$DOTFILES/cursor/mcp.json.example" <<'PY'
import json, re, sys
SENSITIVE = re.compile(r'(?i)(key|token|secret|authorization|password|bearer)')
def scrub(obj):
    if isinstance(obj, dict):
        return {k: ('<REDACTED — eigenen Wert eintragen>' if isinstance(v, str) and SENSITIVE.search(k) else scrub(v))
                for k, v in obj.items()}
    if isinstance(obj, list):
        return [scrub(x) for x in obj]
    return obj
data = scrub(json.load(open(sys.argv[1])))
json.dump(data, open(sys.argv[2], 'w'), indent=2, ensure_ascii=False)
PY
note "mcp.json.example (redigiert) erzeugt"

# -----------------------------------------------------------------------------
step "Cursor Cosnavel (Zweit-Instanz)"
# -----------------------------------------------------------------------------
sanitize_vscode_settings "$HOME_DIR/.cursor-cosnavel/User/settings.json" "$DOTFILES/cursor/cosnavel/settings.json"
cp "$HOME_DIR/.cursor-cosnavel/User/keybindings.json" "$DOTFILES/cursor/cosnavel/keybindings.json"
note "Settings + Keybindings der Zweit-Instanz gesichert"

# -----------------------------------------------------------------------------
step "Claude Code"
# -----------------------------------------------------------------------------
mkdir -p "$DOTFILES/claude/tools"
cp "$HOME_DIR/.claude/settings.json" "$DOTFILES/claude/settings.json"
cp "$HOME_DIR/.claude/CLAUDE.md"     "$DOTFILES/claude/CLAUDE.md"
# Multi-Account-Tooling (Wrapper, Skill-Sync, MCP-Installer) — ohne Caches/Logs/Backups
rsync -a --delete \
  --exclude '__pycache__' --exclude 'backups' --exclude '*.log' --exclude '*.pyc' --exclude '.DS_Store' \
  "$HOME_DIR/.claude-tools/" "$DOTFILES/claude/tools/"
note "settings.json, CLAUDE.md und claude-tools synchronisiert"
note "Skills werden aus cursor/skills + Repos generiert: claude/tools/sync_cursor_skills.py"

# -----------------------------------------------------------------------------
step "Laravel Herd"
# -----------------------------------------------------------------------------
HERD_CONFIG="$HOME_DIR/Library/Application Support/Herd/config"
mkdir -p "$DOTFILES/herd/valet"
cp "$HERD_CONFIG/valet/config.json" "$DOTFILES/herd/valet/config.json"
cp "$HERD_CONFIG/herd.json"         "$DOTFILES/herd/herd.json"
# php.ini pro Version (ohne cacert.pem — generisch und groß)
rsync -a --delete --exclude 'cacert.pem' --exclude '.DS_Store' "$HERD_CONFIG/php/"     "$DOTFILES/herd/php/"
rsync -a --delete --exclude '.DS_Store'                        "$HERD_CONFIG/nginx/"   "$DOTFILES/herd/nginx/"
rsync -a --delete --exclude '.DS_Store'                        "$HERD_CONFIG/dnsmasq/" "$DOTFILES/herd/dnsmasq/"
# Verlinkte Sites nur als Liste (Symlinks sind maschinenspezifisch)
if [ -d "$HERD_CONFIG/valet/Sites" ]; then
  (cd "$HERD_CONFIG/valet/Sites" && for l in *; do
    [ -L "$l" ] && printf '%s -> %s\n' "$l" "$(readlink "$l")"
  done | sort) > "$DOTFILES/herd/valet/linked-sites.txt" || true
fi
note "valet config, php.ini (alle Versionen), nginx, dnsmasq, Site-Liste gesichert"

# -----------------------------------------------------------------------------
step "Obsidian"
# -----------------------------------------------------------------------------
# Vault "wiki" (lokal): komplette Config ohne Session-State
rsync -a --delete --exclude 'workspace*' --exclude '.DS_Store' \
  "$HOME_DIR/wiki/.obsidian/" "$DOTFILES/obsidian/wiki-vault/"
# Vault "Learning" (iCloud): nur JSON-Configs/Snippets/Themes, keine Plugin-Binaries
LEARNING="$HOME_DIR/Library/Mobile Documents/iCloud~md~obsidian/Documents/Learning/.obsidian"
if [ -d "$LEARNING" ]; then
  rsync -a --delete --exclude 'workspace*' --exclude 'plugins' --exclude '.DS_Store' \
    "$LEARNING/" "$DOTFILES/obsidian/learning-vault/" || note "WARNUNG: Learning-Vault (iCloud) teilweise nicht lesbar"
fi
note "Vault-Configs gesichert (wiki + Learning)"

# -----------------------------------------------------------------------------
step "Raycast"
# -----------------------------------------------------------------------------
# Installierte Extensions als Liste (Store-Namen zum Reinstallieren)
if [ -d "$HOME_DIR/.config/raycast/extensions" ]; then
  python3 - "$HOME_DIR/.config/raycast/extensions" "$DOTFILES/raycast/extensions.txt" <<'PY'
import json, os, sys
root, dst = sys.argv[1], sys.argv[2]
rows = set()
for entry in sorted(os.listdir(root)):
    pkg = os.path.join(root, entry, 'package.json')
    if os.path.isfile(pkg):
        try:
            d = json.load(open(pkg))
            rows.add("{} — {}".format(d.get('name', '?'), d.get('title', '?')))
        except Exception:
            pass
open(dst, 'w').write('\n'.join(sorted(rows)) + '\n')
print(f'    {len(rows)} Raycast-Extensions gelistet')
PY
fi
note "Vollbackup (Snippets, Quicklinks, Hotkeys): Raycast → Settings → Advanced → Export"

# -----------------------------------------------------------------------------
step "iTerm2"
# -----------------------------------------------------------------------------
defaults export com.googlecode.iterm2 "$DOTFILES/iterm/com.googlecode.iterm2.plist"
plutil -convert xml1 "$DOTFILES/iterm/com.googlecode.iterm2.plist"
note "iTerm2-Preferences exportiert"

# -----------------------------------------------------------------------------
step "Fertig"
# -----------------------------------------------------------------------------
note "npm-globals.txt ist kuratiert — bei Bedarf mit 'npm-globals-save' aktualisieren."
note "Jetzt prüfen und committen: git -C $DOTFILES status"
