# Dotfiles — Rundum-Setup

Komplettes macOS-Entwickler-Setup: Terminal, Homebrew, Laravel Herd, Cursor
(beide Instanzen), Claude Code inkl. aller KI-Skills und -Commands, Obsidian,
Raycast und iTerm2. Ein frischer Mac wird damit in einem Durchlauf arbeitsfähig.

## Neuen Mac einrichten

```bash
git clone --recurse-submodules https://github.com/Cosnavel/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

Danach die manuellen Restschritte am Ende der Installer-Ausgabe abarbeiten
(API-Keys, Logins, Lizenzen — Secrets liegen bewusst nicht im Repo).

## Repo aktuell halten

```bash
cd ~/.dotfiles
./export.sh     # sammelt den aktuellen System-Zustand ein (mit Secret-Redaktion)
git add -A && git commit -m "sync system state"
```

Die Shell-Dateien (`.zshrc`, `.zprofile`, `aliases.zsh`, `starship.toml`,
`.gitconfig`, Fastfetch, Atuin, Git-Templates) sind **symlinked** — Änderungen
landen sofort im Repo, ohne Export. Alles andere (Cursor, Claude, Herd, …)
wird von `export.sh` kopiert.

## Was steckt drin

| Bereich | Pfad im Repo | Ziel auf dem System |
|---|---|---|
| Zsh (Oh My Zsh, `ZSH_CUSTOM` zeigt hierher) | `.zshrc`, `.zprofile`, `aliases.zsh` | `~/.zshrc`, `~/.zprofile` (Symlinks) |
| Zsh-Plugins (Submodule) | `plugins/` | via Oh My Zsh geladen |
| Starship-Prompt | `starship.toml` | `~/.config/starship.toml` (Symlink) |
| Fastfetch / Atuin | `config/` | `~/.config/…` (Symlinks) |
| Git (Delta, 1Password-Signing, Hooks) | `.gitconfig`, `.gitignore_global`, `git-templates/` | `~/.gitconfig`, `~/.git-templates` (Symlinks) |
| Homebrew-Pakete (Formulae, Casks, Taps) | `Brewfile` | `brew bundle` |
| Globale NPM-Pakete (kuratiert) | `npm-globals.txt` | `npm-globals-install` (Alias) |
| Yarn 4 global | `.yarnrc.yml` | `~/.yarnrc.yml` (Symlink) |
| Globale Composer-Pakete | `composer/composer.json` | `~/.composer/composer.json` |
| Laravel Herd (Valet, php.ini aller Versionen, Nginx, dnsmasq) | `herd/` | `~/Library/Application Support/Herd/config/` |
| Cursor: Settings, Keybindings, CLI-Config | `cursor/` | App Support + `~/.cursor/` |
| Cursor: 186 Extensions | `cursor/extensions.txt` | `CURSOR_INSTALL_EXTENSIONS=1 ./install.sh` |
| Cursor: KI-Rules, -Commands, -Skills | `cursor/rules/`, `cursor/commands/`, `cursor/skills/` | `~/.cursor/…` |
| Cursor: MCP-Server (Template, Keys redigiert) | `cursor/mcp.json.example` | `~/.cursor/mcp.json` |
| Cursor Cosnavel (Zweit-Instanz als eigene App) | `cursor/cosnavel/` | `/Applications/Cursor Cosnavel.app` + `~/.cursor-cosnavel` |
| Claude Code: Settings, globales `CLAUDE.md` | `claude/` | `~/.claude/` |
| Claude Code: Multi-Account-Tooling (8 Accounts, Skill-Sync, MCP-Installer) | `claude/tools/` | `~/.claude-tools/` |
| Obsidian-Vault-Configs (wiki + Learning) | `obsidian/` | `~/wiki/.obsidian/` u. a. |
| Raycast: Script-Commands + Extension-Liste | `raycast/` | Script-Verzeichnis in Raycast |
| iTerm2-Preferences | `iterm/` | `defaults import` |
| Legacy-Backups (iTerm-Farben, VS-Code-Profil, Raycast 2023) | `backup/` | manuell bei Bedarf |

## KI-Setup (Cursor ↔ Claude Code)

Die Skills und Commands leben **einmal** in `cursor/skills/` und
`cursor/commands/`. Claude Code bekommt sie über das Sync-Tooling:

```bash
python3 ~/.claude-tools/sync_cursor_skills.py    # Skills → ~/.claude-shared/skills (alle Accounts)
python3 ~/.claude-tools/install_mcp_servers.py   # MCP-Server aus Cursor → alle Claude-Accounts
~/.claude-tools/setup_claude_instances.sh        # claude-kettner-1..7 Wrapper einrichten
```

`~/.claude/skills` ist ein Symlink auf `~/.claude-shared/skills`, damit alle
acht Claude-Accounts denselben Skill-Stand sehen.

## Secrets

Dieses Repo ist öffentlich. Es gilt:

- `cursor/mcp.json.example` enthält **redigierte** Platzhalter — echte Keys nur
  lokal in `~/.cursor/mcp.json` (steht in `.gitignore`).
- `~/.npmrc` und `~/.composer/auth.json` (Registry-Tokens) sind **nicht** im
  Repo — Werte liegen in 1Password.
- `export.sh` redigiert beim Einsammeln automatisch: MCP-Keys/-Tokens und die
  `remote.SSH.remotePlatform`-Hosts aus den Cursor-Settings.
- Herd-Lizenz, Zertifikate (`valet/CA`, `certificates/`) und Claude-Sessions
  werden gar nicht erst exportiert.
- Sechs arbeitsinterne Cursor-Commands (u. a. `test.md`, `prod.md`,
  `leadmagnets.md`) stehen in `.gitignore`: sie enthalten Firmen-Interna und
  bleiben nur lokal bzw. gehören ins (private) Arbeits-Repo.
