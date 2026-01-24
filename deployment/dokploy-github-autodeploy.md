# Dokploy + GitHub Auto-Deployment Setup

Kompletter Guide für automatisches Deployment von GitHub-Repositories zu Dokploy (self-hosted PaaS).

## Inhaltsverzeichnis
1. [Übersicht](#übersicht)
2. [Voraussetzungen](#voraussetzungen)
3. [Dokploy Installation](#dokploy-installation)
4. [GitHub Repository Setup](#github-repository-setup)
5. [Dokploy Projekt-Konfiguration](#dokploy-projekt-konfiguration)
6. [Environment Variables](#environment-variables)
7. [DNS-Konfiguration](#dns-konfiguration)
8. [Deployment-Workflow](#deployment-workflow)
9. [Troubleshooting](#troubleshooting)
10. [Praktisches Beispiel: Next.js](#praktisches-beispiel-nextjs)

---

## Übersicht

**Was ist Dokploy?**
Dokploy ist eine self-hosted Platform-as-a-Service (PaaS) Alternative zu Vercel, Netlify oder Heroku. Es läuft auf deinem eigenen VPS und bietet:
- Automatisches Deployment bei Git Push
- Integrierte Build-Pipelines (Nixpacks, Docker)
- SSL/HTTPS Management
- Einfaches Admin-Panel

**Deployment-Flow:**
```
Code ändern → git push → GitHub Webhook → Dokploy Build → Auto-Deploy
```

---

## Voraussetzungen

### 1. VPS (Virtual Private Server)
- **Provider-Empfehlung:** Hostinger, Hetzner, DigitalOcean
- **Mindest-Specs:** 2 GB RAM, 1 vCPU, 20 GB Storage
- **OS:** Ubuntu 22.04 oder 24.04 LTS
- **SSH-Zugang:** Root oder Sudo-User

### 2. Domain
- Eigene Domain (z.B. bei IONOS, Namecheap, Hostinger)
- DNS-Verwaltung möglich

### 3. GitHub Account
- SSH-Key für GitHub ([Setup-Guide](../git/ssh-key-setup.md))

### 4. Lokale Umgebung
- Git installiert
- SSH-Key konfiguriert

---

## Dokploy Installation

### 1. VPS vorbereiten

SSH-Verbindung zum VPS:
```bash
ssh root@<DEINE_VPS_IP>
```

System aktualisieren:
```bash
apt update && apt upgrade -y
```

### 2. Dokploy installieren

Offizieller Installationsbefehl:
```bash
curl -sSL https://dokploy.com/install.sh | sh
```

Die Installation dauert ca. 3-5 Minuten und installiert:
- Docker
- Dokploy Server
- Traefik (Reverse Proxy)

### 3. Admin Panel öffnen

Nach der Installation:
```
Dokploy Admin Panel: http://<DEINE_VPS_IP>:3000
```

**Erste Anmeldung:**
1. Browser öffnen: `http://<DEINE_VPS_IP>:3000`
2. Account erstellen (Email + Passwort)
3. Anmelden

---

## GitHub Repository Setup

### 1. Repository erstellen

```bash
# Lokal
mkdir mein-projekt
cd mein-projekt

# Git initialisieren
git init

# Erste Dateien erstellen (z.B. package.json für Next.js)
# ...

# Erster Commit
git add .
git commit -m "Initial commit"
```

### 2. SSH-Key zu GitHub hinzufügen

Falls noch nicht geschehen: [SSH-Key Setup Guide](../git/ssh-key-setup.md)

### 3. GitHub Remote hinzufügen

```bash
# GitHub Repository erstellen (via Web oder gh CLI)
gh repo create mein-projekt --public

# Remote hinzufügen
git remote add origin git@github.com:USERNAME/mein-projekt.git

# Pushen
git branch -M main
git push -u origin main
```

### 4. Build-Konfiguration (Nixpacks)

Dokploy verwendet standardmäßig **Nixpacks** für automatische Builds.

**Für Node.js/Next.js Projekte:**

Erstelle `.node-version` Datei im Projekt-Root:
```bash
echo "20" > .node-version
```

Nixpacks erkennt automatisch:
- `package.json` → Node.js Projekt
- `.node-version` → Spezifische Node-Version
- Build-Command: `npm run build`
- Start-Command: `npm start`

---

## Dokploy Projekt-Konfiguration

### 1. Projekt erstellen

Im Dokploy Admin Panel:

1. **Dashboard** → **Create Project**
2. **Project Name:** z.B. "mein-projekt"
3. **Create**

### 2. Application hinzufügen

1. Im Projekt → **Create Application**
2. **Application Name:** z.B. "production" oder "app"
3. **Provider:** GitHub

### 3. GitHub Repository verbinden

**Option A: GitHub App Installation (empfohlen)**
1. Dokploy fordert GitHub-Autorisierung
2. GitHub App installieren (für alle Repos oder spezifisch)
3. Repository auswählen

**Option B: Manueller Deploy Key**
1. Dokploy generiert Deploy Key
2. In GitHub: Settings → Deploy Keys → Add
3. Key einfügen, "Allow write access" aktivieren

### 4. Build-Einstellungen

Im Application-Settings:

**Git:**
- **Repository:** `username/mein-projekt`
- **Branch:** `main`
- **Auto Deploy:** ✅ Aktivieren (wichtig!)

**Build:**
- **Build Type:** Nixpacks (Standard)
- **Build Path:** `/` (Root)
- **Dockerfile:** Leer lassen (Nixpacks verwendet `.node-version`)

**Port:**
- **Port:** 3000 (Standard für Next.js)
- Für andere Frameworks: entsprechend anpassen

### 5. Erste Deployment starten

1. **Deploy** Button klicken
2. Build-Logs beobachten
3. Bei Erfolg: Status "Running"

---

## Environment Variables

### Wo werden sie gesetzt?

Im Dokploy Admin Panel:
1. **Application** auswählen
2. **Settings** → **Environment**
3. Variables hinzufügen

### Format

```
KEY=value
```

**Beispiel:**
```
NODE_ENV=production
RESEND_API_KEY=re_abc123xyz
DATABASE_URL=postgresql://user:pass@host:5432/db
```

### Best Practices

**Lokal vs. Produktion:**

1. **Lokal:** `.env.local` (nicht committen!)
   ```
   RESEND_API_KEY=re_test_key_local
   ```

2. **Git:** `.env.example` (MIT committen!)
   ```
   RESEND_API_KEY=your_api_key_here
   ```

3. **Produktion:** Dokploy Admin Panel
   ```
   RESEND_API_KEY=re_prod_key_live
   ```

**Wichtig:**
- ⚠️ NIEMALS API-Keys in Git committen!
- `.env*` in `.gitignore` aufnehmen (außer `.env.example`)
- Separate Keys für Development und Production

### .gitignore für Environment Files

```gitignore
# Environment Variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
```

---

## DNS-Konfiguration

### 1. A-Record erstellen

Bei deinem Domain-Provider (z.B. IONOS):

**Subdomain (empfohlen für Tests):**
```
Type: A
Name: test  (oder staging, app, etc.)
Value: <DEINE_VPS_IP>
TTL: 300
```

Ergebnis: `test.deinedomain.com` → VPS

**Hauptdomain:**
```
Type: A
Name: @  (oder leer)
Value: <DEINE_VPS_IP>
TTL: 300
```

**www-Subdomain:**
```
Type: A
Name: www
Value: <DEINE_VPS_IP>
TTL: 300
```

### 2. Domain in Dokploy hinzufügen

Im Dokploy Application-Settings:

1. **Settings** → **Domains**
2. **Add Domain**
3. Domain eingeben: `test.deinedomain.com`
4. **Certificate:** Auto (Let's Encrypt)
5. **Save**

### 3. HTTPS/SSL

Dokploy aktiviert automatisch:
- Let's Encrypt SSL-Zertifikat
- Auto-Renewal (alle 90 Tage)
- HTTP → HTTPS Redirect

**Zertifikat-Status prüfen:**
- Im Dokploy Admin: Domains → Certificate Status
- Oder Browser: `https://test.deinedomain.com` (Schloss-Symbol)

### 4. DNS-Propagierung testen

```bash
# A-Record prüfen
dig +short test.deinedomain.com A

# Erwartete Ausgabe: <DEINE_VPS_IP>
```

**Hinweis:** DNS-Änderungen können 5 Minuten bis 24 Stunden dauern (abhängig von TTL).

---

## Deployment-Workflow

### Normaler Workflow

```bash
# 1. Lokal entwickeln
npm run dev

# 2. Im Browser testen
# http://localhost:3000

# 3. Änderungen commiten
git add .
git commit -m "Feature: Add new component"

# 4. Zu GitHub pushen
git push origin main

# 5. Auto-Deployment
# → GitHub sendet Webhook an Dokploy
# → Dokploy baut und deployed automatisch
# → Nach ca. 1-3 Minuten live
```

### Build-Prozess (automatisch)

1. **GitHub Webhook:** Triggert bei Push
2. **Dokploy empfängt Webhook**
3. **Repository clonen**
4. **Dependencies installieren:** `npm ci` oder `npm install`
5. **Build ausführen:** `npm run build`
6. **Container starten:** `npm start`
7. **Live schalten:** Traefik leitet Traffic um

### Deployment-Logs ansehen

Im Dokploy Admin Panel:
1. **Application** auswählen
2. **Deployments** Tab
3. Aktuelles Deployment anklicken
4. **Logs** ansehen

---

## Troubleshooting

### Build schlägt fehl

**Mögliche Ursachen:**

1. **Node-Version falsch**
   - Lösung: `.node-version` Datei prüfen/erstellen
   - Beispiel: `echo "20" > .node-version`

2. **npm run build schlägt fehl**
   - Lösung: Lokal testen: `npm run build`
   - TypeScript-Fehler beheben
   - Dependencies prüfen

3. **Environment Variables fehlen**
   - Lösung: In Dokploy Settings → Environment hinzufügen
   - Nach Änderung: Neu deployen

### Application startet nicht

**Logs prüfen:**
```bash
# Im Dokploy Admin Panel
Deployments → Latest → Logs
```

**Häufige Fehler:**
- Port 3000 bereits belegt → Port in Dokploy-Settings ändern
- Environment Variable fehlt → Settings prüfen
- Build erfolgreich, aber Start-Command fehlt → `package.json` prüfen

### DNS funktioniert nicht

```bash
# DNS-Propagierung prüfen
dig +short test.deinedomain.com A

# Erwartete Ausgabe: <DEINE_VPS_IP>
# Falls nicht: Warten (bis zu 24h) oder DNS-Provider-Einstellungen prüfen
```

### SSL-Zertifikat wird nicht erstellt

1. **DNS muss korrekt sein** (A-Record → VPS IP)
2. **Port 80 und 443 offen** (Firewall-Check)
3. **Domain erreichbar** (Browser-Test)

Dokploy versucht automatisch alle 5 Minuten, das Zertifikat zu erneuern.

---

## Praktisches Beispiel: Next.js

### Projekt-Struktur

```
mein-projekt/
├── .node-version          # "20"
├── package.json
├── next.config.js
├── src/
│   └── app/
│       ├── page.tsx
│       └── layout.tsx
├── .env.local            # Lokal (nicht committen)
├── .env.example          # Template (committen)
└── .gitignore
```

### package.json

```json
{
  "name": "mein-projekt",
  "version": "0.1.0",
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "^16.1.4",
    "react": "^19.2.3",
    "react-dom": "^19.2.3"
  },
  "devDependencies": {
    "@types/node": "^20",
    "@types/react": "^19",
    "typescript": "^5"
  }
}
```

### .node-version

```
20
```

### .env.example

```
# Resend API für Kontaktformular
RESEND_API_KEY=your_api_key_here

# Next.js
NEXT_PUBLIC_SITE_URL=https://deinedomain.com
```

### .gitignore

```
# Dependencies
node_modules/

# Next.js
.next/
out/

# Environment Variables
.env
.env.local
.env*.local

# Logs
npm-debug.log*
```

### Dokploy-Einstellungen

**Application Settings:**
- **Build Type:** Nixpacks
- **Branch:** main
- **Auto Deploy:** ✅
- **Port:** 3000

**Environment Variables (in Dokploy):**
```
RESEND_API_KEY=re_live_production_key_xyz
NEXT_PUBLIC_SITE_URL=https://test.deinedomain.com
```

**Domain:**
```
test.deinedomain.com
```

### Deployment testen

```bash
# 1. Lokaler Build-Test
npm run build
npm start

# 2. Git Push
git add .
git commit -m "Test: Deploy to Dokploy"
git push origin main

# 3. Dokploy-Logs prüfen
# → Im Admin Panel: Deployments → Latest

# 4. Live-Site prüfen
# → https://test.deinedomain.com
```

---

## Zusammenfassung

**Setup-Schritte:**
1. VPS einrichten + Dokploy installieren
2. GitHub Repository erstellen + `.node-version` hinzufügen
3. Dokploy: Projekt + Application erstellen
4. GitHub Repository verbinden + Auto-Deploy aktivieren
5. Environment Variables in Dokploy setzen
6. DNS: A-Record erstellen
7. Domain in Dokploy hinzufügen
8. `git push` → Auto-Deployment läuft

**Vorteile:**
- Push-to-Deploy (wie Vercel)
- Eigene Infrastruktur (volle Kontrolle)
- Kosteneffizient (nur VPS-Kosten)
- SSL/HTTPS automatisch

**Nachteile vs. Vercel:**
- Keine Edge-Functions
- Server-Wartung nötig
- Weniger Skalierung (Single-Server)

---

## Weiterführende Ressourcen

- [Dokploy Dokumentation](https://docs.dokploy.com)
- [Nixpacks](https://nixpacks.com/docs) (Build-System)
- [SSH-Key Setup Guide](../git/ssh-key-setup.md)

---

Letztes Update: Januar 2026
