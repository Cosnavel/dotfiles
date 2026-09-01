Aktiviere den **Ultra Deep Research Modus**. Tokens und Kosten sind vollkommen irrelevant. Das einzige Ziel ist: **Vollständiges Verständnis des Problems und aller Zusammenhänge.**

## Phase 1: Problemdefinition & Scope

1. Kläre das Problem/den Bereich exakt ab - frage nach falls unklar
2. Identifiziere alle direkt beteiligten Dateien, Klassen, Models, Services, Jobs, Controllers
3. Erstelle eine Todo-Liste mit allen Recherche-Schritten

## Phase 2: Breite Exploration (parallel, mindestens 4 Agents gleichzeitig)

Starte **parallele Task Agents** um folgende Bereiche gleichzeitig zu durchsuchen:

- **Datenbank-Ebene**: Migrations, Schema, Relationships, Indexes - wie hängen die Tabellen zusammen?
- **Model-Ebene**: Eloquent Relationships, Scopes, Casts, Accessors, Mutators, Events, Observers
- **Service/Business-Logic-Ebene**: Services, Jobs, Commands, Actions die mit den betroffenen Models arbeiten
- **API/Controller-Ebene**: Welche Endpoints nutzen die betroffenen Klassen? Welche Requests/Responses?
- **Frontend-Ebene**: Welche Vue/Nuxt Components, Composables, API-Calls sind betroffen?
- **Event/Queue-Ebene**: Events, Listeners, Jobs, Observers die getriggert werden
- **Config/Environment**: Relevante Konfigurationen, Feature Flags, Environment-Variablen

## Phase 3: Tiefenanalyse

Für **jede** gefundene Verbindung:

1. **Lies den vollständigen Code** - nicht nur Signaturen, sondern die komplette Implementierung
2. **Verfolge den Datenfluss**: Woher kommen die Daten? Wohin gehen sie? Wer transformiert sie?
3. **Prüfe Edge Cases**: Was passiert bei null/empty/fehlenden Daten?
4. **Prüfe Race Conditions**: Können parallele Zugriffe Probleme verursachen?
5. **Prüfe Seiteneffekte**: Welche anderen Systeme werden beeinflusst (Cache, Elasticsearch, HubSpot, externe APIs)?

## Phase 4: Dependency Graph

Erstelle einen mentalen Dependency Graph:

- **Upstream**: Was muss passieren BEVOR der betroffene Code läuft?
- **Downstream**: Was passiert NACHDEM der Code gelaufen ist?
- **Lateral**: Was läuft parallel und könnte interferieren?
- **External**: Welche externen Services/APIs sind involviert?

## Phase 5: Historischer Kontext

- Prüfe `git log` für die betroffenen Dateien - wann wurden sie zuletzt geändert und warum?
- Gibt es verwandte Migrations die zeitlich zusammenhängen?
- Gibt es auskommentierter Code oder TODOs die auf bekannte Probleme hinweisen?

## Phase 6: Zusammenfassung & Darstellung

Am Ende liefere eine **vollständige, strukturierte Zusammenfassung**:

1. **Problem-Übersicht**: Was ist das Problem in einem Satz?
2. **Beteiligte Komponenten**: Alle Dateien/Klassen mit ihrer Rolle
3. **Datenfluss-Diagramm**: Wie fließen Daten durch das System (als Text/Mermaid)
4. **Abhängigkeiten**: Was hängt wovon ab?
5. **Potenzielle Problemstellen**: Wo könnten Bugs/Issues lauern?
6. **Empfohlene nächste Schritte**: Was sollte als nächstes getan werden?

## Regeln

- **KEINE Abkürzungen**: Lies immer den vollständigen Code, nicht nur Ausschnitte
- **KEINE Annahmen**: Wenn etwas unklar ist, lies den Code statt zu raten
- **Parallel arbeiten**: Nutze so viele Task Agents wie möglich um Zeit zu sparen
- **Breadth first, then depth**: Erst alle Verbindungen finden, dann jede einzelne tief analysieren
- **Alles dokumentieren**: Jeder Fund wird festgehalten, auch wenn er zunächst unwichtig erscheint
- **Database-Queries nutzen**: Wenn nötig, prüfe echte Daten in der DB um Hypothesen zu validieren (nur SELECT)
- **Keine Angst vor großen Dateien**: Lies sie komplett wenn nötig
