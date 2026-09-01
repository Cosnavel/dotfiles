#!/usr/bin/env bash
# Generate executable launchers for each Claude account so GUI tools (Nimbalyst,
# Zed, etc.) and the shell can pick a specific account by command name.
# Each launcher just sets CLAUDE_CONFIG_DIR and execs the real claude binary.
set -euo pipefail
BIN="$HOME/.claude-tools/bin"
mkdir -p "$BIN"

make_wrapper() {
  local name="$1" cfg="$2" path="$BIN/$1"
  cat > "$path" <<EOF
#!/usr/bin/env bash
# Auto-generated launcher for Claude Code account: $cfg
export CLAUDE_CONFIG_DIR="$cfg"
for b in "\$HOME/.local/bin/claude" "\$HOME/.claude/local/claude" "/opt/homebrew/bin/claude" "/usr/local/bin/claude"; do
  [ -x "\$b" ] && exec "\$b" "\$@"
done
exec claude "\$@"
EOF
  chmod +x "$path"
  echo "created $path  (CLAUDE_CONFIG_DIR=$cfg)"
}

make_wrapper "claude-main" "$HOME/.claude"
for i in 1 2 3 4 5 6 7; do
  make_wrapper "claude-kettner-$i" "$HOME/.claude-kettner-$i"
done
