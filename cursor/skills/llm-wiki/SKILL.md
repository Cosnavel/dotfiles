---
name: llm-wiki
description: 'Arbeitet mit dem persönlichen Wissens-Vault in ~/wiki (LLM-Wiki-Muster nach Karpathy, Obsidian-Frontend): Quellen ingesten, Fragen gegen das Wiki beantworten, Antworten einfilen, Lint-Checks. Nutzen bei "file das in mein Wiki", "ingest diese Quelle", "was wissen wir über X", "frag mein Wiki", "Wiki-Lint" oder wenn Wissen aus einem Projekt (Kettner, Belegify, …) dauerhaft festgehalten werden soll.'
---

# LLM-Wiki — der persönliche Wissens-Vault

Der Vault liegt in **`~/wiki`** und folgt dem LLM-Wiki-Muster: Der Mensch kuratiert Quellen und stellt Fragen, der Agent schreibt und pflegt das gesamte Wiki. Wissen wird einmal kompiliert und aktuell gehalten — nicht bei jeder Frage neu aus Rohdaten hergeleitet. Gelesen wird es in Obsidian (`[[Wikilinks]]` = Graph).

## Erster Schritt, immer

**`~/wiki/AGENTS.md` lesen** — das Schema dort ist die Autorität für Struktur, Seiten-Konventionen und Operationen. Dieses Skill ist nur der Wegweiser dorthin.

## Die drei Operationen (Kurzform)

- **Ingest:** Quelle nach `~/wiki/raw/<projekt>/` (unverändert!), vollständig lesen, Quellen-Seite in `wiki/quellen/` schreiben, alle berührten Entitäts-/Konzept-/Projekt-Seiten aktualisieren (10-15 Seiten sind normal), Widersprüche ausweisen, `index.md` + `log.md` nachziehen.
- **Query:** erst `index.md`, dann gezielt Seiten lesen, Antwort mit Zitaten. **Gute Antworten als neue Wiki-Seite einfilen** — Erkundungen müssen kumulieren.
- **Lint:** Widersprüche, Waisen-Seiten, fehlende Seiten/Querverweise, veraltete Claims finden und beheben.

## Harte Regeln

1. `raw/` ist unantastbar — lesen ja, ändern nie.
2. `log.md` ist append-only, Einträge im Format `## [YYYY-MM-DD] <operation> | <Titel>`.
3. **Keine Secrets in den Vault** — Quellen aus Firmen-Kontext vor dem Ingest um Credentials und personenbezogene Daten bereinigen.
4. Jede Wiki-Änderung endet mit aktualisiertem `index.md` und Log-Eintrag — sonst ist sie nicht passiert.
5. Quellcode-Inhalte gehören als destillierte Erkenntnis ins Wiki, nicht als Code-Kopie — das Repo bleibt die Quelle der Wahrheit für Code.

## Werkzeuge

Solange das Wiki klein ist, reicht `index.md` als Suche. Ab ~100 Quellen: `qmd` (lokale Hybrid-Suche, Setup in `~/wiki/SETUP.md`); wenn als MCP registriert, direkt als Tool nutzen. Reiche Antworten (Vergleiche, Reports, Decks) nach `~/wiki/artifacts/` — Muster im Skill `html-artifacts`.
