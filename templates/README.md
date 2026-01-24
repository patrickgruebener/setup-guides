# Templates

Wiederverwendbare Templates für neue Projekte.

## CLAUDE.md Template

Ein vollständiges CLAUDE.md Template mit allen wichtigen Bereichen für Projekt-Dokumentation.

### Verwendung

**1. Template in neues Projekt kopieren:**

```bash
# Im neuen Projekt-Verzeichnis
cp ~/Documents/Freelance/setup-guides/templates/CLAUDE.md ./CLAUDE.md
```

**2. Template anpassen:**

Öffne `CLAUDE.md` und ersetze alle Platzhalter:

- `[PROJEKT-NAME]` → Projektname
- `[PROJEKT-BESCHREIBUNG]` → Kurze Beschreibung
- `[VPS_IP]` → Deine VPS IP-Adresse
- `[USERNAME]` → Dein GitHub Username
- `[REPO-NAME]` → Repository-Name
- `[domain.com]` → Deine Domain
- Alle weiteren `[...]` Platzhalter

**3. Nicht benötigte Bereiche entfernen:**

Falls du z.B. kein VPS verwendest oder kein Deployment brauchst, lösche die entsprechenden Abschnitte.

**4. Zum Repository hinzufügen:**

```bash
git add CLAUDE.md
git commit -m "Add project documentation"
git push
```

### Schnellstart

```bash
# Neues Projekt erstellen
mkdir mein-neues-projekt
cd mein-neues-projekt

# Template kopieren
cp ~/Documents/Freelance/setup-guides/templates/CLAUDE.md ./CLAUDE.md

# Mit Editor öffnen und anpassen
nano CLAUDE.md  # oder code CLAUDE.md

# Git initialisieren (falls noch nicht geschehen)
git init
git add .
git commit -m "Initial commit with project documentation"
```

### Was enthält das Template?

- **Projekt-Übersicht**: Beschreibung, Status
- **Tech Stack**: Framework, Sprache, Tools
- **Infrastruktur**: VPS, Deployment, Domains
- **Git & GitHub**: Repository-Info, SSH-Keys
- **Deployment**: Build-Config, Workflow
- **Environment Variables**: Benötigte Variablen
- **Wichtige Befehle**: Dev, Build, Deployment
- **Nützliche Links**: Automatische Verlinkung zu Setup-Guides

### Vorteile

- Konsistente Dokumentation in allen Projekten
- Schneller Projekt-Start
- Claude hat sofort alle wichtigen Infos
- Links zu Setup-Guides sind bereits eingebaut
- Einfach anpassbar für verschiedene Projekt-Typen

### Anpassungen für verschiedene Projekt-Typen

**Frontend (Next.js, React, Vue):**
- Tech Stack anpassen
- Build-Scripts hinzufügen
- Environment Variables für APIs

**Backend (Node.js, Python, etc.):**
- Server-Specs ergänzen
- Database-Config hinzufügen
- API-Endpoints dokumentieren

**Full-Stack:**
- Frontend + Backend Bereiche kombinieren
- Monorepo-Struktur dokumentieren

**Statische Sites:**
- Deployment-Abschnitt vereinfachen
- Build-Output-Pfad angeben

### Beispiel-Workflow

```bash
# 1. Neues Next.js Projekt
npx create-next-app@latest mein-projekt
cd mein-projekt

# 2. Template kopieren
cp ~/Documents/Freelance/setup-guides/templates/CLAUDE.md ./CLAUDE.md

# 3. Template anpassen (in Editor)
# - Projekt-Name: "Mein Portfolio"
# - Tech Stack: Next.js 16, TypeScript, Tailwind
# - Deployment: Dokploy
# - Domain: portfolio.domain.com

# 4. Committen
git add CLAUDE.md
git commit -m "Add project documentation"

# 5. Deploy-Setup folgen
# → https://github.com/patrickgruebener/setup-guides/blob/main/deployment/dokploy-github-autodeploy.md
```

### Tipps

1. **Früh erstellen**: Gleich zu Projektbeginn, nicht später
2. **Aktuell halten**: Bei Infrastruktur-Änderungen anpassen
3. **Details sind wichtig**: IP-Adressen, Domains, API-Keys (Referenzen, nicht Werte!)
4. **Für Claude optimieren**: Claude liest diese Datei automatisch
5. **Links nutzen**: Verweise auf Setup-Guides statt alles zu wiederholen

---

Zurück zu: [Setup Guides Hauptverzeichnis](../README.md)
