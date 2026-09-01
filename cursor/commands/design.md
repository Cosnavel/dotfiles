Validiere die Frontend-Änderung im echten Browser und treib sie so lange nach, bis sie nicht mehr „fertig", sondern gut ist. Gemeint sind Nuxt-Storefront, React-Admin und Filament-Views gleichermaßen.

Du darfst dabei nicht aus dem Code urteilen. Ein Urteil über eine Oberfläche, das ohne Screenshot entsteht, ist geraten — sieh sie dir an, in mehreren Breiten, in mehreren Zuständen.

## Was hier „gut" heißt

Das ist kein Greenfield-Projekt. Der Shop hat eine gewachsene Marke: Inter als Schriftfamilie, Gold (`#BA9453`) als Akzent, `kettner-green`/`kettner-blue` als Sekundärfarben, `CardsProduct` für Produkte, `Form/*` für Eingaben. Die verbreitete KI-Design-Empfehlung „wähle eine auffällige, ungewöhnliche Schrift, erfinde eine eigene Ästhetik" ist hier also **falsch** — sie würde die Marke zerlegen.

Der Maßstab ist stattdessen: Sieht das aus, als hätte ein Mensch mit Geschmack es innerhalb dieses Designsystems bewusst entschieden? Nicht generisch, nicht Bootstrap-mit-Gold-Anstrich, nicht das übliche KI-Muster (weiche Lila-Gradienten auf weißen Karten, drei gleich gewichtete Spalten, überall der gleiche Schatten, Emoji als Icons). Als Stilanker dienen die modernen Komponenten aus `nuxt-frontend.mdc` (`Misc/HottestProductsBanner.vue`, `Misc/KaiserWilhelmBanner.vue`, `Misc/ProductOfTheHourBanner.vue`) — schau dort nach, wie Premium hier aussieht, statt es neu zu erfinden.

## Welche Seiten überhaupt

Aus dem Diff ableiten, wo die Änderung sichtbar wird. Bei einer neuen Landingpage ist das trivial; bei einer geänderten gemeinsamen Komponente nicht — `CardsProduct`, `LayoutImg` oder ein Form-Element steckt in Startseite, Kategorie, Suche, Merkzettel und Portfolio gleichzeitig. `rg` auf den Komponentennamen sagt dir, welche Seiten mitbetroffen sind; mindestens die zwei wichtigsten davon gehören in die Sichtprüfung, nicht nur die, für die du die Änderung gebaut hast.

## Der Ablauf

Ansehen, gegen die Kriterien bewerten, die schwächste Achse gezielt nachschärfen, erneut ansehen. Zwei bis vier Runden sind normal. Schluss ist, wenn jede Achse über der Schwelle liegt oder eine Runde keine sichtbare Verbesserung mehr bringt — dann sagst du das, statt weiter zu polieren.

Bewerte pro Runde auf einer Skala von 1 bis 5:

- **Wirkung und Kohärenz** (Schwelle 4) — Wirkt das Ganze wie ein Stück, oder wie zusammengeschobene Teile? Passen Typo-Hierarchie, Farbgewichtung, Abstände und Bildsprache zusammen und ergeben eine erkennbare Haltung? Fügt sich der neue Teil in die umgebende Seite ein, ohne sie zu unterbieten?
- **Handwerk** (Schwelle 4, harte Untergrenze) — optische Ausrichtung, konsistente Abstandsstufen, Kontraste, kein Umbruch, kein Überlauf, keine Ein-Wort-Waisen in Überschriften. Hier gibt es keine Geschmacksfrage: Was schief steht, steht schief.
- **Bedienbarkeit** (Schwelle 4) — Ist die primäre Aktion sofort erkennbar? Versteht man ohne Erklärung, was passiert, was es kostet und was der nächste Schritt ist? Sind Zustände rückgemeldet (Ladezustand, Erfolg, Fehler)?
- **Robustheit** (Schwelle 4) — Hält das Layout auch mit echten Daten, langen deutschen Wörtern, längeren Übersetzungen, fehlenden Bildern und leeren Listen?

Bei einer 3 oder schlechter benennst du die Ursache konkret („über der H2 stehen 24 px, darunter genauso viele — die Überschrift bindet sich dadurch nicht an den Absatz, den sie einleitet"), nicht als Stimmungsbild („Typografie könnte besser sein").

## Wirklich hinsehen

Screenshots bei **375, 768, 1280 und 1440** px Breite — `2xl` ist in diesem Projekt 1440, nicht 1536. Zusätzlich einmal knapp **unter** dem relevanten Breakpoint (1439, 1023, 767), weil das Layout dort am engsten ist und genau da bricht.

Mobil zuerst. Eine Änderung, die nur bei 1280 px begutachtet wurde, ist nicht begutachtet.

Beurteile nicht den Vollseiten-Screenshot als Ganzes: scrolle an die geänderte Stelle, mach einen engen Screenshot davon und sieh dir Details einzeln an. Abstände, Kantenausrichtung und Schriftgewichte sind auf einem herausgezoomten Vollbild nicht beurteilbar. Browser-Zoom muss dabei auf 100 % stehen, sonst treffen Klicks daneben.

## Zustände, nicht nur den einen

Je nach Änderung: Ladezustand und Skeleton, leere Liste, Fehlerfall, sehr langer Produktname, vierstelliger Preis, fehlendes Bild, ausverkauft, eingeloggt und ausgeloggt. Interaktive Elemente in allen Zuständen: hover, focus (sichtbarer Fokusring — Tastaturnutzer brauchen ihn), active, disabled. Einmal mit der Tastatur durchtabben und prüfen, ob die Reihenfolge der Lesereihenfolge folgt.

## Messbare Prüfungen

Diese sind nicht Geschmackssache und im Browser per `evaluate_script` prüfbar:

- **Horizontaler Überlauf** bei 375 px — der häufigste Mobile-Bug hier: `document.documentElement.scrollWidth > document.documentElement.clientWidth`, und die Verursacher über `[...document.querySelectorAll('*')].filter(e => e.getBoundingClientRect().right > innerWidth + 1)`. Beachte, dass Reveal-Animationen mit `translate-x`-Startzustand unter dem Fold das Layout verbreitern können.
- **Kontrast.** Gold auf Weiß liegt bei 2,8:1, `gold-dark` bei 3,9:1, `kettner-green` bei 3,8:1 — alle drei reichen für Fließtext (4,5:1) **nicht**. Gold ist eine Akzentfarbe für dunkle Flächen (auf `kettner-blue` 5,2:1) und für große Headlines, nie für Lauftext oder kleine Labels auf Weiß.
- **Trefferflächen** mindestens 44 × 44 px auf Touch, inklusive Icon-Buttons und Schließen-Kreuzen.
- **Schriftgröße** mobil nicht unter 14 px; Fließtextzeilen nicht länger als etwa 75 Zeichen.
- **Berechnete Styles gegenprüfen**, wenn eine Utility nicht wirkt. In diesem Tailwind-v4-Setup erzeugt `aspect-video` kein CSS (`aspect-[16/9]` nutzen), Kommas in `grid-cols-[a,b]` sind ungültig (Unterstriche verwenden), und `space-y-*` bricht, sobald ein Kind eine eigene Margin-Utility hat (`flex gap-*` nutzen). `getComputedStyle` sagt dir, was wirklich gilt.
- **Konsole und Network** sauber: keine Vue-Warnings, keine 404 auf Bilder, keine CORS-Fehler.

## Bewegung und Mobil-Performance

Ein gut orchestrierter Auftritt beim Laden — gestaffelte Reveals über `animation-delay` — wirkt mehr als überall verteilte Mikro-Animationen. Halte Übergänge kurz (150–300 ms) und respektiere `prefers-reduced-motion`.

Zwei Dinge sind auf iOS teuer erkauft und in diesem Repo mehrfach als Ursache echter Performance-Beschwerden belegt: `filter: blur()` bzw. `backdrop-filter` auf größeren Flächen (stattdessen ein `bg-[radial-gradient]` als Glow) und `content-visibility: auto` (stattdessen Mount-Gating über `HomepageBanner/DeferredMount.vue`). Animationen und Autoplay-Videos außerhalb des Viewports pausieren.

Bilder laufen über `LayoutImg` mit gesetzter `width`; bei großflächigen Bildern zusätzlich `sizes`, sonst lädt jedes Retina-Gerät die doppelte Desktop-Breite.

## Sprache

Jeder neue sichtbare Text in `$t()`, jeder Key in allen vier Locale-Dateien (`en.js`, `fr.js`, `it.js`, `es.js`), Kontrolle mit `cd nuxt-frontend && node dev-tools/check-i18n.mjs`. Danach einmal mit englischer Locale ansehen: Übersetzungen sind oft länger und sprengen knapp gebaute Buttons und Tabs. Keine Wort-Waisen in Marketing-Copy — `text-balance`/`text-pretty` und geschützte Leerzeichen.

## Werkzeuge

Bevorzugt chrome-devtools-MCP: eigener Tab über `new_page`, Breiten über `resize_page`/`emulate`, `take_screenshot`, `evaluate_script`, `list_console_messages`, bei Bedarf `lighthouse_audit` oder `performance_start_trace`. Es vertraut Herds lokaler CA, `.test`-Domains funktionieren also direkt. Dateien schreibt es nur in sein eigenes Temp-Verzeichnis, nicht in den Workspace.

Alternativ der Cursor-Browser: Tab mit `about:blank` anlegen, dann `browser_cdp Security.setIgnoreCertificateErrors {ignore:true}`, dann navigieren. `browser_fill` erwartet den Parameter `value`. Desktop-Layout im schmalen Fenster über `Emulation.setDeviceMetricsOverride`. Der Screenshot-Layer kann auf einem alten Frame hängen — bei widersprüchlichen Bildern über `browser_navigate` neu laden.

Beim Nuxt-Frontend vorher sicherstellen, dass `localhost:3000` dein eigener Worktree ist (`__NUXT__.config.public.baseUrl` gegen die `.env` abgleichen). Fremder Devserver heißt: du bewertest fremden Code.

## Bewertung aus frischem Kontext

Wer eine Oberfläche gebaut hat, findet sie zu gut. Bei größeren UI-Arbeiten — neue Landingpage, neuer Funnel-Schritt, umgebaute Komponente — lass die Bewertungsrunde deshalb von einem frischen Subagent machen (`browser-use`): gib ihm URL, Breakpoints, die vier Kriterien und den Auftrag, zu bewerten und zu kritisieren, nicht zu reparieren. Sein Urteil arbeitest du dann ein. Für eine geänderte Schriftgröße lohnt das nicht.

## Bericht

Führe mit dem Ergebnis: Was hat sich sichtbar verbessert, was bleibt offen. Danach die Screenshots direkt eingebettet (`![Beschreibung](/absoluter/pfad.png)`) — mindestens der Endzustand mobil und desktop, und wenn du einen Vorher-Zustand aufgenommen hast, beide nebeneinander. Dazu die Bewertung pro Achse mit Begründung und die offenen Punkte samt Grund (Aufwand, fehlende Freigabe, außerhalb des Auftrags).

## Grenzen

Preise, Rechtstexte, Pflichtangaben und Markenelemente nicht anfassen. Keine neuen Dependencies, keine neue Icon- oder Font-Familie, kein zweites Designsystem. Pagination bleibt verboten, auch wenn sie an einer Stelle bequemer wäre. Und: Diese Runde optimiert die Änderung, um die es geht — nicht die halbe Startseite mit.
