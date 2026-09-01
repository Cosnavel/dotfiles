#!/usr/bin/env python3
"""Sync Cursor commands + skills into a single shared Claude Code skills directory.

Re-runnable. Rebuilds ~/.claude-shared/skills/ from Cursor sources:
  - Cursor COMMANDS (global ~/.cursor/commands + project .cursor/commands)
      -> wrapped into Claude Code skills (invokable as /name, manual only)
  - Cursor SKILLS (global ~/.cursor/skills-cursor, optional ~/.cursor/skills,
      project .cursor/skills, and cursor-team-kit plugin skills)
      -> copied verbatim (they already use the SKILL.md + frontmatter format)

All 8 Claude config dirs symlink their `skills` dir to ~/.claude-shared/skills,
so every instance mirrors the exact same set. Re-run after editing Cursor.
"""

import json
import re
import shutil
import sys
from pathlib import Path

HOME = Path.home()
SHARED = HOME / ".claude-shared" / "skills"
REPO = Path("/Users/niclaskahlmeier/kettner/kettner-project/kettner-worker")

COMMAND_SOURCES = [
    ("global", HOME / ".cursor" / "commands"),
    ("kettner", REPO / ".cursor" / "commands"),
]

SKILL_SOURCES = [
    HOME / ".cursor" / "skills-cursor",   # Cursor built-in/global skills
    HOME / ".cursor" / "skills",          # personal global skills (if present)
    REPO / ".cursor" / "skills",          # project (kettner) skills
]

# cursor-team-kit (and any other) plugin skills live behind a content-hash dir.
PLUGIN_SKILL_GLOB = ".cursor/plugins/cache/*/*/*/skills"

# High-quality descriptions for known commands. Anything not listed gets a
# description derived from the file's first heading/line.
CURATED = {
    "yolo": "YOLO mode: production-DB-safe deep research with a massive parallel subagent council. Read-only DB exploration is unrestricted; every write requires explicit confirmation.",
    "deep-research": "Ultra deep research mode: exhaustively map a problem and ALL its dependencies using many parallel exploration subagents, then summarize with a dependency graph.",
    "prod": "Production-DB safety mode: unrestricted read access, but every write requires explicit step-by-step confirmation; destructive commands are forbidden.",
    "council": "Spawn ~10 parallel exploration subagents (some intentionally out-of-the-box) to investigate an area of the codebase, then act on the findings.",
    "aislop": "Remove AI-generated slop from the current branch diff vs main (stray comments, abnormal try/catch, any-casts, inconsistent style). Report a 1-3 sentence summary.",
    "question": "Ask the user ~5 critical clarifying questions before implementing anything; wait for answers before proceeding.",
    "merge": "Resolve all git merge conflicts on the current branch non-interactively, make the repo build and pass tests, and commit the resolution.",
    "prcomment": "Fetch and display all review comments from the active PR for the current branch and summarize the requested action items.",
    "general-push": "Stage all changes (including untracked), remove debug instrumentation, then push with a clean conventional-commit message.",
    "push": "Stage all changes (including untracked), remove debug instrumentation, then push with a clean conventional-commit message.",
    "iterate-browser": "Iterate on the current task autonomously using debug.log traces and browser tools; never ask the user to test manually.",
    "fix-bugbot-comments": "Fetch Bugbot comments from the GitHub API for this PR, summarize and triage valid vs false-positive, then fix the valid ones.",
    "bugbot-control": "End-to-end Bugbot workflow on the current PR: find unresolved Bugbot review threads, fix real bugs or reply to false positives, then resolve each thread.",
    "mermaid": "Visualize the data lineage of the referenced code or project as a Mermaid diagram.",
    "commit": "Create a git commit for the current changes following the repository's conventional-commit style.",
    "lastenheft": "Create a detailed German requirements specification (Lastenheft) for a feature, following the project's docs templates.",
    "weekly-report": "Generate a weekly report summarizing the work and commits over the past week.",
}

INVALID = re.compile(r"[^a-z0-9-]")


def slug(name: str) -> str:
    return INVALID.sub("-", name.lower()).strip("-")[:64]


def strip_frontmatter(text: str) -> str:
    if text.startswith("---"):
        m = re.match(r"^---\s*\n.*?\n---\s*\n?", text, re.S)
        if m:
            return text[m.end():]
    return text


def derive_desc(name: str, text: str) -> str:
    if name in CURATED:
        return CURATED[name]
    for line in strip_frontmatter(text).splitlines():
        s = line.strip()
        if not s:
            continue
        s = re.sub(r"^#+\s*", "", s)
        s = re.sub(r"^[-*]\s+", "", s)
        s = s.strip("*_` ")
        if s:
            title = re.sub(r"\s+", " ", s)[:200]
            return f"{title} (Cursor command '/{name}', ported as a manual skill)."
    return f"Cursor command '/{name}', ported as a manual skill."


def yaml_dq(s: str) -> str:
    return '"' + s.replace("\\", "\\\\").replace('"', "'").replace("\n", " ") + '"'


def has_skill_md(d: Path) -> bool:
    return (d / "SKILL.md").is_file()


def main() -> int:
    if SHARED.exists():
        shutil.rmtree(SHARED)
    SHARED.mkdir(parents=True, exist_ok=True)

    used: dict[str, str] = {}   # skill name -> source description
    report = {"skills": [], "commands": [], "collisions": [], "skipped": []}

    def claim(name: str) -> str:
        n = name
        i = 2
        while n in used:
            n = f"{name}-{i}"
            i += 1
        return n

    # 1) Copy real skills verbatim
    skill_dirs: list[Path] = []
    for root in SKILL_SOURCES:
        if root.is_dir():
            skill_dirs += [p for p in sorted(root.iterdir()) if p.is_dir() and has_skill_md(p)]
    for skills_root in sorted(HOME.glob(PLUGIN_SKILL_GLOB)):
        if skills_root.is_dir():
            skill_dirs += [p for p in sorted(skills_root.iterdir()) if p.is_dir() and has_skill_md(p)]

    for src in skill_dirs:
        name = slug(src.name)
        if name in used:
            new = claim(name)
            report["collisions"].append(f"skill {src} -> {new} (was {name})")
            name = new
        used[name] = "skill"
        shutil.copytree(src, SHARED / name)
        report["skills"].append(name)

    # 2) Wrap commands into skills (manual /name invocation)
    global_cmd_names: set[str] = set()
    for tag, root in COMMAND_SOURCES:
        if not root.is_dir():
            continue
        for f in sorted(root.glob("*.md")):
            base = slug(f.stem)
            name = base
            if tag == "kettner" and base in global_cmd_names:
                name = f"{base}-kettner"
            if name in used:
                name = claim(f"{name}-cmd")
                report["collisions"].append(f"command {f} -> {name}")
            text = f.read_text(encoding="utf-8", errors="replace")
            desc = derive_desc(base, text)
            body = strip_frontmatter(text).lstrip("\n")
            out = SHARED / name
            out.mkdir(parents=True)
            (out / "SKILL.md").write_text(
                "---\n"
                f"name: {name}\n"
                f"description: {yaml_dq(desc)}\n"
                "disable-model-invocation: true\n"
                "---\n\n"
                f"{body}\n",
                encoding="utf-8",
            )
            used[name] = "command"
            if tag == "global":
                global_cmd_names.add(base)
            report["commands"].append(name)

    (SHARED.parent / "sync-report.json").write_text(json.dumps(report, indent=2), encoding="utf-8")

    print(f"Shared skills dir: {SHARED}")
    print(f"  skills copied  : {len(report['skills'])}")
    print(f"  commands wrapped: {len(report['commands'])}")
    print(f"  collisions handled: {len(report['collisions'])}")
    print(f"  total skills   : {len(used)}")
    if report["collisions"]:
        print("  -- collisions --")
        for c in report["collisions"]:
            print(f"     {c}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
