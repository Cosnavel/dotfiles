Wir wollen jetzt systematisch mit Bugbot-Kommentaren auf dem aktuellen PR umgehen. Arbeite genau nach diesem Flow und nutze die GitHub CLI (`gh`):

## 1. Kontext ermitteln

- Ermittle den aktuellen Branch: `git rev-parse --abbrev-ref HEAD`
- Der aktuelle Branch darf **niemals** gewechselt werden — falls du auf `master`/`main` bist, brich ab und sag mir Bescheid.
- Finde den zugehörigen PR: `gh pr view --json number,url,headRefName,state,author`. Falls kein PR existiert, brich ab und frag ob einer erstellt werden soll.
- Prüfe laufende Checks auf dem letzten Commit des PR: `gh pr checks` bzw. `gh api repos/{owner}/{repo}/commits/{sha}/check-runs`.

## 2. Offene Bugbot-Kommentare finden

- Hole ALLE Review-Thread-Kommentare (nicht nur PR-Timeline!) inklusive Resolved-Status via GraphQL:
  ```
  gh api graphql -f query='
    query($owner:String!, $repo:String!, $number:Int!) {
      repository(owner:$owner, name:$repo) {
        pullRequest(number:$number) {
          reviewThreads(first:100) {
            nodes {
              id
              isResolved
              isOutdated
              path
              line
              comments(first:20) {
                nodes { id databaseId author{login} body url createdAt }
              }
            }
          }
        }
      }
    }' -f owner=<owner> -f repo=<repo> -F number=<pr-number>
  ```
- Filtere auf Bugbot-Autoren — das können sein: `cursor[bot]`, `cursoragent`, `bugbot`, `cursor-bot`. Prüfe am aktuellen PR welcher Login verwendet wird (in der Regel erkennbar am `[bot]`-Suffix und am Body-Format mit Severity-Labels).
- Betrachte **nur** Threads mit `isResolved: false`.

## 3. Falls keine offenen Bugbot-Threads existieren

- Prüfe ob gerade ein Bugbot-Run/Check läuft:
  ```
  gh pr checks --json name,state,bucket
  ```
  Die JSON-Felder: `state` = `IN_PROGRESS|SUCCESS|FAILURE|NEUTRAL|…`, `bucket` = `pending|pass|fail|skipping`. Alternative via REST:
  ```
  gh api repos/{owner}/{repo}/commits/{sha}/check-runs
  ```
- Wenn ein Bugbot-Check `state=IN_PROGRESS` oder `bucket=pending` hat: **warte aktiv** in Intervallen (z.B. 30s) via `sleep` + erneutes Pollen. Max ~15 Minuten warten, dann Status melden.
- Sobald der Check fertig ist: zurück zu Schritt 2 und erneut prüfen.
- **Wenn wirklich nichts läuft (kein `pending`/`IN_PROGRESS` Check) und keine offenen Threads da sind: triggere einen neuen Bugbot-Run**, indem du einen PR-Kommentar mit dem magischen Text `bugbot run` postest:
  ```
  gh pr comment <pr-number> --body "bugbot run"
  ```
  Dann **warte auf den neuen Run** (genau wie oben per Polling `gh pr checks --json name,state,bucket`, max ~15 Minuten). Sobald der neue Bugbot-Check fertig ist: zurück zu Schritt 2.
- Wenn auch NACH dem neuen Run keine offenen Threads aufgetaucht sind: sag mir das und beende den Command sauber.

## 4. Für jeden offenen Bugbot-Thread einzeln entscheiden

Für jeden einzelnen offenen Thread: lies den Kommentar-Body komplett (inkl. Code-Hinweise, Severity, File/Line), schau dir den betreffenden Code im Repo an und entscheide:

### A) Echter Bug → Fix-Workflow

1. **Analyse** kurz zusammenfassen (was ist der Bug, warum ist es ein Bug).
2. **Fix implementieren** — sauber, minimal-invasiv, mit Fokus auf Root-Cause.
3. **Testen** — sehr gründlich:
   - Unit-/Feature-Tests für den Fix schreiben (Pest)
   - Falls sinnvoll: temporäres PHP-Script im `public/` laufen lassen und danach löschen
   - Alle bestehenden Tests müssen weiter grün sein: `php artisan test --compact`
   - `vendor/bin/pint --dirty --format agent` laufen lassen
4. **Commit + Push** auf den aktuellen Branch mit aussagekräftiger Commit-Message (Format: `fix(<scope>): <was>` + Body mit Bugbot-Quelle und Test-Zusammenfassung). Nutze HEREDOC wie in der push-Command-Anleitung.
5. **Auf den Bugbot-Thread antworten**, dass der Fix gepusht wurde, und den Thread **resolven**:
   ```
   # Reply auf den spezifischen Review-Comment:
   gh api -X POST repos/{owner}/{repo}/pulls/{pr}/comments/{comment_id}/replies \
     -f body="Fix in <commit-sha> gepusht. <Kurze Zusammenfassung>."

   # Thread resolven via GraphQL:
   gh api graphql -f query='
     mutation($threadId:ID!) {
       resolveReviewThread(input:{threadId:$threadId}) {
         thread { isResolved }
       }
     }' -f threadId=<thread-id>
   ```

### B) False Positive → Kommentieren + Resolven

1. **Analyse** — erkläre kurz warum es kein echter Bug ist (Code-Reference im Repo, Fachlogik, bereits vorhandene Schutzmechanismen, Misverständnis des Bots, etc.). Sei fair und wirklich ehrlich — nur als False-Positive markieren wenn du dir sicher bist.
2. **Auf den Thread antworten** mit sachlicher Begründung auf **Deutsch**:
   ```
   gh api -X POST repos/{owner}/{repo}/pulls/{pr}/comments/{comment_id}/replies \
     -f body="False Positive: <Begründung>. <Optional Referenz/Zeilen>."
   ```
3. **Thread resolven** (wie oben mit `resolveReviewThread` GraphQL-Mutation).

## 5. Strikte Regeln

- **NIE** einen Thread ohne Kommentar-Antwort resolven — die Antwort ist Dokumentation für spätere Reviewer.
- **NIE** mehrere echte Bugs in einen Commit packen — lieber mehrere kleine Commits pro Thread/Topic.
- **NIEMALS** den Branch switchen oder `master`/`main` direkt pushen.
- **NIEMALS** `--force` oder `--no-verify` nutzen.
- Bei Unsicherheit ob echter Bug oder False Positive: lieber als Bug behandeln und fixen.
- Antwortkommentare auf Deutsch, Commit-Messages auf Deutsch (außer der Subject-Prefix wie `fix(scope):` der englisch bleibt).

## 6. Abschluss

Wenn alle offenen Threads abgearbeitet sind:
- Zeige mir eine finale Übersicht: wie viele echte Bugs gefixt, wie viele False Positives geschlossen, mit Commit-SHAs.
- Prüfe `git status` — das Working-Tree muss sauber sein, keine temporären Files übrig.
- Bestätige dass der Branch mit remote synchron ist.
