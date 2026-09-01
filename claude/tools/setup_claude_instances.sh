#!/usr/bin/env bash
# Create 8 Claude Code config dirs that all MIRROR the same skills (and share
# the main account's agents/commands/CLAUDE.md "brain"), while keeping
# credentials/sessions/history/settings separate per account.
#
# Instances:  claude (default ~/.claude) + claude-kettner-1 .. claude-kettner-7
# Re-runnable: safely re-creates the symlinks.
set -euo pipefail

SHARED_SKILLS="$HOME/.claude-shared/skills"
MAIN="$HOME/.claude"
INSTANCES=(
  "$HOME/.claude"
  "$HOME/.claude-kettner-1"
  "$HOME/.claude-kettner-2"
  "$HOME/.claude-kettner-3"
  "$HOME/.claude-kettner-4"
  "$HOME/.claude-kettner-5"
  "$HOME/.claude-kettner-6"
  "$HOME/.claude-kettner-7"
)

mkdir -p "$SHARED_SKILLS"

# link <target> <linkpath>: replace existing symlink, back up a real file/dir.
relink() {
  local target="$1" link="$2"
  [ -e "$target" ] || return 0
  if [ -L "$link" ]; then
    rm "$link"
  elif [ -e "$link" ]; then
    mv "$link" "$link.bak.$(date +%s)"
  fi
  ln -s "$target" "$link"
}

for dir in "${INSTANCES[@]}"; do
  mkdir -p "$dir"
  # Skills: every instance points at the single shared set (the requirement).
  relink "$SHARED_SKILLS" "$dir/skills"
  # Shared "brain" for the kettner-N accounts -> reuse the main account's config.
  if [ "$dir" != "$MAIN" ]; then
    relink "$MAIN/agents"    "$dir/agents"
    relink "$MAIN/commands"  "$dir/commands"
    relink "$MAIN/CLAUDE.md" "$dir/CLAUDE.md"
  fi
  echo "configured: $dir"
done

echo
echo "Skills mirrored into all instances ($(ls -1 "$SHARED_SKILLS" | wc -l | tr -d ' ') skills):"
for dir in "${INSTANCES[@]}"; do
  printf '  %-28s -> %s\n' "$dir/skills" "$(readlink "$dir/skills")"
done
