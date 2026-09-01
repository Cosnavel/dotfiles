Erstelle einen **vollständigen Wochenbericht** über alle Änderungen der aktuellen Kalenderwoche. Der Bericht ist für das **gesamte Team** gedacht -- verständlich, nicht zu technisch, aber mit genug Detail damit jeder versteht was passiert ist.

Tokens und Kosten sind **irrelevant**. Das Ziel ist ein lückenloser, gut lesbarer Bericht.

---

## Phase 1: Daten sammeln

### Git-History der gesamten Woche

Ermittle zuerst den Montag der aktuellen Woche und hole alle Commits seitdem:

```bash
git log --since="last monday" --until="now" --all --oneline --no-merges
```

Dann für jeden Commit die Details:

```bash
git log --since="last monday" --until="now" --all --no-merges --format="%H|%an|%ad|%s" --date=short
```

Und die geänderten Dateien pro Commit:

```bash
git log --since="last monday" --until="now" --all --no-merges --stat
```

### Parallele Deep-Analyse

Spawne **so viele Subagents wie nötig** um die Commits zu analysieren. Jeder Agent bekommt einen Batch an Commits und soll:

1. Den vollständigen Diff lesen (`git show <hash>`)
2. Verstehen **was** geändert wurde und **warum**
3. Die Änderung kategorisieren (Bug Fix, Feature, Verbesserung, Refactoring, Infrastruktur)
4. Eine verständliche Beschreibung auf Deutsch verfassen -- so dass ein nicht-technisches Teammitglied es versteht
5. Den Business Impact bewerten: Was hat sich für Kunden/User/Team verbessert?

---

## Phase 2: Kategorisierung

Ordne jede Änderung in eine dieser Kategorien:

- **Neue Features** -- Komplett neue Funktionalität die es vorher nicht gab
- **Verbesserungen** -- Bestehende Features die besser/schneller/schöner geworden sind
- **Bug Fixes** -- Fehler die behoben wurden (was war das Problem? was war der Impact?)
- **Infrastruktur & DevOps** -- Deployment, CI/CD, Performance, Monitoring
- **Datenbank-Änderungen** -- Neue Tabellen, Migrationen, Schema-Änderungen
- **Sonstiges** -- Refactoring, Aufräumarbeiten, Dependencies

---

## Phase 3: Markdown-Bericht erstellen

Erstelle die Datei: `docs/weekly/KW[nummer]-[jahr].md`

Struktur:

```markdown
# Wochenbericht KW [Nummer] / [Jahr]

> Zeitraum: [Montag Datum] -- [Freitag/Heute Datum]
> Erstellt: [Heute]

## Zusammenfassung

[2-3 Sätze: Was war diese Woche der Fokus? Was sind die Highlights?]

---

## Neue Features

### [Feature-Name]
[Beschreibung in 2-4 Sätzen: Was kann man jetzt neu machen? Wer profitiert davon?]

---

## Verbesserungen

### [Name der Verbesserung]
[Was wurde verbessert? Was ist jetzt besser als vorher?]

---

## Behobene Fehler

### [Kurze Fehlerbeschreibung]
- **Problem:** [Was war kaputt / was hat nicht funktioniert?]
- **Auswirkung:** [Wen hat es betroffen? Wie schlimm war es?]
- **Lösung:** [Was wurde gemacht um es zu beheben?]

---

## Infrastruktur & Technik

### [Änderung]
[Was wurde gemacht und warum?]

---

## Datenbank-Änderungen

| Tabelle | Art der Änderung | Beschreibung |
|---------|-----------------|--------------|
| ... | Neu / Geändert / Migration | ... |

---

## Statistiken

- **Commits gesamt:** [Anzahl]
- **Beteiligte Entwickler:** [Namen]
- **Geänderte Dateien:** [Anzahl]
- **Neue Dateien:** [Anzahl]
```

---

## Phase 4: Qualitätskontrolle

Bevor der Bericht finalisiert wird:

1. **Vollständigkeit prüfen**: Ist wirklich JEDER Commit erfasst? Fehlt etwas?
2. **Verständlichkeit prüfen**: Würde ein nicht-technisches Teammitglied alles verstehen?
3. **Duplikate entfernen**: Mehrere Commits zum gleichen Thema zu einem Punkt zusammenfassen
4. **Priorisierung**: Die wichtigsten Änderungen zuerst nennen
5. **Sprache**: Deutsch, klar, professionell, keine Code-Snippets im Bericht

---

## Regeln

- **Deutsch schreiben** -- der Bericht ist für das deutsche Team
- **Nicht zu technisch** -- keine Klassennamen, keine Code-Snippets, keine Dateipfade im Bericht
- **Aber präzise** -- "Ein Bug wurde gefixt" reicht nicht. WAS war der Bug? WEN hat er betroffen?
- **Business-Perspektive** -- Was bedeutet die Änderung für Kunden, für das Team, für den Betrieb?
- **Commits gruppieren** -- 5 Commits zum selben Feature = 1 Eintrag mit vollständiger Beschreibung
- **Alle Branches einbeziehen** -- nicht nur master/main, sondern auch Feature-Branches die gemergt wurden
- **Subagents ohne Limit** -- spawne so viele wie nötig für eine gründliche Analyse
