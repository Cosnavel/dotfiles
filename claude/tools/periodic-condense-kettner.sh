#!/usr/bin/env bash
# Periodic, size-gated, AI-driven condense of the Kettner learned-insights file.
# The shrinking is done by the Claude agent (not a Python script); this wrapper
# only schedules + guards on size. Kettner-only. Invoked weekly by launchd.
REPO="/Users/niclaskahlmeier/kettner/kettner-project/kettner-worker"
F="$REPO/.cursor/rules/learned-insights.mdc"
CLAUDE="$HOME/.claude/local/claude"
THRESHOLD=60000

[ -f "$F" ] || exit 0
SIZE=$(wc -c < "$F" 2>/dev/null | tr -d ' ')
[ -n "$SIZE" ] || exit 0
echo "[$(date '+%F %T')] learned-insights.mdc = ${SIZE}B (threshold ${THRESHOLD})"
[ "$SIZE" -le "$THRESHOLD" ] && { echo "  under threshold, skipping"; exit 0; }

cd "$REPO" || exit 0
"$CLAUDE" -p "Shrink .cursor/rules/learned-insights.mdc. First copy it to ~/.claude-tools/backups/learned-insights.\$(date +%s).mdc. Then condense EVERY '### ' entry body to at most 2 short sentences, preserving verbatim every identifier (file paths, class/method/column/table names, config keys, numeric thresholds, command names, queue names, error strings). Keep ALL entries and their '### ' headings, keep German, and leave the meta header above '## Erkenntnisse' unchanged. Write the file back. Do not change any other file." \
  --permission-mode bypassPermissions --strict-mcp-config --disable-slash-commands \
  < /dev/null
echo "[$(date '+%F %T')] done: now $(wc -c < "$F" | tr -d ' ')B"
