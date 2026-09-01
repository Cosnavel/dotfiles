#!/usr/bin/env python3
"""Apply the permission profile to every Claude Code config dir.

Default profile: defaultMode=bypassPermissions with the curated DENY list applied
but NO "ask" list. Irreversible prod-killers (DB wipes, force-push, reset --hard,
rm -rf, redis flushall, ...) are blocked outright; everything else runs with no
prompt at all. Two independent toggles:
  APPLY_DENY -- block the catastrophic commands in DENY (recommended True)
  APPLY_ASK  -- force a confirm for the commands in ASK (False = no nagging)
Writes settings.json per config dir (Claude rewrites this file at runtime, so we
copy rather than symlink). Backs up existing files. Re-runnable.
"""
import json
import time
from pathlib import Path

HOME = Path.home()
def _account_dirs():
    f = HOME / ".claude-tools" / "accounts.txt"
    if f.exists():
        d = [Path(l.strip()) for l in f.read_text(encoding="utf-8").splitlines()
             if l.strip() and not l.lstrip().startswith("#")]
        if d:
            return d
    return [HOME / ".claude"] + [HOME / f".claude-kettner-{i}" for i in range(1, 8)]


CONFIG_DIRS = _account_dirs()

# Block the irreversible prod-killers (DENY), but never nag for normal work:
# deny on, ask off. Toggle each independently.
APPLY_DENY = True
APPLY_ASK = False

DENY = [
    # irreversible filesystem wipes
    "Bash(sudo rm *)",
    "Bash(rm -rf /*)",
    "Bash(rm -fr /*)",
    "Bash(rm -rf ~*)",
    "Bash(rm -rf --no-preserve-root*)",
    # Laravel destructive DB/migrations (php / php84 / ./artisan)
    "Bash(php artisan migrate:fresh*)",
    "Bash(php artisan migrate:reset*)",
    "Bash(php artisan migrate:refresh*)",
    "Bash(php artisan migrate:rollback*)",
    "Bash(php artisan db:wipe*)",
    "Bash(php artisan db:seed*)",
    "Bash(php84 artisan migrate:fresh*)",
    "Bash(php84 artisan migrate:reset*)",
    "Bash(php84 artisan migrate:refresh*)",
    "Bash(php84 artisan migrate:rollback*)",
    "Bash(php84 artisan db:wipe*)",
    "Bash(php84 artisan db:seed*)",
    "Bash(./artisan migrate:fresh*)",
    "Bash(./artisan migrate:reset*)",
    "Bash(./artisan migrate:refresh*)",
    "Bash(./artisan migrate:rollback*)",
    "Bash(./artisan db:wipe*)",
    "Bash(./artisan db:seed*)",
    # git history destruction
    "Bash(git push --force*)",
    "Bash(git push -f *)",
    "Bash(git reset --hard*)",
    "Bash(git clean -fd*)",
    "Bash(git clean -xfd*)",
    "Bash(git clean -fdx*)",
    "Bash(git clean -ffd*)",
    # postgres / redis nuclear
    "Bash(dropdb*)",
    "Bash(redis-cli flushall*)",
    "Bash(redis-cli flushdb*)",
    "Bash(redis-cli * flushall*)",
    "Bash(redis-cli * flushdb*)",
]

ASK = [
    "Bash(git push*)",
    "Bash(php artisan migrate*)",
    "Bash(php84 artisan migrate*)",
    "Bash(./artisan migrate*)",
    "Bash(php artisan db:*)",
    "Bash(php84 artisan db:*)",
    "Bash(psql*)",
    "Bash(mysql*)",
]

# allow rules apply in EVERY permission mode (default/acceptEdits/ask), not just
# bypass — so even when Nimbalyst forces a non-bypass mode via --permission-mode,
# these auto-approve. deny/ask still take precedence (deny -> ask -> allow).
ALLOW = [
    "Bash", "Read", "Edit", "Write", "Glob", "Grep",
    "WebFetch", "WebSearch", "NotebookEdit", "Task", "TodoWrite",
    "mcp__context7__*", "mcp__firecrawl__*", "mcp__uidotsh__*",
    "mcp__nightwatch__*", "mcp__ray__*", "mcp__laravel-boost__*", "mcp__linear__*",
]

ENV_ADD = {"DISABLE_TELEMETRY": "1", "DISABLE_ERROR_REPORTING": "1"}


def main() -> int:
    for cdir in CONFIG_DIRS:
        cdir.mkdir(parents=True, exist_ok=True)
        sf = cdir / "settings.json"
        if sf.exists():
            data = json.loads(sf.read_text(encoding="utf-8"))
            (cdir / f"settings.json.bak.{int(time.time())}").write_text(
                json.dumps(data), encoding="utf-8"
            )
        else:
            data = {}

        data["includeCoAuthoredBy"] = False
        data["enableAllProjectMcpServers"] = True
        data["skipDangerousModePermissionPrompt"] = True
        perms = {"defaultMode": "bypassPermissions", "allow": ALLOW}
        if APPLY_DENY:
            perms["deny"] = DENY
        if APPLY_ASK:
            perms["ask"] = ASK
        data["permissions"] = perms
        data.setdefault("env", {}).update(ENV_ADD)

        tmp = cdir / "settings.json.tmp"
        tmp.write_text(json.dumps(data, indent=2), encoding="utf-8")
        tmp.replace(sf)
        deny_state = f"deny={len(DENY)}" if APPLY_DENY else "deny=off"
        ask_state = f"ask={len(ASK)}" if APPLY_ASK else "ask=off"
        print(f"  {cdir.name:24} defaultMode=bypassPermissions  {deny_state} {ask_state}")

    labels = {
        (True, True): "Guarded YOLO (deny + ask)",
        (True, False): "Deny-guarded YOLO (deny on, no ask)",
        (False, True): "Ask-only profile",
        (False, False): "Full YOLO (no guardrails)",
    }
    print(f"\n{labels[(APPLY_DENY, APPLY_ASK)]} applied to all instances.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
