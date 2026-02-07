# Dokploy Setup: Vite + React (SPA)

Guide für das Deployment von Vite/React Single Page Applications auf Dokploy.

**Getestet mit:** Vite 6.x, React 18.x, React Router 7.x
**VPS:** Hostinger (Ubuntu 24.04 LTS)
**Dokploy Panel:** http://76.13.11.84:3000

---

## Voraussetzungen

### Lokal
- Node.js 20.x
- npm oder yarn
- Git
- Docker (für lokale Tests)

### Server
- Dokploy installiert und konfiguriert
- GitHub-Account mit Dokploy verbunden
- Domain mit A-Record auf VPS-IP

---

## Schritt 1: Projekt vorbereiten

### 1.1 Dockerfile erstellen

```dockerfile
# Dockerfile
# Build Stage
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Production Stage
FROM nginx:alpine

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built files from builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
```

### 1.2 nginx.conf erstellen

```nginx
# nginx.conf
server {
    listen 80;
    server_name _;

    root /usr/share/nginx/html;
    index index.html;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;

    # SPA routing - all routes go to index.html
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Cache static assets
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
}
```

### 1.3 .dockerignore erstellen

```
# .dockerignore
node_modules
dist
.git
.gitignore
README.md
*.log
.env
.env.local
```

### 1.4 .gitignore erstellen/prüfen

```
# .gitignore
node_modules/
dist/
.env
.env.local
.DS_Store
```

---

## Schritt 2: Lokal testen

```bash
# Docker Image bauen
docker build -t my-app-test .

# Container starten
docker run -d -p 8080:80 --name test-container my-app-test

# Testen
curl -I http://localhost:8080
# Erwartet: HTTP/1.1 200 OK

# React Router testen (sollte auch 200 zurückgeben)
curl -I http://localhost:8080/some-route

# Aufräumen
docker stop test-container && docker rm test-container
```

---

## Schritt 3: Dokploy konfigurieren

### 3.1 Neues Projekt erstellen

1. Dokploy Panel öffnen: http://76.13.11.84:3000
2. Neues Projekt erstellen
3. "Application" auswählen

### 3.2 Provider (GitHub) konfigurieren

| Feld | Wert |
|------|------|
| Provider | GitHub |
| Repository | Dein Repository auswählen |
| Branch | `main` (oder `staging`) |
| Trigger Type | `On Push` (für Auto-Deploy) |

### 3.3 Build Type konfigurieren

| Feld | Wert |
|------|------|
| Build Type | **Dockerfile** |
| Docker File | `Dockerfile` |
| Docker Context Path | `.` |
| Docker Build Stage | (leer lassen) |

**WICHTIG:** "Nixpacks" und "Static" funktionieren oft nicht zuverlässig für Vite/React SPAs. Dockerfile ist die sicherste Option.

### 3.4 Port konfigurieren

Im Tab **"Advanced"** oder **"Networking"**:

| Feld | Wert |
|------|------|
| Port / Container Port | `80` |

**WICHTIG:** Ohne explizite Port-Konfiguration gibt es "Bad Gateway" Fehler!

### 3.5 Domain hinzufügen

Im Tab **"Domains"**:

1. Domain hinzufügen: `deine-domain.de`
2. HTTPS aktivieren (Let's Encrypt)
3. Speichern

---

## Schritt 4: Deployment

### Erstes Deployment
1. Klicke auf **"Deploy"** Button
2. Beobachte die Build-Logs
3. Nach erfolgreichem Build: Website aufrufen

### Folgende Deployments
Werden automatisch bei `git push` ausgeführt (wenn "On Push" aktiviert ist).

---

## Troubleshooting

### Problem: "Bad Gateway" nach erfolgreichem Build

**Ursache 1:** Port nicht konfiguriert
- Lösung: Port auf `80` setzen (siehe 3.4)

**Ursache 2:** Container startet, stirbt aber sofort
- Prüfe Runtime-Logs im "Logs" Tab
- Container sollte "running" (grün) sein, nicht "exited" (rot)

### Problem: React Router Routes zeigen 404

**Ursache:** NGINX leitet nicht zu index.html weiter
- Lösung: `try_files $uri $uri/ /index.html;` in nginx.conf

### Problem: Build schlägt fehl mit "figma:asset"

**Ursache:** Figma Make verwendet spezielle Import-Syntax
- Lösung: Imports ändern von `figma:asset/abc.png` zu `../../assets/abc.png`

### Problem: "Static" Build-Type funktioniert nicht

**Ursache:** Dokploy Static-Modus hat Probleme mit manchen Konfigurationen
- Lösung: Auf "Dockerfile" Build-Type wechseln

---

## Referenz-Projekt

- **Repository:** https://github.com/patrickgruebener/Horstgruebener
- **Branches:** `main` (Prod), `staging` (Test)
- **Produktion (Canonical):** https://www.horstgruebener.de
- **Staging (NOINDEX):** https://test.horstgruebener.de

Hinweis: Wenn dein Projekt zusätzlich eine kleine API braucht (z.B. Kontaktformular) und du SEO/Robots/Sitemap serverseitig ausliefern willst, ist ein Node-Server (statt purem NGINX-Static) oft die einfachste Lösung.
