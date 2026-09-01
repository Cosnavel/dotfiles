Review die Änderung, bevor sie rausgeht. Das Ziel ist, Befunde zu finden — nicht die eigene Arbeit zu bestätigen. Selbstreview fällt zuverlässig zu freundlich aus, deshalb ist ein Teil dieses Ablaufs, das Urteil aus einem frischen Kontext zu holen.

Sammle erst alles, was auffällt, und sortiere danach nach Schwere. Nicht vorab filtern und nur „Wichtiges" notieren — dabei fällt zu viel weg.

## 1. Diff verstehen

`git status`, `git diff` (im Branch `git diff master...HEAD`). Prüfe die Änderung gegen die Absicht: Löst der Diff die gestellte Aufgabe, und enthält er Dinge, die niemand verlangt hat (verwaiste Debug-Ausgaben, umbenannte Symbole, spekulative Abstraktionen, temporäre Test-Dateien)?

## 2. Externes Review parallel starten

Ein `/check` ist die ausdrückliche Aufforderung zum Review der lokalen Änderungen. Starte deshalb bei nicht-trivialen Diffs beide Reviewer parallel in einem Nachrichten-Block:

- `bugbot`-Subagent für Korrektheit und Regressionen
- `security-review`-Subagent, wenn Auth, Berechtigungen, Kundendaten, Zahlungen, Uploads, signierte URLs oder öffentliche Endpoints berührt sind

Prompt-Form und Fehlerbehandlung stehen in den Skills `review-bugbot` und `review-security`. Bei einem Ein-Zeilen-Fix oder einer reinen Textänderung lohnt das nicht — dann reviewst du selbst.

Während die Subagents laufen, machst du deinen eigenen Durchgang (Abschnitt 3). Deren Befunde bewertest du danach selbst: Falschmeldungen als solche benennen, echte Treffer übernehmen.

## 3. Eigener Durchgang

Die generischen Achsen — Korrektheit, Fehlerbehandlung, Lesbarkeit — brauchst du nicht erklärt. Was in diesem Repo tatsächlich schiefgeht:

**Datensicherheit.** Migration mit eigenem `$connection` (`tracking`/`timeseries`) zielt auf Produktion und ignoriert `--database`. Destruktive Statements, fehlende `WHERE`, `delete()` auf Queries statt Modellen. `DB::transaction()` ist wegen PgBouncer verboten — jede Query muss allein bestehen können und die Reihenfolge so gewählt sein, dass ein Abbruch mittendrin keinen kaputten Zustand hinterlässt.

**Berechtigungen.** Wer darf den neuen Endpoint, die neue Filament-Action, den neuen Button? Fremde IDs in Requests (`order_id` aus dem Payload ohne Besitz-Check), Mass Assignment, `v-html` mit Nutzerdaten, Filament-Resources ohne Policy-Abdeckung, Kundendaten in Log- oder Fehlermeldungen.

**Performance.** N+1 in Listen und Resources, Query pro Schleifendurchlauf, fehlendes `select`, unbegrenztes `get()` auf großen Tabellen, Sortierung oder Filter auf Spalten ohne Index. Die DB hängt am WAN — was pro Zeile eine Query macht, ist hier nicht langsam, sondern unbenutzbar. Produktdaten kommen aus Elasticsearch; eine neue DB-Query auf Produkte ist fast immer der falsche Weg.

**Octane.** Kein Request-State in Singletons oder statischen Properties, `scoped()` statt `singleton()` für Per-Request-Services.

**Config.** `env()` nur in `config/*.php`. Tuning-Werte, Listen und Defaults gehören als Literal in die Config, nicht in die `.env`.

**i18n.** Jeder sichtbare Frontend-Text in `$t()`, und jeder neue Key in **allen vier** Locale-Dateien (`en.js` doppelte, `fr/it/es.js` einfache Anführungszeichen) — sonst blockt der CI-Guard. Lokal prüfbar mit `cd nuxt-frontend && node dev-tools/check-i18n.mjs`. Neue Mailables brauchen `setMailLocale()`, Blade-Texte `__()`.

**Konventionen.** Listen immer Infinite Scroll, nie Pagination. Bilder über `LayoutImg` mit `width`, kein rohes `<img>`. Produkte über `CardsProduct`. Casts in `casts()`, nicht `$casts`. Neue Klassen im passenden thematischen Subfolder. Kommentare nur, wo sie einen Constraint erklären, den der Code nicht zeigt.

**Tests.** Lässt sich die Änderung sinnvoll testen, und existiert ein Test dafür? Ausführen nur auf Anfrage, schreiben immer.

Nach PHP-Änderungen `vendor/bin/pint --dirty --format agent`, nach Frontend-Änderungen `cd nuxt-frontend && npx nuxi prepare && yarn lint`.

## 4. Bericht

Befunde nach Schwere sortiert, mit `datei:zeile` und je einem Satz, warum es ein Problem ist:

- **Blocker** — bricht Funktionalität, gefährdet Daten, öffnet eine Lücke. Behebe das direkt und sag, was du geändert hast.
- **Sollte** — echter Mangel ohne akute Wirkung. Aufzählen, auf Zuruf beheben.
- **Nice** — Stilfrage. Kurz nennen, nicht ausbreiten.

Findest du nichts, dann schreib, was du geprüft hast, damit die Abdeckung beurteilbar ist. „Sieht gut aus" ohne Angabe des Umfangs ist kein Review-Ergebnis.

Hier wird gelesen und gelintet. Dass die Änderung im Betrieb wirklich tut, was sie soll, beweist `/test`; bei UI-Änderungen kommt `/design` dazu.
