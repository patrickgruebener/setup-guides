# Claude Code: Professional Setup Guide

Vom explorativen Vibe Coding zum strukturierten AI Engineering.
Dieser Guide definiert das Betriebssystem fuer professionelle KI-gestuetzte Entwicklung mit Claude Code.

## Warum dieses Setup

Ohne Struktur fuehrt agentisches Coding zu:
- Inkonsistenten Code-Patterns
- Context Bloat (Claude vergisst Regeln bei langen Sessions)
- Fehlenden Tests und Quality Gates
- Verlust der architektonischen Kontrolle

Mit diesem Setup:
- Claude arbeitet innerhalb definierter Leitplanken
- Token-Verbrauch ist optimiert (Details nur bei Bedarf geladen)
- Jede Code-Aenderung ist testbar und nachvollziehbar

---

## 1. Projekt-Blueprint

### Verzeichnisstruktur

```
projekt/
├── CLAUDE.md                   # Schlank: Commands + Critical Rules (~80 Zeilen)
├── docs/ai/
│   ├── CONTEXT.md              # Architektur, DB-Schema, APIs, Datenfluss
│   └── CONVENTIONS.md          # Coding-Standards, Naming, Patterns
├── tasks/
│   └── task-template.md        # Feature-Specs mit Akzeptanzkriterien
├── adr/
│   ├── adr-template.md
│   └── adr-001-*.md            # Architektur-Entscheidungen
├── .claude/
│   ├── settings.local.json     # Permissions (erlaubte Commands)
│   ├── rules/                  # Pfad-spezifische Regeln
│   │   └── *.md                # YAML frontmatter mit paths: ["src/**"]
│   └── skills/                 # Domain-spezifisches Wissen
│       └── skill-name/
│           └── SKILL.md        # YAML frontmatter + Skill-Inhalt
└── .github/workflows/          # CI (optional)
    └── ci.yml
```

### Was gehoert wohin

| Inhalt | Datei | Warum dort |
|--------|-------|-----------|
| Build/Test/Lint Commands | `CLAUDE.md` | Muss bei JEDER Session geladen werden |
| Kritische Regeln (max 5) | `CLAUDE.md` | Darf nie vergessen werden |
| Architektur, Schema, APIs | `docs/ai/CONTEXT.md` | Nur geladen wenn Claude Code liest |
| Coding Standards | `docs/ai/CONVENTIONS.md` | Nur geladen wenn Claude Code liest |
| Regeln fuer bestimmte Pfade | `.claude/rules/*.md` | Automatisch geladen bei Arbeit im Pfad |
| Domain-Wissen | `.claude/skills/` | Nur geladen auf Anfrage oder bei Bedarf |
| Feature-Specs | `tasks/` | Pro Task eine Datei |
| Architektur-Entscheidungen | `adr/` | Historische Begruendungen |

---

## 2. CLAUDE.md Strategie

### Hierarchie (Token-Effizienz)

```
1. Global   (~/.claude/CLAUDE.md)     → Persoenliche Praeferenzen
2. Root     (./CLAUDE.md)             → Projekt-Commands + Critical Rules
3. Rules    (.claude/rules/*.md)      → Pfad-basiert, automatisch geladen
4. Skills   (.claude/skills/)         → On-demand Domain-Wissen
5. Docs     (docs/ai/*.md)            → Deep Context bei Bedarf
```

### Goldene Regel
CLAUDE.md unter 100 Zeilen halten. Alles andere auslagern.

### Was REIN gehoert
- Build, Test, Lint Commands
- Deployment Workflow (kurz)
- Max 5 Critical Rules (die NIEMALS vergessen werden duerfen)
- Verweise auf Deep Context Dateien

### Was RAUS gehoert
- Architektur-Details → `docs/ai/CONTEXT.md`
- Coding Standards → `docs/ai/CONVENTIONS.md`
- Framework-spezifische Patterns → `.claude/rules/`
- Domain-Wissen → `.claude/skills/`

---

## 3. Path-Specific Rules

Rules werden automatisch geladen wenn Claude in einem passenden Verzeichnis arbeitet.

### Format

```markdown
---
paths:
  - "src/components/**"
  - "app/**"
---

# UI Rules
- Verwende shadcn/ui Komponenten
- Mobile-first Design
- Server Components als Default
```

### Typische Rules
- **ui-components.md**: Framework-Patterns, Component-Library Regeln
- **api-routes.md**: Validierung, Error-Format, Auth
- **training-logic.md** (domain-spezifisch): Algorithmen die nicht geaendert werden duerfen

---

## 4. Skills

Skills kapseln Domain-Wissen. Sie werden geladen wenn relevant.

### SKILL.md Format

```yaml
---
name: skill-name
description: Wann dieser Skill verwendet wird.
user-invocable: true
argument-hint: [optional context]
---

# Skill Content
Domain-spezifisches Wissen, Regeln, Referenzen.
```

### Zusaetzliche Dateien
Groessere Wissensbasen in separate .md Dateien im Skill-Verzeichnis auslagern.
SKILL.md verlinkt darauf.

---

## 5. Agentic Workflow

### Plan → Build → Verify

1. **Plan Mode**: Claude analysiert die Anforderung, erstellt einen Implementierungsplan
2. **Build**: Schrittweise Umsetzung des Plans
3. **Verify**: Tests ausfuehren, TypeScript Check, manuell pruefen

### Session-Hygiene
- `/clear` nach jedem abgeschlossenen Task
- `/rewind` bei Sackgassen
- Wenn Claude Regeln ignoriert: `/clear` und neu starten

---

## 6. Quality Gates

### Minimum (jedes Projekt)
- Tests: `npm test` / `npx vitest run` / `pytest`
- Type Check: `npx tsc --noEmit`
- Keine Secrets im Repo (`.gitignore` fuer `.env`)

### Empfohlen
- Linting: ESLint / Prettier
- CI Pipeline (GitHub Actions)
- PR Reviews vor Merge

### Test-Strategie
Starte mit Tests fuer die **kritischste Business-Logik**:
- Berechnungen und Algorithmen
- Validierungsregeln
- Safety-relevante Logik

Keine Tests fuer: UI-Layout, Config-Dateien, triviale Getter.

---

## 7. Permissions

### settings.local.json
Erlaubte Commands explizit freigeben:

```json
{
  "permissions": {
    "allow": ["npm test", "npx vitest", "npx tsc", "npm run build"]
  }
}
```

### Sicherheit
- Niemals `.env` Dateien in den Kontext laden
- `--dangerously-skip-permissions` nur in Sandbox
- Destructive git Commands (force push, reset hard) immer bestaetigen lassen

---

## 8. Tasks & ADRs

### Task-Template (tasks/task-xxx.md)

```markdown
# Task: [Name]
## Status: Draft | In Progress | Done
## Background
[Problem, User Story, Motivation]
## Acceptance Criteria
- [ ] Feature funktioniert
- [ ] Tests gruen
- [ ] TypeScript Check bestanden
## Non-Goals
- Was NICHT gemacht wird
## Technical Notes
- Relevante Dateien, Patterns, Constraints
```

### ADR-Template (adr/adr-xxx.md)

```markdown
# ADR-XXX: [Title]
## Status: Proposed | Accepted | Deprecated
## Context
[Was ist das Problem? Welche Kraefte wirken?]
## Decision
[Was wurde entschieden und warum]
## Consequences
### Positive / Negative / Neutral
```

---

## 9. Setup-Checkliste fuer neue Projekte

- [ ] `CLAUDE.md` erstellen (Commands + Critical Rules, <100 Zeilen)
- [ ] `docs/ai/CONTEXT.md` anlegen (Architektur, Schema, APIs)
- [ ] `docs/ai/CONVENTIONS.md` anlegen (Coding Standards)
- [ ] `.claude/rules/` fuer kritische Verzeichnisse
- [ ] `.claude/skills/` fuer Domain-Wissen (falls relevant)
- [ ] `tasks/task-template.md` bereitstellen
- [ ] `adr/adr-template.md` bereitstellen
- [ ] `.gitignore` pruefen (keine Secrets, keine .env)
- [ ] Test-Framework einrichten (Vitest / pytest)
- [ ] Basis-Tests fuer kritische Logik schreiben
- [ ] `npm test` / `pytest` als Permission freigeben
- [ ] Erster Commit mit vollstaendiger Struktur

---

## 10. Troubleshooting

| Problem | Ursache | Fix |
|---------|---------|-----|
| Claude reagiert langsam | Context Bloat | `/compact` oder `/clear` |
| Regeln werden ignoriert | CLAUDE.md zu lang | Kuerzen auf <100 Zeilen, Rest in rules/ |
| Tests brechen sich gegenseitig | Lokale Optimierung | "Fuehre die gesamte Test-Suite aus" |
| Halluzinierte Libraries | Wissenluecke | In CONVENTIONS.md: "Nur Pakete aus package.json" |
| Endlose Fehlversuche | Logik-Fehler im Plan | Esc → `/rewind` → Plan anpassen |
| Falsches Naming | Standard vs. Projekt | Pfad-Regel in rules/ anlegen |

---

## Referenz-Implementierung

Die coach-app (`/Users/patrick/Documents/Freelance/coach-app/`) implementiert dieses Setup vollstaendig:
- Schlanke CLAUDE.md (73 Zeilen)
- 3 Path-Rules (UI, Training-Logik, API)
- 1 Coaching-Skill mit Philosophie-Dokument
- CONTEXT.md + CONVENTIONS.md
- 3 initiale ADRs
- Vitest mit 49 Tests fuer Training-Logik
