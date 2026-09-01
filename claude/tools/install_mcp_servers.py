#!/usr/bin/env python3
"""Install ALL Cursor MCP servers into EVERY Claude Code config dir at USER scope (global).

Reads server definitions from Cursor's mcp.json (global + project) so secrets stay
in those files (not duplicated here), normalizes them for Claude Code, then merges
them into each config dir's ~/.claude.json top-level `mcpServers` (= user scope).

Normalisation:
  - stdio `npx`  -> absolute npx (GUI-spawned servers don't inherit the shell PATH)
  - stdio `php`  -> absolute php84 (this machine's CLI php is 8.3; Laravel needs 8.4)
  - url servers  -> {"type":"http", ...} and agent=cursor -> agent=claude

Re-runnable + idempotent. Backs up each .claude.json before writing.
Re-run after changing your Cursor MCP config or your default node version.
"""
import json
import os
import time
from pathlib import Path

HOME = Path.home()
REPO = Path("/Users/niclaskahlmeier/kettner/kettner-project/kettner-worker")

SOURCES = [HOME / ".cursor/mcp.json", REPO / ".cursor/mcp.json"]
def _account_dirs():
    f = HOME / ".claude-tools" / "accounts.txt"
    if f.exists():
        d = [Path(l.strip()) for l in f.read_text(encoding="utf-8").splitlines()
             if l.strip() and not l.lstrip().startswith("#")]
        if d:
            return d
    return [HOME / ".claude"] + [HOME / f".claude-kettner-{i}" for i in range(1, 8)]


CONFIG_DIRS = _account_dirs()

# Servers wanted globally in Claude Code that are NOT in Cursor's mcp.json
# (e.g. Cursor plugins). Already in Claude Code format. Linear is a remote OAuth
# MCP; its /sse transport is deprecated -> use the /mcp (HTTP) endpoint. After
# install, authenticate per instance with: claude mcp login linear
EXTRA_SERVERS = {
    "linear": {"type": "http", "url": "https://mcp.linear.app/mcp"},
}

# Absolute binaries (Nimbalyst/Finder-launched processes lack the shell PATH).
NPX = str(HOME / ".nvm/versions/node/v24.14.0/bin/npx")
PHP84 = str(HOME / "Library/Application Support/Herd/bin/php84")


def load_cursor_servers() -> dict:
    merged: dict = {}
    for src in SOURCES:
        if src.exists():
            data = json.loads(src.read_text(encoding="utf-8"))
            for name, cfg in (data.get("mcpServers") or {}).items():
                merged.setdefault(name, cfg)  # global mcp.json wins over project
    return merged


def normalize(cfg: dict) -> dict:
    if "url" in cfg:
        out = {"type": "http", "url": cfg["url"].replace("agent=cursor", "agent=claude")}
        if cfg.get("headers"):
            out["headers"] = cfg["headers"]
        return out
    cmd = cfg.get("command")
    if cmd == "npx":
        cmd = NPX
    elif cmd == "php":
        cmd = PHP84
    out = {"command": cmd, "args": list(cfg.get("args") or [])}
    if cfg.get("env"):
        out["env"] = cfg["env"]
    return out


def main() -> int:
    raw = load_cursor_servers()
    servers = {name: normalize(cfg) for name, cfg in raw.items()}
    servers.update(EXTRA_SERVERS)
    print("MCP servers to install (user scope, all instances):")
    for n, c in servers.items():
        kind = c.get("type", "stdio")
        print(f"  - {n:14} ({kind})")
    print()

    # The DEFAULT account stores its config in ~/.claude.json (HOME); the named
    # accounts use $CLAUDE_CONFIG_DIR/.claude.json. Remove any stray file wrongly
    # created inside the default's data dir.
    stray = HOME / ".claude" / ".claude.json"
    if stray.exists():
        stray.unlink()
        print(f"  removed stray {stray}")

    for cdir in CONFIG_DIRS:
        cdir.mkdir(parents=True, exist_ok=True)
        cj = (HOME / ".claude.json") if cdir == HOME / ".claude" else (cdir / ".claude.json")
        if cj.exists():
            data = json.loads(cj.read_text(encoding="utf-8"))
            cj.with_name(cj.name + f".bak.{int(time.time())}").write_text(
                json.dumps(data), encoding="utf-8"
            )
        else:
            data = {}
        data.setdefault("mcpServers", {})
        data["mcpServers"].update(servers)
        tmp = cj.with_name(cj.name + ".tmp")
        tmp.write_text(json.dumps(data, indent=2), encoding="utf-8")
        os.replace(tmp, cj)
        print(f"  {str(cj).replace(str(HOME), '~'):44} -> {sorted(data['mcpServers'])}")

    print("\nDone. All instances now expose these MCP servers globally (user scope).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
