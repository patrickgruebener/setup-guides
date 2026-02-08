# Vibe Coding Workflow - Next.js SaaS Starter + Dokploy

Kompletter Workflow zum schnellen Aufsetzen und Entwickeln von SaaS-Apps mit Claude Code und Dokploy.

---

## Übersicht

Dieses System erlaubt es dir, innerhalb von Minuten ein produktionsreifes SaaS-Projekt zu starten, das bereits enthält:

- Authentication (Email/Passwort, JWT)
- Stripe Payments & Subscriptions
- User & Team Management mit RBAC
- Landing Page & Dashboard
- Type-Safe Database (Drizzle ORM + PostgreSQL)
- shadcn/ui Komponenten

Danach sagst du Claude Code nur noch **"Baue Feature X"** und das Plumbing (Auth, DB, UI) ist bereits vorhanden.

**Deployment:** Self-Hosted auf deinem VPS mit Dokploy (wie Vercel, aber auf eigener Infrastruktur).

---

## 1. Einmalige Vorbereitung (nur beim ersten Mal)

### 1.1 Voraussetzungen prüfen

```bash
# Node.js Version (min. 20+)
node --version

# npm Version
npm --version

# Stripe CLI installieren
# macOS:
brew install stripe/stripe-cli/stripe
# Oder: https://docs.stripe.com/stripe-cli
```

### 1.2 VPS & Dokploy Setup

**Falls noch nicht vorhanden:**

Folge dem kompletten Guide: [Dokploy + GitHub Auto-Deployment](../deployment/dokploy-github-autodeploy.md)

**Kurzfassung:**
1. VPS bei Hostinger (oder Hetzner, DigitalOcean)
2. Ubuntu 24.04 LTS
3. Dokploy installieren: `curl -sSL https://dokploy.com/install.sh | sh`
4. Admin Panel: `http://[VPS_IP]:3000`

### 1.3 Accounts erstellen

**Benötigte Services:**
- [Stripe Account](https://dashboard.stripe.com/register) (kostenlos)
- [GitHub Account](https://github.com/signup) (für Code-Hosting)
- VPS mit Dokploy (siehe 1.2)

### 1.4 Stripe CLI einrichten

```bash
# Stripe CLI mit deinem Account verbinden
stripe login
```

Das öffnet deinen Browser zur Authentifizierung.

---

## 2. Neues Projekt erstellen

### 2.1 Projekt aus Template generieren

```bash
# Im Terminal
cd ~/Documents/Freelance/setup-guides/scripts

# Neues Projekt erstellen
./new-saas-project.sh mein-projekt-name
```

**Was passiert:**
- Template wird nach `setup-guides/projects/mein-projekt-name/` kopiert
- `.env` Datei wird erstellt
- `.node-version` wird erstellt (für Dokploy Nixpacks)
- `pnpm-lock.yaml` wird entfernt (wir nutzen npm)
- `CLAUDE.md` wird mit Projektnamen angepasst
- Git Repository wird initialisiert
- Initiales Commit wird erstellt

### 2.2 Zum Projekt wechseln

```bash
cd ~/Documents/Freelance/setup-guides/projects/mein-projekt-name
```

### 2.3 VS Code öffnen

```bash
code .
```

---

## 3. Projekt konfigurieren

### 3.1 CLAUDE.md ausfüllen

Öffne `CLAUDE.md` und ersetze alle Platzhalter:
- `[PROJEKT-NAME]` → Dein Projektname
- `[VPS_IP]` → Deine VPS IP-Adresse
- `[USERNAME]` → Dein GitHub Username
- `[REPO-NAME]` → Repository Name
- Alle weiteren `[...]` Platzhalter

Das gibt Claude Code später den kompletten Kontext über dein Projekt.

### 3.2 Dependencies installieren

```bash
npm install
```

### 3.3 PostgreSQL Datenbank in Dokploy erstellen

1. **Dokploy Admin Panel öffnen**
   ```
   http://[VPS_IP]:3000
   ```

2. **Projekt erstellen**
   - Dashboard → Create Project
   - Name: z.B. "mein-projekt-name"

3. **PostgreSQL Database hinzufügen**
   - Im Projekt → Create Database
   - Type: PostgreSQL
   - Name: "postgres"
   - Port: 5432
   - Database Name: mein_projekt_name (Unterstriche statt Bindestriche!)
   - Username: postgres
   - Password: [generiere sicheres Passwort, z.B. mit: `openssl rand -base64 32`]

4. **Connection String notieren**

   Dokploy zeigt die Connection String an. Format:
   ```
   postgresql://postgres:[PASSWORD]@postgres:5432/[DATABASE_NAME]
   ```

5. **In .env eintragen**
   ```bash
   POSTGRES_URL=postgresql://postgres:[PASSWORD]@postgres:5432/[DATABASE_NAME]
   ```

### 3.4 Stripe konfigurieren

```bash
# Stripe Test Secret Key holen
# 1. Gehe zu: https://dashboard.stripe.com/test/apikeys
# 2. Kopiere "Secret key" (beginnt mit sk_test_)
# 3. Füge ihn in .env ein:
STRIPE_SECRET_KEY=sk_test_***
```

### 3.5 .env vervollständigen

Deine `.env` Datei sollte jetzt so aussehen:

```bash
POSTGRES_URL=postgresql://postgres:***@postgres:5432/database
STRIPE_SECRET_KEY=sk_test_***
STRIPE_WEBHOOK_SECRET=whsec_***  # Erst später beim Stripe Webhook Setup
BASE_URL=http://localhost:3000
AUTH_SECRET=***  # Generiere mit: openssl rand -base64 32
```

**AUTH_SECRET generieren:**
```bash
openssl rand -base64 32
```

Kopiere den Output und füge ihn als `AUTH_SECRET` in `.env` ein.

---

## 4. Datenbank Setup (Lokal)

### 4.1 Datenbank initialisieren

```bash
# Datenbank-Setup (prüft .env und erstellt Tabellen)
npm run db:setup

# Migrations ausführen
npm run db:migrate

# Test-User anlegen
npm run db:seed
```

**Test-User Credentials:**
- Email: `test@test.com`
- Passwort: `admin123`

### 4.2 Überprüfung

```bash
# Drizzle Studio öffnen (Datenbank-GUI)
npm run db:studio
```

Das öffnet eine lokale GUI auf `https://local.drizzle.studio`. Hier siehst du alle Tabellen und kannst Daten durchsehen.

---

## 5. Entwicklung starten

### 5.1 Dev-Server starten

```bash
npm run dev
```

App läuft auf: [http://localhost:3000](http://localhost:3000)

### 5.2 Stripe Webhooks lokal empfangen

**In einem zweiten Terminal:**

```bash
stripe listen --forward-to localhost:3000/api/stripe/webhook
```

**Wichtig:** Kopiere den `whsec_***` Webhook-Secret aus dem Output und füge ihn in `.env` ein:

```bash
STRIPE_WEBHOOK_SECRET=whsec_***
```

Starte dann den Dev-Server neu (`npm run dev`).

### 5.3 App testen

1. Öffne [http://localhost:3000](http://localhost:3000)
2. Klicke auf "Sign In"
3. Login mit `test@test.com` / `admin123`
4. Du solltest das Dashboard sehen

**Stripe Payments testen:**
1. Gehe zu `/pricing`
2. Wähle einen Plan
3. Test-Kreditkarte: `4242 4242 4242 4242`
4. Beliebiges Ablaufdatum & CVC
5. Checkout abschließen

---

## 6. Features mit Claude Code bauen

Jetzt kommt der "Vibe Coding" Teil. Du beschreibst Claude Code, was du willst, und es wird gebaut.

### 6.1 Claude Code im Terminal öffnen

In VS Code:
- `Cmd+Shift+P` → "Claude Code: New Chat"
- Oder direkt im Terminal: `claude chat`

### 6.2 Feature beschreiben

**Beispiel-Prompt:**

```
Ich möchte eine neue Dashboard-Seite unter /dashboard/invoices erstellen.

Anforderungen:
1. Nutze eine shadcn/ui Table-Komponente
2. Zeige alle Rechnungen des aktuellen Users
3. Felder: invoice_date, client_name, amount, status
4. Erstelle das Drizzle Schema für die "invoices" Tabelle
5. Erstelle eine Query-Funktion, um Invoices für den User zu holen
6. Die Seite soll im Dashboard-Layout eingebettet sein

Verwende die bestehenden Patterns aus dem Template (Server Components, Drizzle Queries, etc.).
```

### 6.3 Claude Code arbeitet

Claude Code wird:
1. Drizzle Schema in `lib/db/schema.ts` erstellen
2. Migration generieren (`npm run db:generate`)
3. Query-Funktion in `lib/db/queries.ts` erstellen
4. Neue Route `app/(dashboard)/invoices/page.tsx` erstellen
5. shadcn/ui Table-Komponente integrieren

### 6.4 Migration anwenden

```bash
npm run db:migrate
```

### 6.5 Testen

1. Browser: [http://localhost:3000/dashboard/invoices](http://localhost:3000/dashboard/invoices)
2. Prüfen, ob die Seite lädt
3. Bei Bedarf Test-Daten in Drizzle Studio einfügen

### 6.6 Committen

```bash
git add .
git commit -m "Add invoices feature"
```

---

## 7. Deployment (Production)

### 7.1 GitHub Repository erstellen

```bash
# GitHub CLI (falls installiert)
gh repo create mein-projekt-name --public --source=. --remote=origin

# Oder manuell auf github.com ein Repo erstellen und:
git remote add origin https://github.com/USERNAME/mein-projekt-name.git
git push -u origin main
```

### 7.2 Application in Dokploy erstellen

1. **Dokploy Admin Panel öffnen**
   ```
   http://[VPS_IP]:3000
   ```

2. **Im bestehenden Projekt → Create Application**
   - Name: z.B. "app" oder "production"
   - Provider: GitHub

3. **GitHub Repository verbinden**
   - Dokploy fordert GitHub-Autorisierung
   - GitHub App installieren (für alle Repos oder spezifisch)
   - Dein Projekt-Repository auswählen

4. **Build-Einstellungen**
   - Repository: `username/mein-projekt-name`
   - Branch: `main`
   - Auto Deploy: ✅ aktivieren
   - Build Type: Nixpacks (Standard)
   - Port: 3000

### 7.3 Environment Variables in Dokploy setzen

In Dokploy Application Settings → Environment:

```bash
POSTGRES_URL=postgresql://postgres:[PASSWORD]@postgres:5432/[DATABASE_NAME]
STRIPE_SECRET_KEY=sk_live_***  # WICHTIG: Live Key, nicht Test Key!
STRIPE_WEBHOOK_SECRET=whsec_***  # Von Production Webhook (siehe unten)
BASE_URL=https://yourdomain.com
AUTH_SECRET=***  # Gleicher Wert wie lokal oder neu generieren
```

**Wichtig:** Der `POSTGRES_URL` verwendet `@postgres:5432` (Docker-interner Hostname), nicht `@localhost`.

### 7.4 Domain konfigurieren

**DNS bei deinem Provider (z.B. IONOS):**

1. A-Record erstellen:
   ```
   Type: A
   Name: @ (für Hauptdomain) oder test (für Subdomain)
   Value: [VPS_IP]
   TTL: 300
   ```

2. www A-Record (optional):
   ```
   Type: A
   Name: www
   Value: [VPS_IP]
   TTL: 300
   ```

**Domain in Dokploy hinzufügen:**

1. Application Settings → Domains
2. Add Domain: `yourdomain.com`
3. Certificate: Auto (Let's Encrypt)
4. Save

SSL/HTTPS wird automatisch aktiviert.

**DNS-Propagierung prüfen:**
```bash
dig +short yourdomain.com A
# Sollte [VPS_IP] zurückgeben
```

### 7.5 Production Stripe Webhook erstellen

1. Gehe zu [dashboard.stripe.com/webhooks](https://dashboard.stripe.com/webhooks)
2. "Add endpoint"
3. Endpoint URL: `https://yourdomain.com/api/stripe/webhook`
4. Events auswählen:
   - `checkout.session.completed`
   - `customer.subscription.updated`
   - `customer.subscription.deleted`
5. Webhook Secret kopieren (`whsec_***`)
6. In Dokploy Environment Variables als `STRIPE_WEBHOOK_SECRET` eintragen

### 7.6 Deployment

**Erster Deploy:**
Klicke in Dokploy auf "Deploy" Button.

**Danach automatisch:**
```bash
git push origin main
```

Dokploy deployed automatisch bei jedem Push zu `main`.

**Deployment-Logs:** Dokploy Admin → Deployments → Latest

---

## 8. Typische Workflows

### Neue UI-Komponente hinzufügen

```bash
# shadcn/ui Komponente installieren
npx shadcn@latest add dialog

# Claude Code nutzen:
"Erstelle einen Dialog, um neue Invoices hinzuzufügen.
Nutze die gerade installierte Dialog-Komponente."
```

### Neues Datenbankfeld hinzufügen

```bash
# 1. Schema bearbeiten (oder Claude Code bitten)
# lib/db/schema.ts

# 2. Migration generieren
npm run db:generate

# 3. Migration anwenden
npm run db:migrate
```

### Neue geschützte Route hinzufügen

```bash
# Route erstellen (oder Claude Code bitten):
# app/(dashboard)/neue-route/page.tsx

# Automatisch geschützt durch (dashboard) Layout
```

### API Route hinzufügen

```bash
# Route erstellen (oder Claude Code bitten):
# app/api/meine-api/route.ts

# Server Actions sind meist besser als API Routes
```

---

## 9. Tipps für effektives Vibe Coding

### Claude Code richtig einsetzen

**Gute Prompts:**
- Konkret: "Erstelle eine Invoice-Tabelle mit Feldern X, Y, Z"
- Kontext: "Nutze die bestehenden Patterns aus dem Template"
- Komponenten nennen: "Verwende shadcn/ui Table"

**Vermeide:**
- Vage Anfragen: "Mach die App besser"
- Zu viele Features auf einmal (aufteilen in Schritte)
- Widersprüchliche Anforderungen

### Struktur beibehalten

Das Template hat klare Patterns:
- Server Components für Daten-Fetching
- Server Actions für Mutations
- Drizzle für Type-Safe Queries
- shadcn/ui für UI

Claude Code kennt diese Patterns. Halte dich daran.

### Iterativ arbeiten

1. Feature beschreiben
2. Code generieren lassen
3. Testen
4. Anpassen (falls nötig)
5. Committen
6. Nächstes Feature

### CLAUDE.md aktualisieren

Wenn sich Infrastruktur ändert (neue APIs, neue Tabellen, neue Deployment-Settings), aktualisiere `CLAUDE.md`. Das gibt Claude Code immer den aktuellen Kontext.

---

## 10. Troubleshooting

### "Error: Failed to connect to database"

**Lokal:**
- Prüfe `POSTGRES_URL` in `.env`
- Stelle sicher, dass PostgreSQL Container in Dokploy läuft

**Production:**
- Prüfe Environment Variables in Dokploy
- Hostname muss `@postgres:5432` sein (nicht `@localhost`)

### "Stripe webhook signature verification failed"

**Lokal:**
- Prüfe `STRIPE_WEBHOOK_SECRET` in `.env`
- Stelle sicher, dass `stripe listen` läuft
- Kopiere den Secret aus dem `stripe listen` Output

**Production:**
- Prüfe Webhook Secret in Dokploy Environment Variables
- Webhook URL muss `https://yourdomain.com/api/stripe/webhook` sein

### "Module not found" Fehler

```bash
# Dependencies neu installieren
rm -rf node_modules package-lock.json
npm install
```

### Build-Fehler in Dokploy

- Prüfe Build-Logs in Dokploy Dashboard
- Teste `npm run build` lokal
- Prüfe, ob `.node-version` Datei vorhanden ist
- Prüfe Environment Variables

### DNS funktioniert nicht

```bash
# DNS-Propagierung prüfen
dig +short yourdomain.com A

# Sollte [VPS_IP] zurückgeben
# Falls nicht: Warten (bis zu 24h) oder DNS-Einstellungen prüfen
```

---

## 11. Weiterführende Ressourcen

### Dokumentation
- [Next.js Docs](https://nextjs.org/docs)
- [Drizzle ORM Docs](https://orm.drizzle.team/docs/overview)
- [Stripe Docs](https://docs.stripe.com/)
- [shadcn/ui Components](https://ui.shadcn.com/)
- [Dokploy Docs](https://docs.dokploy.com)

### Template
- [next-saas-starter GitHub](https://github.com/leerob/next-saas-starter)
- [Demo](https://next-saas-start.vercel.app/)

### Setup Guides
- [Hauptverzeichnis](../README.md)
- [Dokploy + GitHub Auto-Deployment](../deployment/dokploy-github-autodeploy.md)
- [Git SSH Setup](../git/ssh-key-setup.md)

---

## 12. Quick Reference

### Häufigste Befehle

```bash
# Entwicklung
npm run dev                   # Dev-Server starten
npm run db:studio             # Datenbank-GUI öffnen
stripe listen --forward-to localhost:3000/api/stripe/webhook  # Webhooks lokal

# Datenbank
npm run db:generate           # Migration generieren (nach Schema-Änderung)
npm run db:migrate            # Migration anwenden
npm run db:seed               # Test-Daten einfügen

# Deployment
npm run build                 # Production Build testen
git add . && git commit -m "..." && git push  # Deploy zu Dokploy

# shadcn/ui
npx shadcn@latest add [component]  # Neue Komponente hinzufügen
```

### Projekt-Struktur

```
mein-projekt/
├── app/
│   ├── (dashboard)/        # Geschützte Routes
│   ├── (login)/            # Auth-Routes
│   ├── api/                # API Routes
│   └── page.tsx            # Landing Page
├── lib/
│   ├── db/                 # Drizzle Schema & Queries
│   ├── auth/               # Auth-Logik
│   └── payments/           # Stripe-Integration
├── components/
│   └── ui/                 # shadcn/ui Komponenten
├── .env                    # Lokal (nicht committen!)
├── .node-version           # Node-Version für Dokploy
└── CLAUDE.md               # Projekt-Dokumentation für Claude
```

### Deployment-Flow

```
Lokal entwickeln
    ↓
git push
    ↓
GitHub Webhook
    ↓
Dokploy baut (Nixpacks)
    ↓
npm install → npm run build → npm start
    ↓
Live auf yourdomain.com
```

---

**Zurück zu:** [Setup Guides](../README.md)
