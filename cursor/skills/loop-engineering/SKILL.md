---
name: loop-engineering
description: 'Destilliertes Wissen zu selbstlernenden Agent-Loops: Verifikations-Schleifen, Kontext-Dateien (AGENTS.md/CLAUDE.md/LEARNINGS.md), Compounding/Selbstlernen, HTML-zu-PDF-Print-Pipelines. Nutzen bei /one-shot, Loop-Werkstätten, Print-/PDF-Projekten, Knowledge-System-Design oder wenn ein Agent blind baut statt selbst zu verifizieren.'
---

# Loop Engineering — Wissensbasis

Eingebettetes Destillat aus der Deep Research (08/2026) zu selbstlernenden, selbstüberprüfenden Arbeitsschleifen — inklusive der neuen Claude-5-Kontextregeln und der Unknowns-Methodik aus dem Fable Field Guide. Selbst-enthaltend, keine externen Links nötig. Der Command `/one-shot` orchestriert die Anwendung; dieses Skill liefert das Warum und die Tiefe.

## Die 12 Kernprinzipien

1. **Der Check schließt die Schleife.** Ohne selbst ausführbare Prüfung ist „sieht fertig aus" das einzige Signal — und der Mensch wird zum Verifikations-Loop. Gib dir selbst etwas, das Pass/Fail liefert: Test, Build-Exit-Code, Linter, Diff-Skript, Screenshot-Vergleich gegen Zielbild.
2. **Loop schlägt Prompt.** Prompt Engineering formt die Eingabe, Loop Engineering formt das System drumherum: Werkzeuge, Kontext, Validierung, Stopp-Regeln. Die erste Antwort darf unvollständig sein — die Schleife macht daraus verifizierten Fortschritt.
3. **Vom Ergebnis her denken.** Klare Erfolgskriterien + Trial-and-Error-Charakter = ideales Loop-Terrain. Der Gedanke „ugh, da muss ich viele Varianten durchprobieren" ist das Signal, eine Schleife zu designen statt zu prompten.
4. **Kleinstmögliche Menge hochsignaliger Tokens.** Kontext ist ein endliches Attention-Budget (Context Rot: Recall sinkt mit Kontextlänge). Zeilen-Test für jede Kontext-Datei: „Würde das Fehlen dieser Zeile zu Fehlern führen?" Wenn nein: raus.
5. **Regeln entstehen aus beobachteten Fehlern,** nicht spekulativ. Auto-generierte, redundante Kontext-Dateien können schlechter sein als gar keine. Klein starten, bei Fehlern wachsen.
6. **Kleine reversible Schritte.** Ein kleiner Diff ist leichter zu verifizieren und zu reparieren. Große spekulative Umbauten verstecken, welche Annahme gescheitert ist.
7. **Evidenz statt Behauptung.** Ergebnis zeigen (Testoutput, gerenderte Seiten, Screenshot) statt Erfolg zu versichern. Der Verifier soll Belege prüfen, die die Schleife selbst produziert.
8. **Jede Korrektur ist eine permanente Lektion.** Compounding: Jeder Bugfix ist halbfertig, wenn er nicht seine ganze Fehlerklasse verhindert. Leitfrage bei jeder Arbeit: „Lehre ich das System oder löse ich nur das heutige Problem?"
9. **Dateisystem als Gedächtnis.** Vier Kanäle: Git-Historie, Fortschritts-Log, Task-Status, Wissensdatei. Notizen außerhalb des Kontextfensters überleben jeden Reset.
10. **Wiederverwendbare Loops kodifizieren.** Funktioniert ein Workflow, wird er festgehalten (Command, Skill, AGENTS.md) — beim nächsten Mal heißt es nur noch „nutze den Workflow von X". Das ist der 1-%-Effekt.
11. **Prozess hart, Inhalt frei.** Claude-5-Modelle leiden unter Über-Constraining: >80 % des Claude-Code-System-Prompts waren ersatzlos löschbar. Die Schleifen-Disziplin bleibt Pflicht (sie ist Verifikations-Infrastruktur) — Stil- und Detailentscheidungen trifft das Modell am umgebenden Kontext. Widersprüchliche Regeln sind teurer als fehlende.
12. **Unknowns zuerst, billig entdecken.** Die Qualität ist durch ungeklärte Unknowns begrenzt, nicht durchs Modell. Blind-Spot-Pass, Interview (eine Frage nach der anderen, Architektur-Fragen zuerst), Wegwerf-Prototypen zum Reagieren und Referenzen in Code/HTML statt Prosa — jedes davon ist ein billiger Weg, Wissen zu finden, bevor Fehler teuer werden.

## Referenzen (bei Bedarf lesen)

| Datei | Inhalt | Wann lesen |
| --- | --- | --- |
| `references/verifikations-loops.md` | Loop-Anatomie, Check-Eskalationsstufen, Eigenschaften guter Loops, Failure-Modes | Loop für eine neue Aufgabe designen; Agent dreht sich im Kreis |
| `references/kontext-dateien.md` | AGENTS.md/CLAUDE.md Best Practices, Memory-Bank-Hierarchie, Progressive Disclosure, Messwerte | Kontext-Infrastruktur anlegen oder aufräumen |
| `references/selbstlernen.md` | Learnings-Protokoll, Compounding-Workflow, Ralph-Loop, Notizen & Kompaktion | Selbstlern-Mechanik einbauen; Wissen destillieren |
| `references/print-pdf-pipeline.md` | Komplettes HTML→PDF-Rezept mit validierten Befehlen und allen bekannten Fallen | Jede Print-/Broschüren-/PDF-Aufgabe |
| `references/claude5-kontext-regeln.md` | Früher→Heute der Kontextregeln für Claude-5-Modelle: Urteilsvermögen, Interfaces, Rich References, Auto-Memory | Kontext-Dateien/Skills schreiben oder entschlacken; Regel-Konflikte |
| `references/unknowns-entdecken.md` | Karte vs. Territorium, vier Unknowns-Quadranten, Muster mit Prompt-Vorlagen (Blind-Spot-Pass, Interview, Prototypen, Deviations-Log, Quiz) | Aufgabenstart in fremdem Terrain; Geschmacksfragen; Long-Horizon-Task kam falsch zurück |
| `references/debugging.md` | Systematisches Debugging: Root Cause vor Fix, vier Phasen, 3-Fixes-Architektur-Eskalation, Rationalisierungs-Tabelle | Jeder Bug, Testfehler, unerwartetes Verhalten — BEVOR ein Fix vorgeschlagen wird |

## Quellenbasis

Anthropic Engineering (Claude Code Best Practices; Effective Context Engineering; New Rules of Context Engineering für Claude-5-Modelle), Thariq Shihipar/Anthropic (Fable Field Guide: Finding your unknowns), Simon Willison (Designing Agentic Loops), Addy Osmani (Self-Improving Coding Agents), Kieran Klaassen/Every (Compounding Engineering), GitHub Engineering (Analyse von 2.500+ agents.md), Cline Docs (Memory Bank), Kilo (Loop Engineering), André Arko (Chrome-Headless-PDF), Augment Code, AI Hero, MindStudio. Inhalte destilliert und lokal eingebettet, Stand 08/2026.
