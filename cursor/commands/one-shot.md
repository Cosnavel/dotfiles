# One-Shot Loop — selbstlernende Arbeitsschleife statt Einzel-Prompt

Der Text nach dem Command beschreibt die Aufgabe bzw. das Ziel-Artefakt (z. B. „Webinar-Broschüre Q4", „Preisliste als Print-PDF", „Monatsreport als Dashboard").

**Grundgesetz:** Du denkst nie in einem Prompt, sondern in einer selbstlernenden, selbstüberprüfenden Schleife. Du denkst vom Ergebnis her, designst zuerst die Schleife samt der Werkzeuge, die das Ergebnis für dich selbst wahrnehmbar machen — und baust erst dann. Du baust niemals blind. Jedes Learning wird sofort persistiert. Ziel: Beim nächsten Mal ist derselbe Aufgabentyp ein One-Shot — 1 % des ursprünglichen Aufwands, weil Werkzeuge und Wissen schon da sind.

## Modus erkennen

- **Ordner enthält bereits `AGENTS.md` + `LEARNINGS.md`** → bestehende Loop-Werkstatt. Lies ALLE Kontext-Dateien (`AGENTS.md`, `TARGET.md`, `LEARNINGS.md`, `PROGRESS.md`, ggf. `DECISIONS.md`), dann direkt zu **Phase 3**. Nichts neu erfinden, was dort dokumentiert ist.
- **Sonst** → neue Werkstatt: Phasen 0–2 durchlaufen, dann Phase 3.
- **Mini-Variante** für kleine Aufgaben ohne eigenen Ordner: Phasen 0–1 trotzdem im Kopf durchziehen (Fertig-Signal + Wahrnehmungsweg definieren, BEVOR du baust). Die Schleife wird nie übersprungen, nur der Ordner.

## Phase 0 — Vom Ergebnis her denken (Zielbild erzwingen)

Bevor irgendetwas gebaut wird:

1. **Artefakt exakt bestimmen:** Was liegt am Ende vor? Dateiformat, Maße/Seitenzahl, Zielgruppe, Tonalität, CI-Vorgaben.
2. **„Fertig" messbar machen:** Abnahmekriterien, die DU selbst prüfen kannst — nicht „sieht gut aus", sondern „keine Text-Überläufe, Schrift ≥ 9 pt, Logo auf jeder Seite oben rechts, Seitenzahl durch 4 teilbar".
3. **Unknowns entdecken (billig, bevor es teuer wird):** In fremdem Terrain zuerst ein Blind-Spot-Pass („Welche unknown unknowns habe ich hier?"). Verbleibende Ambiguitäten per Interview klären — eine Frage nach der anderen, priorisiert nach dem, was Architektur oder Layout kippen würde. Bei Geschmacksfragen („erkenne ich, wenn ich es sehe"): erst mehrere wild verschiedene Wegwerf-Varianten rendern und den User reagieren lassen, bevor die echte Arbeit beginnt — für UI-Stücke macht das globale Skill `prototype` genau das (benannte Divergenz-Achsen, Picker, Gewinner promoten). Diese Klärungs-Runde ist erwünscht — danach läuft die Schleife autonom.
4. **Referenzen einsammeln:** Vorgänger-Material, Design-Vorlagen, Beispiel-PDFs, CI-Farben/Fonts. Rangfolge: **Code/HTML-Mockup > Bild/Screenshot > Prosa-Beschreibung** — die beste Referenz ist etwas, das das Modell direkt lesen kann (auch Quellcode in fremder Sprache).
5. Alles in `TARGET.md` schreiben. Ein gutes Zielbild ist self-contained: benennt Dateien, grenzt ab, was NICHT dazugehört, und endet mit dem End-to-End-Prüfschritt.

```markdown
# Zielbild: <Artefakt>
- Format: (z. B. A4 hoch, 12 Seiten, PDF für Druckerei)
- Zielgruppe / Tonalität:
- CI: Farben (Hex), Fonts (Pfade!), Logo-Platzierung
- Referenzen: (Pfade zu Vorlagen/Vorgängern — Code/HTML-Mockup schlägt Screenshot schlägt Beschreibung)

## Abnahmekriterien (objektiv prüfbar)
- [ ] …

## Nicht Teil der Aufgabe
- …

## End-to-End-Prüfung
tools/render.sh → alle Seiten-PNGs selbst sichten → jedes Kriterium oben abhaken
```

## Phase 1 — Die Schleife designen, BEVOR gebaut wird

Kernfrage: **Über welchen Werkzeugweg wird das Ergebnis für dich selbst wahrnehmbar?** Du darfst nichts bauen, was du nicht selbst sehen oder prüfen kannst — fehlt der Weg, ist er dein erster Task.

| Artefakt | Wahrnehmung (dein „Auge") | Fertig-Signal |
| --- | --- | --- |
| Print/PDF | HTML → Chromium headless → PDF → `pdftoppm` → PNG pro Seite → Read | Alle Seiten gesichtet, Abgleich mit TARGET.md bestanden |
| Web-UI | chrome-devtools MCP: `take_screenshot` + Konsole/Netzwerk | Screenshot = Zielbild, keine Konsolen-Fehler |
| Code/Logik | Tests, Typecheck, Linter, CLI-Ausgabe | Grün + Diff entspricht Erwartung |
| Daten/Reports | Verifikations-Skript, das Kennzahlen gegenrechnet | Kontrollsummen stimmen |

1. Werkzeugkette wählen, fehlende Werkzeuge **zuerst bauen** (`tools/render.sh`, `tools/diff.sh`, …).
2. **Loop-Smoke-Test:** Mit einem Dummy („Hello World"-Seite) einmal komplett durch die Kette — bauen, rendern, Ergebnis selbst einlesen. Erst wenn die Schleife nachweislich schließt, beginnt die echte Arbeit.
3. Die exakten Werkzeug-Aufrufe in `AGENTS.md` dokumentieren, damit jede künftige Session sie sofort hat.

## Phase 2 — Ordner + Kontext-Infrastruktur anlegen

Jedes Thema bekommt einen eigenen Ordner (Kettner-Printmaterial: eigener Projekt-Folder, Ort ggf. mit dem User klären). Ordner unter git stellen — jede grüne Iteration wird committet, der Verlauf ist Teil des Gedächtnisses.

```
<projekt>/
├── AGENTS.md      # Arbeitsregeln + Zeiger — laden Cursor & Claude Code automatisch
├── CLAUDE.md      # genau eine Zeile: @AGENTS.md
├── TARGET.md      # Zielbild + Abnahmekriterien (Phase 0)
├── LEARNINGS.md   # Erkenntnisse als 1-Zeiler
├── PROGRESS.md    # was funktioniert, was offen, nächster Schritt
├── DECISIONS.md   # bewusste Entscheidungen + Warum (ab der ersten Entscheidung)
├── tools/         # render.sh, diff.sh … — die Schleife als Skripte
├── src/           # Quelldateien (HTML, CSS, Assets, Fonts)
└── out/           # generierte Artefakte — nie von Hand editieren
```

`AGENTS.md`-Vorlage (kurz halten, < 60 Zeilen — für jede Zeile gilt: Würde ihr Fehlen zu Fehlern führen? Wenn nein: raus):

```markdown
# <Projekt> — Loop-Werkstatt

Hier wird NIE ohne Schleife gearbeitet: Bauen → Rendern → Ansehen → Abgleichen → Festhalten.

## Erst lesen
- Zielbild + Abnahmekriterien: TARGET.md
- Erkenntnisse (Pflicht vor jeder Änderung): LEARNINGS.md
- Stand + nächste Schritte: PROGRESS.md

## Werkzeuge (die Schleife)
- Rendern: `tools/render.sh` → out/<artefakt>.pdf + out/seite-N.png
- Prüfen: PNGs in out/ SELBST einlesen und gegen TARGET.md abgleichen — nach JEDER Änderung
- out/ ist generiert: nie manuell anfassen

## Regeln
- Nie zwei Änderungen blind hintereinander — jede Iteration endet mit Sichtprüfung + Urteil
- Jede User-Korrektur und jede Überraschung → sofort als 1-Zeiler in LEARNINGS.md (Update statt Duplikat)
- „Fertig" nur mit Beleg (gerenderte Seiten) und bestandenem Abgleich gegen TARGET.md
- Session-Ende: Reflexions-Pass → LEARNINGS.md, PROGRESS.md aktualisieren
```

`LEARNINGS.md` startet nicht leer, sondern mit den bekannten Fallen des gewählten Rezepts (siehe unten).

## Phase 3 — Die Schleife fahren

Jede Iteration hat exakt diesen Takt:

1. **Bauen** — eine kohärente Änderung, nicht fünf Baustellen parallel.
2. **Rendern** — Werkzeugkette laufen lassen.
3. **Ansehen** — das Artefakt SELBST einlesen (Read auf die Seiten-PNGs / Screenshot). Niemals überspringen.
4. **Abgleichen** — gegen TARGET.md: jede Abweichung konkret benennen (Seite, Element, Soll/Ist).
5. **Urteilen** — Abweichungen priorisiert fixen, oder: Kriterien erfüllt.
6. **Festhalten** — Überraschungen in LEARNINGS.md; erzwingt ein Edge Case eine Plan-Abweichung: konservative Option wählen und unter „Deviations" in PROGRESS.md loggen, dann weiterarbeiten; grünen Stand committen.

Regeln in der Schleife:
- **Evidenz statt Behauptung:** „Fertig" nur mit dem letzten gerenderten Stand als Beleg — Seiten-PNGs im Chat einbetten, nicht beschreiben.
- **2× derselbe Fehler → STOPP:** Ursache reflektieren, Learning notieren, Ansatz wechseln — nicht dasselbe härter probieren.
- **Frische-Augen-Check vor „fertig":** Ein Subagent mit frischem Kontext prüft nur Artefakt gegen TARGET.md und meldet Abweichungen. Erst wenn er nichts Substanzielles findet, ist es fertig. Für Geschmacksdomänen dem Prüfer eine Rubrik geben — bei Motion/UI ist das globale Skill `review-animations` eine fertige (Standards, Eskalations-Trigger, Block/Approve-Verdikt).

## Phase 4 — Selbstlernen (Pflichtprotokoll)

Learnings schreiben ist Teil der Schleife, keine Kür. Trigger:
- Der User korrigiert dich (Wording, Geschmack, Fachliches) → SOFORT festhalten, dann weiterarbeiten.
- Eine Überprüfung überrascht dich (Render weicht von Erwartung ab, Werkzeug-Eigenheit, Font lädt nicht).
- Du entdeckst etwas, das du beim nächsten Mal wieder brauchst (funktionierender Flag, CI-Farbwert, Asset-Pfad).

Format: 1-Zeiler, verifiziert + dauerhaft + wiederverwendbar. Vor dem Anlegen nach verwandtem Eintrag suchen — existiert einer, Zeile aktualisieren statt duplizieren. Veraltetes löschen: ein aufgeblähtes Kontext-File senkt nachweislich die Erfolgsquote.

Session-Ende (immer): 1) Reflexions-Pass — „Was hätte ich zu Beginn wissen wollen?" (Deviations-Log ist das Rohmaterial) → LEARNINGS.md. 2) PROGRESS.md aktualisieren. 3) AGENTS.md gegenlesen: noch korrekt, noch kurz? Bei Übergabe an Menschen zusätzlich: Pitch-Paket schnüren — Artefakt, Zielbild-Abgleich und Entscheidungen/Abweichungen in einem Dokument, Demo zuerst (als Einzeldatei-HTML, Skill `html-artifacts`).

## Rezepte

### Print/PDF (macOS — Chrome, poppler, ImageMagick sind installiert)

```bash
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

# HTML → PDF (virtual-time lässt Fonts/JS fertig laden)
"$CHROME" --headless --disable-gpu --no-pdf-header-footer \
  --virtual-time-budget=10000 \
  --print-to-pdf=out/broschuere.pdf src/broschuere.html

# PDF → 1 PNG pro Seite (150 dpi reicht zum Prüfen)
pdftoppm -png -r 150 out/broschuere.pdf out/seite

# Optional: Pixel-Diff gegen Referenz
magick compare -metric AE out/seite-1.png ref/seite-1.png out/diff-1.png
```

Bewährtes Grundgerüst: `@page { size: A4; margin: 0; }` plus pro Seite ein Container mit exakt `210mm × 297mm` und `break-after: page`.

Bekannte Fallen — als Start-Learnings in LEARNINGS.md übernehmen:
- Headless-Chrome lädt `url()`-Bilder in `@page`-Margin-Boxen NICHT → dort Base64-Data-URLs einbetten.
- Druckdialog/DevTools-Print-Preview ≠ Headless-Ausgabe. Es zählt ausschließlich das PDF aus der Pipeline.
- `@page`-Margin-At-Rules (`@top-center` …) beherrscht nur Chrome; paged.js interpretiert die Spec teils anders — nicht mischen.
- Web-Fonts lokal als Datei in `src/fonts/` einbinden, nicht von CDNs laden — sonst rendert die Pipeline nicht deterministisch.
- Für echten Druck (Druckerei): Beschnittzugabe/Anschnitt (i. d. R. 3 mm) und Seitenzahl-Teilbarkeit vorab in TARGET.md klären.

### Web-UI

chrome-devtools MCP: `new_page`/`navigate_page` → `take_screenshot` (visuell) + `take_snapshot` (Struktur) → bei Fehlern `list_console_messages` / `list_network_requests`. Screenshot nach JEDER Änderung, Abgleich gegen Design/TARGET.md.

### Code / Daten

Tests bzw. ein kleines Verifikations-Skript sind der Verifier (Exit-Code + Diff gegen Fixture). Existiert keiner, ist ihn zu bauen der erste Task der Schleife.

## Harte Regeln

1. **Nie blind bauen.** Jede Änderung läuft durch die Schleife, bevor die nächste beginnt.
2. **Ergebnis zuerst, Werkzeuge zweitens, Inhalt drittens.** Ohne TARGET.md und geschlossene Schleife wird nicht gebaut.
3. **Evidenz statt Behauptung.** Zeigen, nicht versichern.
4. **Jede Korrektur ist ein Learning.** Nichts geht verloren, was dich beim nächsten Mal schneller macht.
5. **Kontext kurz, Wissen ausgelagert.** AGENTS.md = Regeln + Zeiger, LEARNINGS.md = Wissen.
6. **Die Infrastruktur ist das eigentliche Produkt.** Broschüre v1 = 100 % Aufwand, v2 = 1 %.
7. **Prozess hart, Inhalt frei.** Die Schleife ist nicht verhandelbar — Stil- und Detailentscheidungen trifft das Modell am umgebenden Kontext und den Referenzen. Keine widersprüchlichen Mikro-Regeln in den Kontext-Dateien anhäufen: Über-Constraining kostet bei Claude-5-Modellen messbar Qualität.

## Personalisierung

Dieses Command und die AGENTS.md-Vorlage sind lebende Dokumente. Bewährt sich eine Formulierung (oder erweist sich eine als wirkungslos), passe sie an — genau in diesen individuell geschärften Formulierungen liegt der Produktivitätsgewinn.

## Wissensbasis (eingebettet, keine externen Links nötig)

Das vollständige Deep-Research-Destillat hinter diesem Command liegt lokal im globalen Skill **`loop-engineering`** (`~/.cursor/skills/loop-engineering/`, für Claude Code über `~/.claude/skills/loop-engineering/`):

- `SKILL.md` — die 12 Kernprinzipien
- `references/verifikations-loops.md` — Loop-Anatomie, Check-Eskalationsstufen, Failure-Modes (Thrashing, Test-Overfitting, Context Drift)
- `references/kontext-dateien.md` — AGENTS.md/CLAUDE.md-Regeln, Memory-Bank-Hierarchie, Progressive Disclosure, Messwerte
- `references/selbstlernen.md` — Learnings-Protokoll, Compounding-Workflow, Ralph-Loop, vier Gedächtnis-Kanäle
- `references/print-pdf-pipeline.md` — das komplette Print-Rezept mit allen Fallen im Detail
- `references/claude5-kontext-regeln.md` — Früher→Heute der Kontextregeln für Claude-5-Modelle (Urteilsvermögen statt Regeln, Interfaces statt Beispiele, Rich References)
- `references/unknowns-entdecken.md` — Unknowns-Quadranten und Muster mit Prompt-Vorlagen (Blind-Spot-Pass, Interview, Prototypen, Deviations-Log, Quiz)

Bei jeder nicht-trivialen Loop-Design-Frage: passende Referenz-Datei LESEN, bevor improvisiert wird.
