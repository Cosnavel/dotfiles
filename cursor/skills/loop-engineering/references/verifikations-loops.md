# Verifikations-Loops — Design, Eigenschaften, Failure-Modes

## Anatomie einer Schleife

Fünf Stufen (Kilo): **Intent** (Zieldefinition) → **Context** (Code, Docs, Fehler, Constraints einsammeln) → **Action** (kleinste kohärente Änderung) → **Observation** (Tests, Compiler, Logs, Diffs, Screenshots, Review-Kommentare) → **Adjustment** (Plan anpassen, wiederholen bis akzeptiert oder blockiert).

Als Coding-Takt: Plan → Search → Modify → **Verify** → Repair → Summarize. Die Kraft liegt nicht im einzelnen Schritt, sondern im Schließen der Schleife: Ein Testfehler ist nicht nur ein Fehler — er ist neuer Kontext. Ein Type-Error ist ein Signal über eine falsche Annahme.

## Der Check ist alles (Anthropic)

Der Agent stoppt, wenn die Arbeit fertig *aussieht*. Ohne selbst ausführbaren Check ist das das einzige Signal — jeder Fehler wartet dann darauf, dass ein Mensch ihn bemerkt. Mit Check schließt sich die Schleife von selbst: arbeiten, Check laufen lassen, Ergebnis lesen, iterieren bis grün.

Ein Check ist alles, was ein lesbares Signal liefert: Test-Suite, Build-Exit-Code, Linter, ein Skript das Output gegen eine Fixture difft, ein Browser-Screenshot verglichen mit dem Design.

**Eskalationsstufen, wie hart der Check das „Fertig" blockiert:**
1. **Im Prompt:** „Führe den Check aus und iteriere, bis er besteht."
2. **Als Session-Ziel:** Ein Evaluator prüft die Bedingung nach jedem Turn erneut.
3. **Deterministisches Gate:** Ein Stop-Hook führt den Check als Skript aus und blockiert das Beenden, bis er besteht.
4. **Zweitmeinung:** Ein Verifikations-Subagent mit frischem Kontext versucht, das Ergebnis zu widerlegen — wer die Arbeit macht, benotet sie nicht selbst.

**Visuelles Muster für UI/Print:** Zielbild bereitstellen → implementieren → eigenen Screenshot/Render erzeugen → beide vergleichen → Unterschiede auflisten → fixen. Nicht „mach es schöner", sondern „vergleiche und benenne die Differenzen".

**Evidenz-Regel:** Belege zeigen statt Erfolg behaupten — Testoutput, ausgeführtes Kommando samt Rückgabe, Screenshot. Evidenz zu reviewen ist schneller, als die Verifikation selbst zu wiederholen. Der Verifier soll Belege prüfen, die die Schleife selbst produzieren kann (Command-Output, geänderte Dateien, Traces).

**Rich References als Prüfmaßstab (Claude-5):** Der Maßstab, gegen den verglichen wird, darf reicher sein als Prosa — ein HTML-Mockup schlägt eine Design-Beschreibung und einen Screenshot; eine detaillierte Test-Suite IST eine Spezifikation; Quellcode (auch in fremder Sprache) ist die präziseste Referenz. Für Geschmacksfragen ohne Pass/Fail-Kriterium: **Rubrik** formulieren (z. B. „was ist gutes API-Design") und einen Verifier-Subagent damit prüfen lassen.

## Wann ein Loop lohnt (Willison)

Probleme mit **klaren Erfolgskriterien**, deren Lösung **Trial-and-Error** braucht: Debugging mit Tests, Performance-Optimierung mit Benchmark, Dependency-Upgrades mit grüner Suite, Container-Verkleinerung mit Größen-Messung. Gemeinsamer Nenner: automatisierte Tests amplifizieren den Wert massiv.

**Werkzeugwahl:** Shell-Befehle schlagen meist MCP — Agents sind hervorragend darin, Shell zu benutzen. Ein einziges Beispiel-Kommando in AGENTS.md genügt, damit der Agent Varianten ableitet (Beispiel: eine Zeile `shot-scraper http://example.com/ -w 800 -o example.jpg` — URL und Dateiname tauscht er selbst). Bekannte Tools (playwright, ffmpeg, poppler) muss man nicht erklären, nur benennen — die Schleife korrigiert anfängliche Fehlgriffe selbst.

## Eigenschaften guter Loops (Kilo)

- **Klare Objectives:** gewünschtes sichtbares Verhalten + relevante Dateien + unantastbare Constraints + Validierungs-Kommando + akzeptable Trade-offs. „Dashboard verbessern" ist kein Objective.
- **Richtige Kontextmenge:** zu wenig → falsche Annahmen; zu viel → Modell ertrinkt. Kontext vor dem Editieren sammeln, nach wichtigen Beobachtungen auffrischen.
- **Kleine reversible Aktionen:** kleinster kohärenter Diff, gezielte Validierung, erst dann erweitern.
- **Verlässliche Observability:** schnelle gezielte Tests, Typecheck/Lint, Build, Runtime-Logs, Screenshots/Browser-Checks für UI, Review-Kommentare.
- **Stopp-Regeln:** stoppen wenn Verhalten implementiert + Validierung grün; bei Blockern (fehlende Credentials/Daten/Produktentscheidung); vor destruktiven Kommandos ohne Freigabe; wenn der nächste Schritt fremde Änderungen anfassen würde; wenn das verbleibende Problem außerhalb des Scopes liegt.

## Failure-Modes und Gegenmittel

| Failure-Mode | Symptom | Gegenmittel |
| --- | --- | --- |
| **Thrashing** | Wiederholte Änderungen ohne Konvergenz | Ziel enger schneiden, Diff verkleinern, verlässlichere Beobachtungsquelle wählen; erst beweisen WO der Fehler liegt |
| **Overfitting auf Tests** | Tests grün, Produktziel verfehlt | Tests mit Anforderungs-Review und Sichtprüfung (Browser/Render) kombinieren |
| **Context Drift** | Arbeitet mit veralteten Annahmen weiter | Kontext nach bedeutenden Beobachtungen auffrischen; initialen Plan nicht als sakrosankt behandeln |
| **Unsichere Autonomie** | Destruktive Kommandos, fremde Dateien, ungefragte Pushes | Scoped Permissions, Freigaben für Risiko-Aktionen, explizite Stopp-Regeln |
| **Korrektur-Spirale** | 2+ Korrekturen am selben Problem, Kontext voller Fehlversuche | Stopp, Ursache reflektieren, Learning notieren, mit besserem Prompt/Ansatz frisch starten |

## Verifier-Design: das Review-Skill-Muster (Emil Kowalski)

Wie man eine Rubrik in einen scharfen Verifier gießt, konkret vorgeführt im global installierten Skill `review-animations`:

1. **Nicht verhandelbare Standards** — nummerierte Messlatte, jede Verletzung ist ein Finding („Default to flagging; approval is earned").
2. **Eskalations-Trigger** — Muster, die auf Sicht hart geflaggt werden (z. B. `transition: all`, `ease-in` auf UI).
3. **Remediale Hierarchie** — Fixes in Präferenz-Reihenfolge: erst löschen, dann reduzieren, dann reparieren, zuletzt polieren.
4. **Erzwungenes Output-Format** — Findings-Tabelle (Before/After/Why) plus nach Impact gestaffeltes Verdikt.
5. **Explizite Entscheidung** — Block oder Approve mit benannten Kriterien, `file:line`-Zitate Pflicht.

Dasselbe Gerüst funktioniert für jede Geschmacks- oder Qualitätsdomäne (Print-Layout, Copy, API-Design): Standards + Trigger + Hierarchie + Format + Verdikt = ein Verifier ohne eigenen Geschmacks-Spielraum.

## Frische-Augen-Review

Je länger unbeaufsichtigt gearbeitet wurde, desto wichtiger die unabhängige Prüfung: Ein Reviewer in frischem Kontext sieht nur Diff/Artefakt und die Kriterien — nicht die Argumentation, die zur Änderung führte. Writer/Reviewer-Muster: Session A implementiert, Session B prüft auf Edge Cases und Konsistenz, A arbeitet das Feedback ab. Wichtig: Reviewer nur auf Korrektheits-Gaps gegen die Kriterien ansetzen — ein Reviewer, der „Findings" liefern soll, findet immer welche; alles jenseits von Korrektheit und Anforderungen ist optional, sonst entsteht Over-Engineering.

## Orchestrierungs-Muster für lange Läufe (obra/superpowers)

Destillat aus `subagent-driven-development` — für Läufe mit vielen Tasks und Subagents:

- **Ledger statt Gedächtnis:** Append-only-Fortschrittsdatei mit Task-Status und Commit-Ranges. Nach Kontext-Kompaktion gelten Ledger + `git log`, nicht die eigene Erinnerung — der teuerste beobachtete Fehler sind Controller, die komplette erledigte Task-Sequenzen erneut dispatcht haben.
- **Artefakte als Dateien übergeben** (Task-Briefs, Diffs, Reports): Alles, was in einen Dispatch-Prompt gepastet wird, bleibt für den Rest der Session im Kontext und wird bei jedem Turn erneut gelesen. Ein Dispatch beschreibt EINEN Task, nie die Session-Historie.
- **Fix-Schleife mit Kappe:** Maximal 5 Runden pro Task. Runde 1-3 denselben Implementer fortsetzen (Kontext intakt), Runde 4-5 frischer Implementer auf stärkerem Modell („ein Loop, der drei Resumes überlebt, heißt: der Implementer sieht sein eigenes Problem nicht"). Danach adjudizieren: parken mit schriftlicher Begründung oder BLOCKED an den Menschen — nie stillschweigend verwerfen.
- **Modellwahl pro Rolle:** das schwächste Modell, das die Rolle trägt — aber **Turn-Anzahl schlägt Token-Preis** (billigste Modelle brauchen auf mehrschrittiger Arbeit 2-3× so viele Turns und kosten unterm Strich mehr). Finaler Branch-Review immer aufs stärkste verfügbare Modell.
- **Reviewer nie vor-urteilen:** „Flagge X nicht" gehört nicht in einen Review-Prompt. Findings raisen lassen und selbst adjudizieren — sonst spart man sich Review-Schleifen auf Kosten der Wahrheit.

## Wiederverwendbare Loops

Funktionierende Workflows als Standard-Loops festhalten (Dependency-Upgrade, Incident-Fix, PR-Kommentar-Abarbeitung, UI-Politur, Test-Reparatur): Prompts, Validierungs-Kommandos und Stopp-Regeln müssen nicht pro Aufgabe neu erfunden werden.

---
Quellenbasis: Anthropic (Claude Code Best Practices), Simon Willison (Designing Agentic Loops), Kilo (Loop Engineering), Community-Synthese zu Agentic-Loop-Papers.
