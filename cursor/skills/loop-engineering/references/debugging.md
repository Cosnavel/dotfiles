# Systematisches Debugging — Root Cause vor Fix

Destilliert aus obra/superpowers (`systematic-debugging`), angepasst an unsere Umgebung. Schließt die größte Lücke der Loop-Methodik: Was tun, wenn die Schleife einen Fehler zeigt.

## Das eiserne Gesetz

**Kein Fix ohne abgeschlossene Root-Cause-Untersuchung.** Ein Symptom-Fix ist ein Fehlschlag, auch wenn er „funktioniert". Gilt besonders dann, wenn es verlockend ist zu raten: unter Zeitdruck, wenn „ein schneller Fix offensichtlich" scheint, und wenn schon mehrere Fixes probiert wurden.

## Die vier Phasen (in Reihenfolge, keine überspringen)

**1. Root Cause finden**
- Fehlermeldung und Stacktrace **vollständig** lesen — sie enthalten oft die Lösung (Zeilennummern, Pfade, Codes).
- Zuverlässig reproduzieren. Nicht reproduzierbar → mehr Daten sammeln, nicht raten.
- Letzte Änderungen prüfen: `git diff`, jüngste Commits, neue Dependencies, Config, Umgebung.
- **Mehr-Komponenten-Systeme** (Frontend → API → Job → DB; CI → Build → Deploy): VOR jedem Fix an jeder Komponentengrenze instrumentieren — was geht rein, was kommt raus, propagiert Env/Config? Einmal laufen lassen, Beweis sammeln, WO es bricht — dann erst diese Komponente untersuchen.
- Fehler tief im Callstack: den schlechten Wert **rückwärts bis zur Quelle** verfolgen. Fix an der Quelle, nicht am Symptom.

**2. Muster finden**
- Funktionierendes Gegenstück im selben Code suchen: Was Ähnliches geht — und was ist anders?
- Jede Differenz listen, auch die „das kann doch nicht relevant sein"-Kandidaten. Doch, kann es.
- Referenz-Implementierungen komplett lesen, nicht überfliegen und „das Muster adaptieren".

**3. Hypothese testen (wissenschaftlich)**
- EINE Hypothese, konkret aufgeschrieben: „Ich glaube X ist die Ursache, weil Y."
- Kleinste mögliche Änderung zum Testen, eine Variable auf einmal. Fixes niemals stapeln.
- Hypothese widerlegt → neue Hypothese, NICHT zusätzlichen Fix obendrauf.
- Nichtwissen aussprechen („Ich verstehe X nicht") statt so tun als ob.

**4. Fix implementieren**
- Erst den fehlschlagenden Testfall schreiben (kleinste Reproduktion), dann EIN Fix für die identifizierte Ursache. Kein „wo ich schon mal hier bin"-Refactoring.
- **Kettner-Anschluss:** Test *schreiben* immer; die Pest-Suite *ausführen* nur auf Freigabe (`testing-and-databases.mdc`) — Verifikation läuft stattdessen über die Loop-Werkzeuge (Browser, lesendes Tinker, Logs, HTTP), CI führt die Suite aus.

## Die 3-Fixes-Regel (Architektur-Eskalation)

Fix Nummer 1 und 2 gescheitert → zurück zu Phase 1 mit den neuen Informationen. **Ab 3 gescheiterten Fixes: STOPP — keine Fix-Nummer 4, sondern die Architekturfrage stellen.** Das Muster dafür: Jeder Fix legt ein neues Problem an anderer Stelle frei, Fixes bräuchten „massives Refactoring", jeder Fix erzeugt neue Symptome. Das ist keine gescheiterte Hypothese, das ist die falsche Architektur — mit dem Menschen besprechen, bevor weitergefixt wird.

## Red Flags — sofort stoppen und zu Phase 1

„Schneller Fix, untersuchen später" · „Probier mal X und schau" · „Mehrere Änderungen, dann Tests" · „Es ist wahrscheinlich X, ich fixe das mal" · Lösungsvorschläge, bevor der Datenfluss verfolgt ist · „Noch EIN Versuch" nach 2+ Fehlschlägen.

## Rationalisierungen (Ausrede ↔ Realität)

| Ausrede | Realität |
| --- | --- |
| „Zu simpel für den Prozess" | Simple Bugs haben auch Root Causes. Der Prozess ist bei simplen Bugs schnell. |
| „Notfall, keine Zeit" | Systematisch ist schneller als Guess-and-Check-Thrashing. |
| „Mehrere Fixes auf einmal spart Zeit" | Dann ist nicht isolierbar, was gewirkt hat — und es entstehen neue Bugs. |
| „Ich sehe das Problem doch" | Symptom sehen ≠ Ursache verstehen. |
| „Referenz zu lang, ich adaptiere das Muster" | Halbes Verständnis garantiert Bugs. Komplett lesen. |

Wenn die Untersuchung wirklich keinen Root Cause findet (echt umgebungs-/timing-bedingt): dokumentieren, was untersucht wurde, passendes Handling (Retry/Timeout/Fehlermeldung) plus Monitoring einbauen. Aber: 95 % der „kein Root Cause"-Fälle sind unvollständige Untersuchung.

---
Quellenbasis: Jesse Vincent (obra/superpowers, systematic-debugging), destilliert und an die Kettner-Testregeln angepasst.
