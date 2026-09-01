#!/usr/bin/env bash
# Provision a new Claude Code account: config dir + shared symlinks (skills/agents/
# commands/CLAUDE.md) + launcher + register in accounts.txt. Afterwards run the sync
# scripts to give it the same settings/MCP/trust as every other account.
# Usage: add_account.sh <name>   e.g.  add_account.sh nordicbarf  ->  claude-nordicbarf
set -u
NAME="${1:?usage: add_account.sh <name>}"
DIR="$HOME/.claude-$NAME"
SHARED="$HOME/.claude-shared/skills"
MAIN="$HOME/.claude"
BIN="$HOME/.claude-tools/bin"
ACCOUNTS="$HOME/.claude-tools/accounts.txt"

mkdir -p "$DIR" "$BIN"

relink() {
  local target="$1" link="$2"
  [ -e "$target" ] || return 0
  if [ -L "$link" ]; then rm "$link"; elif [ -e "$link" ]; then mv "$link" "$link.bak.$(date +%s)"; fi
  ln -s "$target" "$link"
}
relink "$SHARED"        "$DIR/skills"
relink "$MAIN/agents"   "$DIR/agents"
relink "$MAIN/commands" "$DIR/commands"
relink "$MAIN/CLAUDE.md" "$DIR/CLAUDE.md"

cat > "$BIN/claude-$NAME" <<EOF
#!/usr/bin/env bash
export CLAUDE_CONFIG_DIR="$DIR"
for b in "\$HOME/.local/bin/claude" "\$HOME/.claude/local/claude" "/opt/homebrew/bin/claude" "/usr/local/bin/claude"; do
  [ -x "\$b" ] && exec "\$b" "\$@"
done
exec claude "\$@"
EOF
chmod +x "$BIN/claude-$NAME"

touch "$ACCOUNTS"
grep -qxF "$DIR" "$ACCOUNTS" || echo "$DIR" >> "$ACCOUNTS"

echo "provisioned: $DIR  (launcher: claude-$NAME)"
echo "next: python3 ~/.claude-tools/apply_permissions.py && python3 ~/.claude-tools/install_mcp_servers.py && python3 ~/.claude-tools/trust_worktrees.py"
echo "then: claude-$NAME  ->  /login   (and: claude-$NAME mcp login linear)"
