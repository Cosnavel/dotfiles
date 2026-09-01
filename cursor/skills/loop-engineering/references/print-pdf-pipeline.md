# Print-/PDF-Pipeline — HTML → Chromium → PDF → Auge

Vollständiges Rezept für Printmaterial (Broschüren, Preislisten, One-Pager) mit geschlossener Sichtprüf-Schleife. Alle Befehle auf macOS mit installiertem Chrome, poppler (`pdftoppm`) und ImageMagick (`magick`) validiert.

## Architektur

```
src/*.html + src/fonts/ + src/assets/
        │  tools/render.sh
        ▼
out/<artefakt>.pdf          ← die einzige Wahrheit
        │  pdftoppm
        ▼
out/seite-1.png … seite-N.png
        │  Read (Agent liest JEDE Seite selbst)
        ▼
Abgleich gegen TARGET.md → Abweichungen benennen → fixen → erneut rendern
```

## Befehle

```bash
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

# HTML → PDF; virtual-time-budget lässt Fonts/JS fertig laden, bevor gedruckt wird
"$CHROME" --headless --disable-gpu --no-pdf-header-footer \
  --virtual-time-budget=10000 \
  --print-to-pdf=out/broschuere.pdf src/broschuere.html

# PDF → 1 PNG pro Seite (150 dpi zum Prüfen, 300 dpi für Detailfragen)
pdftoppm -png -r 150 out/broschuere.pdf out/seite

# Optional: Pixel-Diff gegen eine Referenz (AE = Anzahl abweichender Pixel)
magick compare -metric AE out/seite-1.png ref/seite-1.png out/diff-1.png
```

Diese drei Aufrufe gehören als `tools/render.sh` in jede Print-Werkstatt und werden in deren AGENTS.md dokumentiert — ein Beispielaufruf genügt, Varianten leitet der Agent selbst ab.

## CSS-Grundgerüst

```css
@page { size: A4; margin: 0; }
html, body { margin: 0; padding: 0; }
.seite {
  width: 210mm;
  height: 297mm;
  overflow: hidden;        /* Überläufe sichtbar machen statt still verschieben */
  break-after: page;
  position: relative;
}
```

Pro Seite ein Container mit exakten Papiermaßen; Positionierung innerhalb der Seite bevorzugt absolut oder mit festen Maßen — Print ist Layout, kein Responsive Design. Falls Pixel-Rechnung nötig: A4 bei 96 dpi = 794 × 1123 px.

## Bekannte Fallen (verifiziert — nicht neu herausfinden!)

1. **Headless-Chrome lädt `url()`-Bilder in `@page`-Margin-Boxen NICHT.** GUI-Chrome und paged.js zeigen sie, headless lässt sie stumm weg. Lösung: Bilder in Margin-Boxen als **Base64-Data-URLs** einbetten — oder Kopf-/Fußzeilen als normale absolut positionierte Elemente im Seiten-Container bauen (robusteste Variante).
2. **GUI-Druckdialog ≠ Headless-Ausgabe.** Grafisches Chrome nimmt die Fenstergröße statt der CSS-Seitenmaße; headless respektiert die CSS-Maße. Dieselbe Chrome-Version liefert zwei verschiedene Ergebnisse. Konsequenz: **Beurteilt wird ausschließlich das PDF aus der Headless-Pipeline.**
3. **DevTools-„Print-Preview" ist keine Vorschau.** Sie setzt nur den Media-Type auf print und rendert ohne Pagination ins normale Fenster. Seitenumbrüche und `@page`-Verhalten sieht man nur im gerenderten PDF.
4. **`@page`-Margin-At-Rules (`@top-center`, `@bottom-center`, …) beherrscht nur Chrome.** Kein Cross-Browser-Print — die Pipeline ist Chrome-only, und das ist okay.
5. **paged.js ist keine Referenz für Chrome.** Der Polyfill interpretiert die Paged-Media-Spec teils anders als Chrome. Nicht mischen; eine Wahrheit wählen (Chrome headless).
6. **Puppeteer druckt über dieselben Codepaths wie `chrome --headless`.** Ein Wechsel dorthin behebt Render-Probleme nicht — er automatisiert sie nur.
7. **Fonts lokal einbinden** (`src/fonts/` + `@font-face` mit relativen Pfaden). CDN-Fonts machen die Pipeline nichtdeterministisch (Race beim Laden, Offline-Fehlschlag) — `--virtual-time-budget` mildert, ersetzt aber keine lokalen Dateien.

## Druckerei-Anforderungen (in TARGET.md klären, BEVOR gebaut wird)

- **Beschnittzugabe/Anschnitt:** üblich 3 mm umlaufend — Seitenformat dann 216 × 303 mm, randabfallende Elemente bis in den Anschnitt ziehen, Schnittmarken je nach Druckerei.
- **Seitenzahl-Teilbarkeit:** Rückstichheftung braucht durch 4 teilbare Seitenzahl.
- **Farben:** Chrome liefert RGB-PDFs. CMYK/PDF-X-Anforderungen vorab klären — Konvertierung übernimmt oft die Druckerei, sonst Ghostscript-Schritt einplanen.
- **Sicherheitsabstand:** Text mindestens 5 mm von der Schnittkante.

## Sichtprüfung — worauf das Auge achtet

Jede Seite einzeln einlesen (Read auf `out/seite-N.png`) und systematisch prüfen:
- Text-Überläufe und abgeschnittene Elemente (deshalb `overflow: hidden` — Fehler sichtbar machen)
- Seitenumbrüche an den richtigen Stellen, keine verwaisten Überschriften am Seitenende
- Hurenkinder/Schusterjungen (einzelne Zeilen), Wort-Waisen in Headlines
- Konsistenz über Seiten: Logo-Position, Seitenzahlen, Grundlinien, Farbwerte
- Bildauflösung (unscharf im 150-dpi-Render → im Druck erst recht)

Erst wenn alle Seiten gesichtet und alle TARGET.md-Kriterien abgehakt sind, ist die Iteration abgeschlossen — Zwischenstände immer committen.

## Alternativen für Web-Screenshots

Für Screenshots von Live-Webseiten (nicht Print): `shot-scraper https://example.com/ -w 800 -o example.jpg` oder Playwright („use playwright python" genügt als Anweisung — Details findet der Agent selbst). Für lokale UI-Arbeit im Editor: chrome-devtools MCP (`take_screenshot`).

---
Quellenbasis: André Arko (Chrome Headless Print-to-PDF), Nathan Friend (PDF-Gotchas mit Headless Chrome), Simon Willison (shot-scraper), eigene Werkzeug-Validierung auf diesem Rechner (08/2026).
