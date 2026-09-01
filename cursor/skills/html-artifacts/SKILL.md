---
name: html-artifacts
description: 'Erzeugt reichhaltige Einzeldatei-HTML-Artefakte als portable Canvas-Alternative in jeder Umgebung (Cursor, Claude Code, CLI): Specs und Implementierungspläne, PR-Explainer und annotierte Diffs, Reports, Explainer, SVG-Diagramme, Slide-Decks, Prototypen mit Slidern und Wegwerf-Editoren mit Export-Button. Nutzen bei "mach ein HTML-Artefakt", "als HTML statt Markdown", "Report/Plan/Deck/Explainer bauen", "Wegwerf-Editor für diese Daten" oder wenn ein Dokument über 100 Zeilen Markdown niemand mehr lesen würde.'
---

# HTML-Artefakte — Canvas überall

Ein Kommunikations-Skill. Es macht EINE Sache: aus Arbeitsergebnissen reichhaltige, selbst-enthaltene HTML-Einzeldateien machen, die Menschen wirklich lesen, anfassen und teilen — in jeder Umgebung. Es baut kein Produkt-UI (dafür `ui`/`design`), entscheidet keine UI-Varianten-Frage (dafür `prototype`) und ersetzt in Cursor nicht das native Canvas (`canvas`-Skill, `.canvas.tsx` neben dem Chat) — es ist dessen **portable** Geschwister für Claude Code, CLI und alles andere.

Ehrlicher Hinweis vorweg (von Thariq Shihipar selbst): Um HTML zu bekommen, braucht es kein Skill — „mach eine HTML-Datei" genügt. Der Wert dieses Skills liegt im Wissen, **was das Artefakt tun soll**: die Einsatzmuster, der Export-Trick und die Sichtprüfung.

## Wann HTML — und wann nicht

**HTML statt Markdown, wenn:** das Dokument länger als ~100 Zeilen würde und gelesen werden soll; Farben, Tabellen, SVG-Diagramme oder Layout Information tragen; Varianten **nebeneinander** verglichen werden sollen statt sequentiell gelesen; das Dokument geteilt wird (Browser rendert HTML nativ, die Chance, dass jemand die Spec liest, steigt massiv); oder Interaktion gebraucht wird (Slider, Drag, Live-Preview).

**Markdown bleibt richtig für:** alles, was primär **Agents** lesen (AGENTS.md, LEARNINGS.md, Skills, Rules) und alles Versionierte — HTML-Diffs sind im Review praktisch unlesbar. Ehrliche Kosten: HTML dauert 2-4× länger und kostet mehr Tokens; das lohnt für Kommunikations- und Wegwerf-Artefakte, nicht für jede Notiz.

## Handwerksregeln

1. **Eine self-contained Datei.** Inline-CSS/JS, SVG inline, kein Build-Step. Externe CDNs nur, wenn wirklich nötig — das Artefakt soll offline und in fünf Jahren noch aufgehen.
2. **Editoren enden IMMER mit Export.** „Copy as Markdown/JSON/Prompt"-Button, der das Interaktions-Ergebnis zurück in den Prompt oder ins Repo bringt. Ohne Rückkanal ist ein Editor eine Sackgasse — mit ihm wird die Schleife enger.
3. **Selbst ansehen, bevor es ausgeliefert wird.** Im Browser öffnen (macOS: `open artefakt.html`; in Cursor: chrome-devtools `new_page` mit `file://`-URL + `take_screenshot`), Konsole sauber, einmal durchklicken. Nie blind ausliefern — Loop schließen (`loop-engineering`).
4. **Ablage mit System:** `artifacts/` im Projekt- bzw. Task-Ordner, sprechende Namen mit Datum (`2026-08-12-checkout-plan.html`). In Loop-Werkstätten neben `out/`.
5. **Design-System-Referenz statt Ad-hoc-Ästhetik.** Einmal ein `design-system.html` aus der Codebase generieren lassen (Farben, Typo-Skala, Abstände als kopierbare Swatches) und bei jedem weiteren Artefakt als Referenz mitgeben — so sehen alle Artefakte nach dem Produkt aus. Im Kettner-Kontext: Inter, Gold `#BA9453`, `kettner-blue`/`kettner-green` als Anker; Anti-Slop-Regeln gelten auch hier (`ui-antislop`).
6. **Für einmaliges Lesen optimieren:** TL;DR-Box oben, klare Hierarchie, aufklappbare Details, Sprungmarken. Mobile-responsive, wenn es geteilt wird.

## Einsatzmuster-Katalog

| # | Muster | Was ins Artefakt gehört |
| --- | --- | --- |
| 1 | **Exploration & Planung** | Mehrere Richtungen als Grid nebeneinander, jede mit Trade-off-Label; Implementierungsplan mit Meilenstein-Timeline, Datenfluss-Diagramm, Mockups, den riskanten Code-Snippets und Risiko-Tabelle |
| 2 | **Code-Review & PR** | Annotierter Diff (Margin-Notes, Severity-Farben, Sprungmarken); PR-Writeup mit Motivation, Vorher/Nachher, Datei-Tour und Review-Fokus; Modul-Landkarte als Boxen + Pfeile mit Hot Path |
| 3 | **Design-Artefakte** | Lebendes Design-System als Swatch-Seite; Komponenten-Kontaktbogen (alle Größen/States/Intents auf einem Blatt) |
| 4 | **Prototypen** | Animations-Sandbox mit Slidern für Dauer/Easing + Copy-Parameter-Button; klickbarer Flow aus 3-4 verlinkten Screens |
| 5 | **Illustrationen & Diagramme** | Inline-SVG-Figurenblatt zum Einzeln-Herauskopieren; klickbares Flowchart (Schritt anklicken → Details, Timings, Fehlerpfade) |
| 6 | **Decks** | `<section>`-Tags + 20 Zeilen JS = Slide-Deck mit Pfeiltasten, kein Keynote, kein Export-Schritt |
| 7 | **Research & Explainer** | TL;DR-Box, aufklappbare Schritt-Sektionen, Code in Tabs, Glossar am Rand, FAQ unten — „für einmaliges Lesen optimiert" |
| 8 | **Reports** | Weekly Status (geliefert/verrutscht + Mini-Chart, für den Montags-Skim); Incident-Report mit minutengenauer Timeline, Log-Auszügen, Follow-up-Checkliste |
| 9 | **Wegwerf-Editoren** | Triage-Board (Karten über Now/Next/Later/Cut ziehen), Config-Editor mit Abhängigkeits-Warnungen, Prompt-Tuner mit Live-Preview — immer mit Export-Button |

Wegwerf-Editoren lohnen überall, wo sich etwas schlecht in Text ausdrücken lässt: Priorisieren und Bucketing, strukturierte Configs, Prompt-/Copy-Tuning mit Live-Preview, Datensätze kuratieren (approve/reject + Export), Dokumente/Diffs annotieren, und Werte wie Farben, Easing-Kurven, Crop-Regionen, Cron-Ausdrücke oder Regexe per UI wählen.

## Beispiel-Prompts (bewährt, anpassen)

> „Ich bin unsicher, in welche Richtung der Onboarding-Screen soll. Generiere 6 deutlich verschiedene Ansätze — Layout, Ton, Dichte variieren — als EINE HTML-Datei im Grid zum Nebeneinander-Vergleichen. Beschrifte jeden mit seinem Trade-off."

> „Erstelle einen gründlichen Implementierungsplan als HTML-Datei: Mockups, Datenfluss-Diagramm und die wichtigen Code-Snippets zum Reviewen. Beginne mit den Entscheidungen, die ich am ehesten ändern werde."

> „Hilf mir, diesen PR zu reviewen: HTML-Artefakt mit dem echten Diff, Margin-Annotationen, Findings nach Severity eingefärbt. Ich kenne die Streaming-/Backpressure-Logik nicht gut — fokussiere darauf."

> „Ich verstehe unseren Rate-Limiter nicht. Lies den Code und baue EINE HTML-Erklärseite: Token-Bucket-Diagramm, die 3-4 Schlüssel-Snippets annotiert, Gotchas-Sektion unten. Optimiert für einmaliges Lesen."

> „Ich muss diese 30 Tickets neu priorisieren. HTML-Datei mit jedem Ticket als Drag-Karte über Now/Next/Later/Cut, vorsortiert nach deiner Einschätzung. ‚Copy as Markdown'-Button, der die finale Reihenfolge mit je einer Zeile Begründung exportiert."

## Workflow-Anschluss

- **Als Rich Reference:** Spec-, Mockup- und Plan-Artefakte in die frische Implementierungs-Session mitgeben — HTML-Referenzen schlagen Prosa und Screenshots (siehe `loop-engineering/references/claude5-kontext-regeln.md`). Auch der Verifikations-Agent liest sie mit.
- **Netz statt Einzeldatei:** Bei größeren Vorhaben entsteht ein Geflecht — Brainstorm-Artefakt → Vertiefung → Mockup → Plan. Jedes verlinkt das nächste.
- **Teilen:** Datei hochladen (z. B. R2/S3) → Link verschicken; Kollegen öffnen es ohne Werkzeug im Browser.

## Tonalität

Das Artefakt dient dem Leser, nicht der Show: lieber eine klare Timeline und ein ehrliches Risiko-Kapitel als Deko. Wenn Markdown reicht (kurze Notiz, maschinen-gelesene Datei), sag das und bleib bei Markdown.
