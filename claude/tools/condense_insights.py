#!/usr/bin/env python3
"""Condense .cursor/rules/learned-insights.mdc.

Shrinks each `### entry` to its essential takeaway while preserving every specific
identifier (paths, class/method/column/table names, config keys, thresholds,
command names, error strings). Processes entries in batches via `claude -p` to
avoid output truncation. Never loses an entry: on any batch problem it keeps the
original text for that batch. The meta header (everything before the first `###`)
is preserved verbatim. Backs up the original before writing.

Usage: condense_insights.py [--force]   (without --force, skips if already small)
"""
import re
import subprocess
import sys
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

HOME = Path.home()
CLAUDE = str(HOME / ".claude" / "local" / "claude")
# Optional positional arg overrides the default target (e.g. a worktree's copy).
_POS = [a for a in sys.argv[1:] if not a.startswith("--")]
TARGET = Path(_POS[0]) if _POS else Path(
    "/Users/niclaskahlmeier/kettner/kettner-project/kettner-worker/.cursor/rules/learned-insights.mdc"
)
BATCH = 8
MIN_BYTES = 50_000

PROMPT = (
    "You are AGGRESSIVELY condensing a German technical 'learned insights' file. "
    "For EACH entry, rewrite the body to ONE concise sentence (~30 words) giving the "
    "single key rule/gotcha + its fix. KEEP verbatim every critical identifier (file "
    "paths, class/method/column/table names, config keys, numeric thresholds, command "
    "names, queue names, error strings) — those are the value. DROP examples, "
    "parentheticals, background, history, and secondary edge-cases. Keep the original "
    "language (German). Do NOT merge, drop, reorder, or invent entries. Keep each '### ' "
    "heading line EXACTLY as-is. No commentary, no code fences. Output ONLY the condensed "
    "entries, same order.\n\n"
)


def split_entries(text: str) -> list[str]:
    return [p for p in re.split(r"(?m)^(?=### )", text) if p.strip()]


def condense_batch(text: str) -> str:
    try:
        r = subprocess.run(
            [CLAUDE, "-p", PROMPT + text, "--max-turns", "1",
             "--strict-mcp-config", "--disable-slash-commands"],  # skip MCP + skills load = fast startup
            capture_output=True, text=True, stdin=subprocess.DEVNULL, timeout=300,
            cwd=str(HOME),  # neutral cwd: don't reload the repo CLAUDE.md (which imports this file)
        )
    except Exception as e:
        print(f"    claude error: {e}")
        return ""
    out = re.sub(r"(?m)^```.*$", "", r.stdout).strip()
    i = out.find("### ")
    return out[i:] if i >= 0 else ""


def main() -> int:
    force = "--force" in sys.argv
    content = TARGET.read_text(encoding="utf-8")
    if not force and len(content.encode()) < MIN_BYTES:
        print(f"skip: {len(content.encode())} bytes < {MIN_BYTES} (use --force to override)")
        return 0

    m = re.search(r"(?m)^### ", content)
    if not m:
        print("no entries found")
        return 1
    header = content[: m.start()].rstrip()
    entries = split_entries(content[m.start():])
    print(f"entries: {len(entries)}")

    batches = [entries[i : i + BATCH] for i in range(0, len(entries), BATCH)]
    results: list[list[str]] = [[] for _ in batches]

    def work(idx: int, batch: list[str]):
        got = split_entries(condense_batch("".join(batch)))
        if len(got) == len(batch):
            return idx, [e.strip() for e in got], True
        return idx, [e.strip() for e in batch], False  # safe fallback: keep originals

    with ThreadPoolExecutor(max_workers=5) as ex:
        futs = [ex.submit(work, i, b) for i, b in enumerate(batches)]
        for f in as_completed(futs):
            idx, ents, ok = f.result()
            results[idx] = ents
            print(f"  batch {idx + 1}/{len(batches)}: {'condensed' if ok else 'kept original'} ({len(ents)})", flush=True)

    out_entries = [e for r in results for e in r]

    new = header + "\n\n" + "\n\n".join(out_entries) + "\n"
    backups = HOME / ".claude-tools" / "backups"
    backups.mkdir(parents=True, exist_ok=True)
    (backups / f"learned-insights.{int(time.time())}.mdc").write_text(content, encoding="utf-8")
    TARGET.write_text(new, encoding="utf-8")
    print(f"done: {len(content):,} -> {len(new):,} chars  ({len(entries)} entries preserved)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
