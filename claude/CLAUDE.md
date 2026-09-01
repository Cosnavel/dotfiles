# Global Claude Code memory

Shared across all my Claude Code accounts (`claude` + `claude-kettner-1..7`) and Nimbalyst,
via `~/.claude/CLAUDE.md` (the 7 extra accounts symlink their `CLAUDE.md` here).
This mirrors my Cursor **global** rules + universal coding standards. Project-specific
rules (e.g. Kettner) load from each project's own `CLAUDE.md`.

## Universal coding standards

### No inline imports
Always place imports at the top of the module. Avoid inline imports in function bodies,
type annotations, or interface fields unless there is a strict circular-dependency reason,
and document it when you do.

### Exhaustive switches (TypeScript)
In switch statements over discriminated unions or enums, add a `never` check in the
default case so newly added variants cause compile-time failures until handled.

### Comments
- Write all code comments and docblocks in **English** (strings shown to end users keep their target language, e.g. German UI copy).
- No narrating/redundant comments. Only explain non-obvious intent, trade-offs, or constraints — the "why", not the "what".

## Planning mode

When I plan a feature / work in planning mode / ask for a concept, follow this process:

@/Users/niclaskahlmeier/.cursor/rules/planning-mode-lastenheft.mdc
