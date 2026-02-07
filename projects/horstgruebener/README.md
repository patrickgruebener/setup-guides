# Projekt: horstgruebener.de (Website)

**Stand:** 2026-02-07

## Kurzüberblick

- **Produkt:** Portfolio-/Lead-Gen Onepager für Horst Grübener
- **Tech Stack:** Vite 6 + React 18 + TypeScript + Tailwind CSS v4 + React Router v7
- **Produktion (Live / Canonical):** https://www.horstgruebener.de
- **Produktion (Redirect):** https://horstgruebener.de → https://www.horstgruebener.de
- **Test/Staging (NOINDEX):** https://test.horstgruebener.de
- **Repo:** https://github.com/patrickgruebener/Horstgruebener
- **Code-Root lokal:** `horstgruebener/website/`

## Branches

- `main` → **Produktion** (Domains: `www.horstgruebener.de`, `horstgruebener.de`)
- `staging` → **Test/Staging** (Domain: `test.horstgruebener.de`, muss **NOINDEX** sein)

## Lokal starten

**Voraussetzungen:**
- Node.js 20.x
- npm

```bash
cd website
npm ci

# Terminal 1: API (Kontaktformular)
npm run dev:api

# Terminal 2: Frontend Dev-Server
npm run dev
```

**Ports:**
- Frontend: `http://127.0.0.1:5173`
- API-only: `http://127.0.0.1:5174` (wird im Dev via Vite-Proxy über `/api` angesprochen)

## Umgebungsvariablen

**Kontaktformular (Resend):**
- `RESEND_API_KEY` (in Production Pflicht)
- `RESEND_FROM` (optional; Default: `Kontaktformular <kontakt@horstgruebener.de>`)
- `CONTACT_TO` (optional; Default: `horstgruebener@t-online.de`, mehrere Empfänger kommasepariert)

**SEO / Domains (Server):**
- `SITE_URL`
  - Prod: `https://www.horstgruebener.de`
  - Staging: `https://test.horstgruebener.de`
- `CANONICAL_HOST` (Prod)
  - `www.horstgruebener.de`
- `FORCE_HTTPS` (Prod + Staging)
  - `1` erzwingt HTTPS Redirect (wenn Proxy davor sitzt)

**Staging (WICHTIG: NOINDEX):**
- `NO_INDEX=1`
- `NO_INDEX_HOSTS=test.horstgruebener.de`

**Server (optional):**
- `PORT` (Default: `80`)
- `HOST` (Default: `0.0.0.0`)
- `API_ONLY` (wenn `1/true`, dann nur API-Endpunkte)
- `CONTACT_RATE_LIMIT_MAX` (Default: `10`)
- `CONTACT_RATE_LIMIT_WINDOW_MS` (Default: `900000` = 15 Minuten)

**Lokal:** `.env.local`/`.env` (siehe `horstgruebener/website/.env.example`)  
**Dokploy:** als Environment Variables im Projekt setzen.

## Build & Production lokal

```bash
cd website
npm run build
PORT=3000 npm run start
```

Oder über Docker (entspricht dem Dokploy-Setup):

```bash
cd website
docker build -t horstgruebener-web .
docker run --rm -p 8080:80 horstgruebener-web
# Öffnen: http://localhost:8080
```

## Deployment (Dokploy)

- **VPS:** Hostinger, Ubuntu 24.04 LTS
- **IP:** `76.13.11.84`
- **Dokploy Panel:** `http://76.13.11.84:3000`

Empfohlen sind **2 Dokploy Applications**:
- **Prod App**
  - Branch: `main`
  - Domains: `www.horstgruebener.de` + `horstgruebener.de`
- **Staging App**
  - Branch: `staging`
  - Domain: `test.horstgruebener.de`
  - Muss `NO_INDEX=1` gesetzt haben

**Build Type:** Dockerfile (`horstgruebener/website/Dockerfile`)  
**Container:** startet `node server/index.js` und serviert `dist/` + `POST /api/contact`  
**Port:** Container-Port `80`

## Domains / DNS (IONOS)

- ✅ `test.horstgruebener.de` → A-Record `test` auf `76.13.11.84`
- ✅ `horstgruebener.de` → A-Record `@` auf `76.13.11.84`
- ✅ `www.horstgruebener.de` → A-Record `www` auf `76.13.11.84` (oder CNAME `www` → `horstgruebener.de`)

## Wichtige Referenzen im Projekt

- `horstgruebener/website/CLAUDE.md` (vollständige Projektdoku inkl. Infrastruktur/Workflows)
- `horstgruebener/website/DEPLOYMENT.md` (Branch/DNS/ENV inkl. NOINDEX)
- `horstgruebener/website/server/index.js` (Kontakt-API + SEO/Robots/Sitemap + Static/SPA-Fallback)
- `horstgruebener/website/Dockerfile` (Build/Runtime für Dokploy)
