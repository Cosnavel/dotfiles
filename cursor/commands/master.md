Wechsle lokal auf den `master` Branch und pulle den aktuellen Stand vom Remote.

Vorgehen:
- Prüfe zuerst mit `git status` ob es uncommittete Änderungen gibt. Falls ja: STOPP und frage nach (nicht einfach stashen oder verwerfen!)
- Falls der Working-Tree sauber ist: `git checkout master && git pull`
- Bei Konflikten oder Fehlern beim Pull: melde das klar und mach nicht eigenständig weiter

Niemals mit Force pushen, niemals lokale Änderungen ohne Rückfrage verwerfen.
