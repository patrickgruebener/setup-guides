# Vibe Coding Setup - Zusammenfassung

Dieses Dokument fasst das komplette Vibe Coding Setup zusammen, das für schnelles App-Building mit Claude Code optimiert ist.

---

## Was wurde eingerichtet?

### 1. Template: next-saas-starter
**Pfad:** `~/Documents/Freelance/setup-guides/templates/next-saas-starter/`

Ein produktionsreifes SaaS-Template mit:
- Next.js 15 + React 19 + TypeScript
- PostgreSQL + Drizzle ORM
- Authentication (Email/Passwort, JWT)
- Stripe Payments + Subscriptions
- Team Management + RBAC
- shadcn/ui Komponenten
- Landing Page + Dashboard

**Ursprung:** https://github.com/leerob/next-saas-starter (15.400 Stars)

### 2. CLAUDE.md Template
**Pfad:** `~/Documents/Freelance/setup-guides/templates/next-saas-starter/CLAUDE.md`

Eine vollständige Projekt-Dokumentation, die:
- Claude Code alle wichtigen Informationen über das Projekt gibt
- Tech Stack, Infrastruktur, Environment Variables dokumentiert
- Workflow-Befehle und Setup-Schritte enthält
- Bei jedem neuen Projekt automatisch angepasst wird

### 3. Schnellstart-Skript
**Pfad:** `~/Documents/Freelance/setup-guides/scripts/new-saas-project.sh`

Ein Shell-Skript, das mit einem Befehl:
- Ein neues Projekt aus dem Template erstellt
- Alle Platzhalter anpasst
- Git initialisiert
- `.env` Datei erstellt
- Das Projekt in `setup-guides/projects/` ablegt

**Verwendung:**
```bash
~/Documents/Freelance/setup-guides/scripts/new-saas-project.sh mein-projekt-name
```

### 4. Workflow-Dokumentation
**Pfad:** `~/Documents/Freelance/setup-guides/workflows/vibe-coding-workflow.md`

Eine Schritt-für-Schritt-Anleitung für:
- Einmalige Vorbereitung (Accounts, Tools)
- Neues Projekt erstellen
- Projekt konfigurieren (Datenbank, Stripe, .env)
- Features mit Claude Code bauen
- Deployment zu Production (Vercel)
- Troubleshooting

### 5. Aktualisierte Haupt-README
**Pfad:** `~/Documents/Freelance/setup-guides/README.md`

Die zentrale README wurde erweitert mit Links zu:
- next-saas-starter Template
- Vibe Coding Workflow
- Schnellstart-Skript

---

## Wie funktioniert das System?

### Workflow im Überblick

```
1. Neues Projekt erstellen
   ↓
   ./new-saas-project.sh mein-projekt

2. Projekt konfigurieren
   ↓
   CLAUDE.md ausfüllen
   .env konfigurieren (DB, Stripe)

3. Entwicklung starten
   ↓
   npm install
   npm run db:migrate
   npm run dev

4. Features bauen
   ↓
   Claude Code: "Baue Feature X"
   (Auth, DB, UI sind bereits vorhanden)

5. Deployment
   ↓
   git push → Dokploy deployed automatisch
```

### Was ist anders als vorher?

**Vorher (Feature Prompting):**
- "Baue mir eine Invoice-App"
- Claude Code muss ALLES entscheiden: Framework, DB, Auth-Methode, UI-Library, Ordnerstruktur
- Hohes Fehler-Risiko, inkonsistente Patterns
- Jedes Projekt startet bei Null

**Jetzt (Template-basiert):**
- Template mit komplettem Plumbing vorhanden
- "Baue eine Invoice-Tabelle auf diesem Template"
- Claude Code kennt die Patterns (Drizzle, Server Components, shadcn/ui)
- Konsistente Struktur über alle Projekte
- Sofort produktionsbereit

---

## Warum dieses Template?

### Vergleich zu Alternativen

| Template | Stars | Supabase | Vollständigkeit | Community | Empfehlung |
|----------|-------|----------|----------------|-----------|------------|
| Barty-Bart | 52 | Ja | Minimal | Klein | Prototypen |
| KolbySisk | 746 | Ja | Mittel | Klein | OK, aber veraltet |
| **next-saas-starter** | **15.400** | Nein (PG direkt) | **Vollständig** | **Riesig** | **Beste Wahl** |
| ixartz/SaaS-Boilerplate | 6.800 | Nein | Sehr vollständig | Groß | Gute Alternative |

**Entscheidungsgründe:**
1. **Agent-Handling**: Vom Next.js/Vercel-Team → Claude Code kennt die Patterns am besten
2. **Kostengünstig**: VPS ab 4€/Monat für unbegrenzte Apps, PostgreSQL auf VPS kostenlos, Stripe nur per Transaction
3. **Skalierbar**: PostgreSQL + Drizzle ORM produktionsreif, VPS erweiterbar, eigene Infrastruktur
4. **Community**: 15.400 Stars = maximale Wissensbasis in AI-Trainingsdaten

**Trade-offs:**
- Kein Supabase, sondern PostgreSQL direkt mit Drizzle ORM (einfacher, reines TypeScript)
- Self-Hosted auf VPS statt Vercel (volle Kontrolle, aber VPS-Wartung nötig)
- Deployment über Dokploy (wie Vercel, aber auf eigener Infrastruktur)
- PostgreSQL auf VPS = keine Backups by default (manuell einrichten oder Neon.tech nutzen)

---

## Benötigte Accounts & Infrastruktur (kostenlos möglich)

Für produktive Nutzung brauchst du:

1. **VPS mit Dokploy** (Deployment & Hosting)
   - Hostinger VPS: ab ~4€/Monat (2 GB RAM, 1 vCPU)
   - Alternative: Hetzner, DigitalOcean
   - Dokploy: kostenlos (self-hosted PaaS)
   - Guide: [Dokploy + GitHub Auto-Deployment](deployment/dokploy-github-autodeploy.md)

2. **PostgreSQL** (Datenbank)
   - Auf dem VPS als Docker Container (kostenlos)
   - Alternative: Neon.tech (externes Hosting, Free Tier)

3. **Stripe** (Payments)
   - Free: Keine Fixkosten, nur Transaktionsgebühren
   - Test-Mode kostenlos
   - URL: https://dashboard.stripe.com/register

4. **GitHub** (Code-Hosting)
   - Free: Unbegrenzte Repos
   - URL: https://github.com/signup

**Kosten-Übersicht:**
- Minimal: ~4€/Monat (nur VPS)
- Stripe: nur bei Transaktionen
- Alles andere: kostenlos

---

## Quick Start

### Erstes Projekt erstellen (5 Minuten)

```bash
# 1. Projekt erstellen
~/Documents/Freelance/setup-guides/scripts/new-saas-project.sh mein-erstes-projekt

# 2. Zum Projekt wechseln
cd ~/Documents/Freelance/setup-guides/projects/mein-erstes-projekt

# 3. VS Code öffnen
code .

# 4. CLAUDE.md öffnen und Platzhalter ausfüllen

# 5. Dependencies installieren
pnpm install
```

**Vollständige Anleitung:** [Vibe Coding Workflow](workflows/vibe-coding-workflow.md)

---

## Wichtigste Dateien im System

```
setup-guides/
├── templates/
│   └── next-saas-starter/          # Master-Template (nicht direkt bearbeiten)
│       └── CLAUDE.md               # Template-Dokumentation
├── scripts/
│   └── new-saas-project.sh         # Projekt-Generator
├── workflows/
│   └── vibe-coding-workflow.md     # Vollständige Anleitung
├── projects/
│   └── [deine-projekte]/           # Hier landen neue Projekte
└── README.md                       # Haupt-Übersicht
```

---

## Nächste Schritte

### Sofort loslegen
1. Lies den [Vibe Coding Workflow](workflows/vibe-coding-workflow.md) einmal komplett durch
2. Erstelle dein erstes Test-Projekt mit dem Skript
3. Folge den Setup-Schritten (DB, Stripe, .env)
4. Starte `pnpm dev` und teste die App
5. Lass Claude Code ein einfaches Feature bauen

### Accounts einrichten (einmalig)
1. Neon.tech Account erstellen
2. Stripe Account erstellen + Stripe CLI installieren
3. Vercel Account erstellen

### Erstes produktives Projekt
1. Projekt mit `new-saas-project.sh` erstellen
2. CLAUDE.md vollständig ausfüllen
3. GitHub Repo erstellen
4. Vercel verbinden
5. Production-Deployment testen

---

## Hilfe & Ressourcen

### Dokumentation
- [Vibe Coding Workflow](workflows/vibe-coding-workflow.md) - Kompletter Workflow
- [Template CLAUDE.md](templates/next-saas-starter/CLAUDE.md) - Stack-Details
- [Original Template](https://github.com/leerob/next-saas-starter) - GitHub Repo
- [Demo](https://next-saas-start.vercel.app/) - Live Demo

### Bei Problemen
- Workflow-Doku hat Troubleshooting-Sektion
- CLAUDE.md enthält alle spezifischen Befehle
- Claude Code fragen: "Wie löse ich [Problem]?"

---

## Zusammenfassung

Du hast jetzt ein **produktionsreifes Vibe Coding System**, das:

1. **Template-basiert arbeitet** statt Feature Prompting
2. **Konsistente Struktur** über alle Projekte garantiert
3. **Sofort produktionsbereit** ist (Auth, Payments, Teams vorhanden)
4. **Claude Code optimal unterstützt** (bekannte Patterns, große Community)
5. **Mit einem Befehl** neue Projekte startet

**Kernerkenntnis aus der Recherche:**
Die besten Vibe Coder 2025/2026 nutzen Templates als Fundament und lassen AI nur noch Features bauen, nicht die gesamte Architektur.

Viel Erfolg beim Bauen!

---

**Erstellt:** 2026-02-07
**Basierend auf:** YouTube-Video von Barty-Bart + eigener Recherche
**Template:** next-saas-starter by Lee Robinson (Vercel)
