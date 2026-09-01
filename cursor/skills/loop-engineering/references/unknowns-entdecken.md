# Unknowns entdecken — Karte vs. Territorium (Fable Field Guide)

Die **Karte** ist die Repräsentation der Arbeit: Prompts, Skills, Kontext. Das **Territorium** ist, wo die Arbeit passiert: Codebase, echte Welt, echte Constraints. Die Differenz sind **Unknowns** — bei jedem muss das Modell raten, was gemeint ist. Bei der Fable-Generation ist die Arbeitsqualität **durch die Fähigkeit begrenzt, Unknowns zu klären** — nicht durch das Modell. Und: Vorab-Planung allein reicht nicht. Unknowns tauchen auch tief in der Implementierung auf — oder zeigen, dass das Problem ganz anders gelöst werden sollte.

## Die vier Quadranten

| Quadrant | Bedeutung | Werkzeug dagegen |
| --- | --- | --- |
| Known Knowns | Steht im Prompt | — |
| Known Unknowns | Weiß ich, dass ich es nicht weiß | Interview, Recherche |
| Unknown Knowns | Zu offensichtlich zum Aufschreiben — erkenne ich, wenn ich es sehe | Prototypen, Varianten zum Reagieren |
| Unknown Unknowns | Nie bedacht; weiß nicht, wie gut etwas sein kann | Blind-Spot-Pass, Brainstorm |

Grundregel: dem Modell den **eigenen Startpunkt** mitgeben — wo man im Denkprozess steht, wie viel Erfahrung man mit Problem und Codebase hat. Denkpartner, nicht Auftragsempfänger. Zu spezifisch instruiert → das Modell folgt auch dann, wenn ein Schwenk richtig wäre; zu vage → es greift zu Industrie-Defaults, die nicht passen.

## Vor der Implementierung

**1. Blind-Spot-Pass** — bei fremdem Terrain (neuer Codebase-Bereich, fremde Domäne). Die wörtlichen Begriffe „blind spot pass" und „unknown unknowns" verwenden, plus Kontext, wer man ist:
> „Ich baue einen neuen Auth-Provider ein, kenne aber die Auth-Module dieser Codebase nicht. Mach einen Blind-Spot-Pass: Welche unknown unknowns habe ich, und wie prompte ich dich dafür besser?"
> „Ich weiß nicht, was Color Grading ist, muss dieses Video aber graden. Bring mir meine unknown unknowns bei, damit ich besser prompten kann."

**2. Brainstorm & Wegwerf-Prototypen** — für Unknown Knowns (Geschmack: „erkenne ich, wenn ich es sehe"). Diese früh zu verbalisieren ist billig — sie während der Implementierung zu entdecken ist teuer (kleine Spec-Änderungen → drastisch andere Implementierung). Fast jede Session mit einer Explorations-/Brainstorm-Phase starten — verhindert zu engen und zu weiten Scope; das Modell findet oft hochwertige Ansätze, die man selbst verpasst hätte. Operationalisiert im globalen Skill `prototype`: Varianten divergieren auf einer benannten Achse (Layout, Dichte, Persönlichkeit, Motion — nie nur Farbtöne), tragen sprechende Namen statt „Option A/B/C", laufen voll funktionsfähig hinter einem Picker in realistischem Kontext, und der Gewinner wird promoted, der Rest gelöscht:
> „Ich will ein Dashboard für diese Daten, habe aber keinen visuellen Geschmack. Bau mir EINE HTML-Seite mit 4 wild verschiedenen Design-Richtungen, auf die ich reagieren kann."
> „Bevor du irgendetwas verdrahtest: eine einzelne HTML-Datei, die die neue Toolbar mit Fake-Daten mockt. Ich will aufs Layout reagieren, bevor du die echte App anfasst."
> „Grobes Problem: User churnen nach dem Onboarding. Durchsuche die Codebase und brainstorme 10 Interventionspunkte, vom billigsten zum ambitioniertesten. Ich sage dir, welche resonieren."

**3. Interview** — für verbleibende Ambiguitäten, mit Kontext zum Problem:
> „Interviewe mich, eine Frage nach der anderen, zu allem, was mehrdeutig ist. Priorisiere Fragen, bei denen meine Antwort die Architektur ändern würde."

**4. Referenzen** — wenn man nicht beschreiben kann, was man will: Die beste Referenz ist **Quellcode**, auch in einer anderen Sprache — deutlich reicher als Screenshot oder Beschreibung:
> „Dieses Rust-Crate in vendor/rate-limiter implementiert exakt das Backoff-Verhalten, das ich will. Lies es und reimplementiere dieselbe Semantik in unserem TypeScript-API-Client."

**5. Implementierungsplan** — führt mit den Entscheidungen, die am ehesten kippen; Mechanik ans Ende:
> „Schreib einen Implementierungsplan, aber beginne mit den Entscheidungen, die ich am ehesten ändern werde: Datenmodell-Änderungen, neue Typ-Interfaces, alles User-Sichtbare. Das mechanische Refactoring ans Ende — da vertraue ich dir."

## Während der Implementierung

**Frische Session mit Artefakten:** Nach dem Planen neue Session starten und die Artefakte (Spec, Prototyp) in den Prompt geben — sauberes Kontextfenster mit dem gesamten Planungswissen.

**Implementation-Notes mit Deviations-Log:** Egal wie gut geplant — unknown unknowns lauern immer (Edge Case im Code erzwingt anderen Weg):
> „Führe eine implementation-notes.md. Wenn dich ein Edge Case vom Plan abweichen lässt: wähle die konservative Option, logge sie unter ‚Deviations' und mach weiter."

Die Deviations sind Lernmaterial für den nächsten Anlauf — sie gehören am Session-Ende in die LEARNINGS-Destillation.

## Nach der Implementierung

**Pitch/Explainer** — Buy-in beschleunigen: Reviewer starten mit denselben Unknowns wie man selbst; Experten wollen sehen, dass die erwartbaren Failure-Points bedacht sind:
> „Verpacke Prototyp, Spec und Implementation-Notes in EIN Dokument, das ich zur Freigabe teilen kann. Beginne mit der Demo."

**Quiz** — Diffs allein zeigen das Verhalten nicht (es hängt an bestehenden Codepfaden). Erst mergen, wenn das Quiz fehlerfrei bestanden ist:
> „Ich will sicher sein, dass ich alles verstehe, was in dieser Änderung passiert ist. Gib mir einen Report mit Kontext und Intuition — und am Ende ein Quiz, das ich bestehen muss."

## Leitsatz

**Jeder Explainer, Brainstorm, jedes Interview, jeder Prototyp und jede Referenz ist ein billiger Weg herauszufinden, was man nicht wusste — bevor es teuer wird.** Kommt ein Long-Horizon-Task falsch zurück, fehlte fast immer Unknowns-Klärung oder ein anpassungsfähiger Plan — nicht härteres Prompten.

Praxis-Referenz: Das Fable-Launch-Video wurde end-to-end mit Claude Code geschnitten — von jemandem ohne Video-Expertise. Vorgehen: erst erklären lassen (funktioniert Whisper-Transkription genau genug für ffmpeg-Schnitte?), dann Prototyp (Remotion-UI auf Transkript-Timing), und bei „das Bild wirkt matt" nicht Varianten raten lassen, sondern zuerst Color Grading **beibringen lassen**, um zu wissen, was „gut" überhaupt heißt.

---
Quellenbasis: Thariq Shihipar/Anthropic — „A field guide to Claude Fable 5: Finding your unknowns" (07/2026), vollständig eingearbeitet.
