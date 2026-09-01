#!/usr/bin/env python3
"""Mark all git worktrees of a repo as TRUSTED for Claude Code, in every account.

Claude Code gates file/shell ops behind folder trust:
  ~/.claude.json -> projects.<abs-path>.hasTrustDialogAccepted
New worktrees start untrusted, and in a GUI (Nimbalyst) the trust prompt may not
surface -> writes/shell/status get hard-rejected regardless of permission mode.
This sets hasTrustDialogAccepted=true for every worktree of REPO across all 8
config dirs. Re-run after creating new worktrees.

Usage: trust_worktrees.py [repo-path ...]   (default: ~/projects/nimbalyst)
"""
import json
import os
import subprocess
import sys
import time
from pathlib import Path

HOME = Path.home()
REPOS = sys.argv[1:] or ["/Users/niclaskahlmeier/projects/nimbalyst"]
def _account_dirs():
    f = HOME / ".claude-tools" / "accounts.txt"
    if f.exists():
        d = [Path(l.strip()) for l in f.read_text(encoding="utf-8").splitlines()
             if l.strip() and not l.lstrip().startswith("#")]
        if d:
            return d
    return [HOME / ".claude"] + [HOME / f".claude-kettner-{i}" for i in range(1, 8)]


CONFIGS = [(HOME / ".claude.json") if d == HOME / ".claude" else (d / ".claude.json") for d in _account_dirs()]


def worktree_paths(repo: str) -> list[str]:
    try:
        out = subprocess.run(
            ["git", "-C", repo, "worktree", "list", "--porcelain"],
            capture_output=True, text=True,
        ).stdout
    except Exception:
        return []
    return [l[len("worktree "):] for l in out.splitlines() if l.startswith("worktree ")]


WT_ALLOW = ["Bash", "Read", "Edit", "Write", "Glob", "Grep",
            "WebFetch", "WebSearch", "NotebookEdit", "Task", "TodoWrite"]


def provision_worktree_settings(path: str) -> None:
    """Give a worktree a permissive .claude/settings.local.json (highest-precedence
    user-side scope) so sessions there run without per-command prompts. Merges with
    any existing approvals; bare 'Bash' allow supersedes the narrow auto-saved rules."""
    p = Path(path)
    if not p.is_dir():
        return
    cd = p / ".claude"
    cd.mkdir(parents=True, exist_ok=True)
    sf = cd / "settings.local.json"
    data = {}
    if sf.exists():
        try:
            data = json.loads(sf.read_text(encoding="utf-8"))
        except Exception:
            data = {}
    perms = data.setdefault("permissions", {})
    perms["defaultMode"] = "bypassPermissions"
    allow = perms.get("allow") or []
    for a in WT_ALLOW:
        if a not in allow:
            allow.append(a)
    perms["allow"] = allow
    perms.setdefault("deny", [])
    perms.setdefault("ask", [])
    sf.write_text(json.dumps(data, indent=2), encoding="utf-8")


def main() -> int:
    paths: list[str] = []
    for repo in REPOS:
        paths += worktree_paths(repo)
    paths = sorted(set(paths))
    if not paths:
        print("no worktrees found")
        return 1
    print(f"trusting + provisioning {len(paths)} path(s):")
    for p in paths:
        print(f"  {p}")
        provision_worktree_settings(p)

    for cf in CONFIGS:
        if cf.exists():
            data = json.loads(cf.read_text(encoding="utf-8"))
        else:
            data = {}
        projs = data.setdefault("projects", {})
        for p in paths:
            projs.setdefault(p, {})["hasTrustDialogAccepted"] = True
        cf.parent.mkdir(parents=True, exist_ok=True)
        tmp = cf.with_name(cf.name + ".tmp")
        tmp.write_text(json.dumps(data, indent=2), encoding="utf-8")
        os.replace(tmp, cf)
        print(f"  ✓ {str(cf).replace(str(HOME), '~')}")

    print("\nDone. Restart the Nimbalyst session(s) so Claude re-reads trust.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
