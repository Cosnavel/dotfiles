# Kontext-Dateien — AGENTS.md, CLAUDE.md, Memory-Strukturen

## Rollenverteilung

| Datei | Für wen | Inhalt |
| --- | --- | --- |
| `README.md` | Menschen | Quick Start, Projektbeschreibung, Contribution |
| `AGENTS.md` | alle AI-Agents (Cursor, Claude Code, Copilot, Codex, …) | Build-/Test-Kommandos, Konventionen, Grenzen |
| `CLAUDE.md` | nur Claude Code | Claude-Spezifika; zum Teilen erste Zeile `@AGENTS.md` (Import) |

**Nearest file wins:** Agents lesen die nächstgelegene Datei zur bearbeiteten Stelle — im Monorepo bekommt jedes Teilprojekt seine eigene AGENTS.md mit zugeschnittenen Anweisungen. In der Praxis sind 90 %+ des Inhalts über alle Tools identisch → eine AGENTS.md pflegen, Tool-Spezifisches in die native Datei.

## Das Budget-Prinzip (Anthropic)

Kontext ist ein endliches **Attention-Budget**: Mit wachsender Tokenzahl sinkt die Fähigkeit des Modells, Informationen daraus präzise abzurufen (**Context Rot** — n² Attention-Beziehungen werden dünn gestreckt). Gutes Context Engineering heißt: die **kleinstmögliche Menge hochsignaliger Tokens**, die das gewünschte Verhalten maximal wahrscheinlich macht. Minimal heißt nicht kurz um jeden Preis — es heißt: nichts drin, was das Modell selbst herleiten kann.

**Zeilen-Test:** „Würde das Entfernen dieser Zeile zu Fehlern führen?" Wenn nein: löschen. Aufgeblähte Kontext-Dateien führen dazu, dass die tatsächlich wichtigen Regeln ignoriert werden. Wenn der Agent trotz Regel etwas Falsches tut, ist die Datei vermutlich zu lang und die Regel geht unter.

## Was rein gehört — und was nicht

| Rein | Raus |
| --- | --- |
| Kommandos, die der Agent nicht erraten kann (mit Flags!) | Alles, was er durch Code-Lesen selbst herausfindet |
| Stil-Regeln, die von Defaults abweichen | Standard-Konventionen, die das Modell kennt |
| Test-Anweisungen + bevorzugter Runner | Ausführliche API-Doku (stattdessen Pfad/Verweis) |
| Repo-Etikette (Branch-Namen, PR-Konventionen) | Häufig wechselnde Information |
| Architektur-Entscheidungen, die von außen falsch aussehen, aber gewollt sind | Datei-für-Datei-Beschreibungen der Codebase |
| Gotchas und nicht-offensichtliches Verhalten | Selbstverständlichkeiten („schreib sauberen Code") |

**Regeln entstehen als Reaktion auf beobachtete Fehler, nicht spekulativ** (Augment Code). Der Reflex „Agent macht Fehler → neue Regel" plus „Regeln werden nie gelöscht" erzeugt eine Datei voller widersprüchlicher Patches. Datei wie Code behandeln: reviewen wenn etwas schiefgeht, regelmäßig prunen, Änderungen daran testen, ob sich das Verhalten wirklich ändert.

## Befunde aus 2.500+ analysierten agents.md (GitHub Engineering)

Die erfolgreichen Dateien machen konsistent fünf Dinge:
1. **Kommandos früh** und ausführbar: `npm test`, `pytest -v` — mit Flags, nicht nur Toolnamen.
2. **Ein echtes Code-Beispiel** schlägt drei Absätze Beschreibung. Zeigen, wie guter Output aussieht.
3. **Grenzen in drei Stufen:** ✅ Immer tun / ⚠️ Erst fragen / 🚫 Nie tun (z. B. „nie Secrets committen", „nie `vendor/` anfassen").
4. **Stack konkret mit Versionen:** „React 18 mit TypeScript, Vite, Tailwind" statt „React-Projekt".
5. **Sechs Kernbereiche abdecken:** Kommandos, Testing, Projektstruktur, Code-Stil, Git-Workflow, Grenzen.

Klein starten, testen, Detail ergänzen, wenn der Agent Fehler macht — die besten Dateien wachsen durch Iteration, nicht durch Vorab-Planung.

**Messwerte** (Codex-Benchmark, 124 gemergte PRs, 10 Repos): Mit AGENTS.md ~29 % schnellere Task-Erledigung und ~17 % weniger Tokens — die Datei erspart die Explorationsphase. Aber: Von Hand geschriebene Dateien schlagen auto-generierte; eine generierte Datei voller Redundanz kann schlechter sein als gar keine.

## Progressive Disclosure

Statt alles in eine Datei zu stopfen: Der Kern bleibt schlank und **verweist** auf Detail-Dateien, die der Agent bei Bedarf lädt (Agents navigieren Doku-Hierarchien schnell). Beispiel: statt 30 TypeScript-Regeln inline nur `Für TypeScript-Konventionen: docs/TYPESCRIPT.md`. Genau dieses Muster implementieren Skills: Beschreibung immer geladen, Inhalt on demand.

**Just-in-time-Kontext** (Anthropic): Leichte Identifier (Dateipfade, Queries, Links) statt vorab alles laden; der Agent holt Daten zur Laufzeit. Das Dateisystem ist externes Gedächtnis — Ordnerhierarchien, Namenskonventionen und Timestamps sind selbst Signale (eine `test_utils.py` in `tests/` bedeutet etwas anderes als in `src/core_logic/`).

## Hierarchie-Muster: Memory Bank (Cline)

Bewährte Dateistruktur für Projekt-Gedächtnis, hierarchisch aufeinander aufbauend:

| Datei | Zweck | Update-Frequenz |
| --- | --- | --- |
| `projectbrief.md` | Fundament: Kern-Anforderungen und Ziele, Source of Truth für Scope | selten |
| `productContext.md` | Warum das Projekt existiert, welche Probleme es löst | selten |
| `activeContext.md` | Aktueller Fokus, jüngste Änderungen, nächste Schritte, **Learnings** | nach jeder Session |
| `systemPatterns.md` | Architektur, Entscheidungen, Muster, kritische Pfade | bei neuen Mustern |
| `techContext.md` | Stack, Setup, Constraints, Tool-Nutzung | bei Änderungen |
| `progress.md` | Was funktioniert, was fehlt, bekannte Issues, Entscheidungs-Historie | an Meilensteinen |

Kommandos des Musters: „initialize memory bank" (anlegen), „update memory bank" (vollständiger Review aller Dateien — vor Kontext-Resets nutzen!), „follow your custom instructions" (einlesen und weitermachen). Mit Basis-Brief starten und die Struktur organisch wachsen lassen. Für kleinere Loop-Werkstätten reicht die reduzierte Variante: AGENTS.md + TARGET.md + LEARNINGS.md + PROGRESS.md.

## Claude-5-Update: Über-Constraining ist der neue Bloat

Für die neueste Modellgeneration (Opus 5, Fable 5) gilt verschärft: Anthropic konnte >80 % des eigenen System-Prompts ersatzlos streichen. Harte Stil-Regeln („NIE Kommentare") ersetzt durch Urteilsvermögen am umgebenden Code; Anweisungen werden nicht mehr wiederholt; Memory landet automatisch. **Nuance zum Beispiel-Befund oben:** Stil-/Output-Beispiele bleiben wertvoll — aber Werkzeug-*Nutzungs*-Beispiele engen neue Modelle ein; dort lieber ausdrucksstarke Interfaces designen (sprechende Parameter, Enums, die das Verhalten selbst erklären). Details und die Früher→Heute-Tabelle: `claude5-kontext-regeln.md`.

## Wissensdatei-Sektionen (Osmani)

Bewährte Gliederung für die wachsende Wissensdatei: **Patterns & Conventions** (High-Level-Muster), **Gotchas** (was Agents/Entwickler schon gestolpert hat), **Style/Preferences**, **Recent Learnings**. Einträge kurz und faktisch — sie sind Prompt-Additive, keine Prosa. Gegen Bloat: Veraltetes archivieren statt endlos wachsen lassen; thematisch splitten und nur relevante Teile injizieren. Periodisch verifizieren, dass die Memory-Dateien wirklich im Prompt landen — eine Wissensdatei, die niemand lädt, hilft nicht.

---
Quellenbasis: Anthropic (Claude Code Best Practices; Effective Context Engineering), GitHub Engineering (2.500-Repo-Analyse), agents.md-Standard, Augment Code, AI Hero (Progressive Disclosure), Morph (Codex-Benchmark), Cline Docs (Memory Bank), Addy Osmani.
