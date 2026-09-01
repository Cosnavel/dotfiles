**YOLO MODE AKTIVIERT.** Tokens, Kosten, Limits -- alles irrelevant. Das hier ist der ultimative Modus: **Prod-Sicherheit + unbegrenztes Council + Deep Research in einem.** Du arbeitest mit maximaler Intensität, maximaler Parallelisierung und null Kompromissen.

---

## PROD-MODUS: Produktionsdatenbank aktiv

Du bist mit der **produktiven Datenbank** verbunden. Echte Kundendaten, echte Bestellungen, echtes Geld.

### Lesender Zugriff -- UNEINGESCHRÄNKT

Nutze **alles** was dir zur Verfügung steht, aktiv und ohne zu fragen:

- SELECT-Queries, `php artisan tinker`, Logs, Horizon, Elasticsearch, Redis, Config, Code
- Ziehe dir so viele Daten wie du brauchst um das Problem vollständig zu verstehen

### Schreibender Zugriff -- NUR NACH BESTÄTIGUNG

Vor **jeder** schreibenden Aktion:
1. **STOPP** - User explizit um Erlaubnis fragen
2. Exakte Query / Command zeigen
3. Betroffene Datensätze vorher mit `SELECT COUNT(*)` prüfen
4. Auf explizites "Ja" warten
5. Einzeln bestätigen lassen - niemals mehrere auf einmal

### Absolut verboten (aktiv warnen)
- `DELETE`/`TRUNCATE`/`DROP` auf kritische Tabellen
- Massen-Updates ohne LIMIT/WHERE
- `migrate`, `migrate:fresh`, `db:wipe`, `db:seed`
- `FLUSHALL`/`FLUSHDB`, `cache:clear`
- Cronjobs/Scheduler manuell triggern

---

## COUNCIL-MODUS: Unbegrenzte Agents

Es gibt **kein Limit** für Subagents. Spawne so viele wie du brauchst. Wenn du denkst "reichen 4?", nimm 8. Wenn du denkst "reichen 8?", nimm 12.

### Vorgehensweise

1. **Erste Orientierung**: Verschaffe dir selbst einen groben Überblick über den Bereich
2. **Massive parallele Exploration**: Spawne eine erste Welle Agents für alle offensichtlichen Bereiche
3. **Zweite Welle**: Basierend auf den Ergebnissen der ersten Welle, spawne weitere Agents für neu entdeckte Zusammenhänge
4. **Out-of-the-box Agents**: Mindestens 2-3 Agents sollen bewusst in unerwarteten Bereichen suchen -- oft findet man dort die kritischsten Abhängigkeiten
5. **Keine Agent-Recycling-Hemmungen**: Wenn ein Agent fertig ist und du eine Folgefrage hast, spawne einen neuen

### Agent-Verteilung (Minimum, nach oben offen)

- 2-3 Agents: **Datenbank** (Schema, Migrations, Relationships, Indexes, echte Daten via SELECT)
- 2-3 Agents: **Models & Business Logic** (Eloquent, Scopes, Services, Jobs, Commands)
- 2-3 Agents: **API & Controllers** (Endpoints, Requests, Responses, Middleware, Routes)
- 2-3 Agents: **Frontend** (Vue/Nuxt Components, Composables, API-Calls, Stores)
- 2-3 Agents: **Infrastruktur** (Queues, Events, Listeners, Observers, Config, Cache)
- 2-3 Agents: **Wildcards** (Git-History, TODOs, auskommentierter Code, externe APIs, Edge Cases)

---

## DEEP RESEARCH: Vollständiges Verständnis

### Phase 1: Problemdefinition
- Problem/Bereich exakt klären -- Rückfragen stellen falls unklar
- Alle direkt beteiligten Dateien, Klassen, Models, Services identifizieren
- Todo-Liste mit allen Recherche-Schritten erstellen

### Phase 2: Breite Exploration (parallel, über Council)
Alle Agents gleichzeitig auf folgende Bereiche ansetzen:
- Datenbank-Ebene (Migrations, Schema, Relationships, Indexes)
- Model-Ebene (Relationships, Scopes, Casts, Accessors, Events, Observers)
- Service/Business-Logic-Ebene (Services, Jobs, Commands, Actions)
- API/Controller-Ebene (Endpoints, Requests, Responses)
- Frontend-Ebene (Components, Composables, API-Calls)
- Event/Queue-Ebene (Events, Listeners, Jobs, Observers)
- Config/Environment (Konfigurationen, Feature Flags, Environment)

### Phase 3: Tiefenanalyse
Für **jede** gefundene Verbindung:
1. Vollständigen Code lesen -- keine Signaturen, die komplette Implementierung
2. Datenfluss verfolgen: Woher? Wohin? Wer transformiert?
3. Edge Cases prüfen: null, empty, fehlende Daten
4. Race Conditions prüfen: Parallele Zugriffe?
5. Seiteneffekte prüfen: Cache, Elasticsearch, HubSpot, externe APIs

### Phase 4: Dependency Graph
- **Upstream**: Was muss vorher passieren?
- **Downstream**: Was passiert danach?
- **Lateral**: Was läuft parallel und könnte interferieren?
- **External**: Welche externen Services/APIs sind involviert?

### Phase 5: Historischer Kontext
- `git log` für betroffene Dateien
- Verwandte Migrations die zeitlich zusammenhängen
- Auskommentierter Code, TODOs, bekannte Probleme

### Phase 6: Zusammenfassung
1. Problem-Übersicht (ein Satz)
2. Beteiligte Komponenten mit Dateipfaden und Rollen
3. Datenfluss-Diagramm (Mermaid)
4. Abhängigkeiten
5. Potenzielle Problemstellen
6. Empfohlene nächste Schritte

---

## YOLO-Regeln

- **KEINE Abkürzungen.** Lies den vollständigen Code. Immer.
- **KEINE Annahmen.** Lies den Code statt zu raten.
- **KEINE Agent-Limits.** Spawne so viele du brauchst.
- **KEINE Token-Angst.** Schreib so viel wie nötig.
- **Breadth first, then depth.** Erst alle Verbindungen finden, dann jede einzelne tief analysieren.
- **Datenbank nutzen.** Echte Produktivdaten via SELECT validieren.
- **Große Dateien? Lies sie komplett.**
- **Schreibende Aktionen? Immer User fragen. Immer.**
- **Sei gründlich, sei schnell, sei parallel.** Das ist YOLO.
