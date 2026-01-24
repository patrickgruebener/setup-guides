# [PROJEKT-NAME] - [PROJEKT-BESCHREIBUNG]

## Projekt-Übersicht
[Kurze Beschreibung des Projekts, Zweck, Zielgruppe]

**Status**: [z.B. In Entwicklung, Live, Prototype]

---

## Tech Stack
- **Framework**: [z.B. Next.js 16, React, Vue, etc.]
- **Sprache**: [z.B. TypeScript, JavaScript, Python]
- **Styling**: [z.B. Tailwind CSS, CSS Modules, styled-components]
- **Deployment**: [z.B. Dokploy, Vercel, Netlify, Docker]
- **Hosting**: [z.B. Hostinger VPS, AWS, DigitalOcean]

---

## Infrastruktur

### VPS (falls self-hosted)
- **Provider**: [z.B. Hostinger, Hetzner, DigitalOcean]
- **IP**: `[VPS_IP]`
- **OS**: [z.B. Ubuntu 24.04 LTS]
- **SSH**: `ssh root@[VPS_IP]` (via SSH-Key, kein Passwort)

### Deployment Platform
- **Platform**: [z.B. Dokploy, Docker, Vercel]
- **Admin Panel**: [falls zutreffend, z.B. http://VPS_IP:3000]
- **Account**: [Email-Adresse]

### Domains
| Domain | Zweck | Status | DNS |
|--------|-------|--------|-----|
| `[subdomain.domain.com]` | Test/Staging | [✅ Aktiv / ⏳ Pending] | A-Record → [VPS_IP] |
| `[domain.com]` | Produktion | [✅ Aktiv / ⏳ Pending] | [DNS-Status] |

### DNS Provider
- **Provider**: [z.B. IONOS, Cloudflare, Namecheap]
- **Login**: [URL zum DNS-Management]

---

## Git & GitHub

### Repository
- **URL**: https://github.com/[USERNAME]/[REPO-NAME]
- **Branch**: main
- **Autodeploy**: [✅ Aktiviert / ❌ Manuell]

### Git Config (Global)
```
user.name: [Name]
user.email: [Email oder noreply@...]
```

### SSH-Key
- **Pfad**: `~/.ssh/id_ed25519`
- **Setup-Guide**: [SSH-Key Setup](https://github.com/patrickgruebener/setup-guides/blob/main/git/ssh-key-setup.md)

---

## Deployment

### Setup-Anleitung
**Vollständiger Guide**: [Dokploy + GitHub Auto-Deployment](https://github.com/patrickgruebener/setup-guides/blob/main/deployment/dokploy-github-autodeploy.md)

### Build-Konfiguration

**Node.js Version** (falls Node.js-Projekt):
- Datei: `.node-version`
- Version: [z.B. 20]

**Build-System**:
- [z.B. Nixpacks (automatisch), Docker, etc.]

**Build-Scripts** (falls zutreffend):
```json
{
  "scripts": {
    "dev": "[Entwicklungs-Server-Command]",
    "build": "[Build-Command]",
    "start": "[Production-Start-Command]",
    "lint": "[Linting-Command]"
  }
}
```

---

## Environment Variables

### Konfiguration
**Wo werden sie gesetzt?**
- Lokal: `.env.local` (nicht committen!)
- Git: `.env.example` (MIT committen!)
- Produktion: [z.B. Dokploy Admin Panel, Vercel Dashboard, etc.]

### Benötigte Variables
```
# [Kategorie 1, z.B. API Keys]
[VARIABLE_NAME]=your_value_here

# [Kategorie 2, z.B. Database]
[DATABASE_URL]=your_database_url

# [Weitere Variables...]
```

**Wichtig:**
- ⚠️ NIEMALS API Keys in Git committen!
- `.env*` (außer `.env.example`) in `.gitignore` aufnehmen
- Separate Keys für Development und Production verwenden

---

## Deployment-Workflow

```
1. Lokal entwickeln    → [npm run dev / python manage.py runserver / etc.]
2. Änderungen testen   → Browser [localhost:PORT]
3. Commit & Push       → git add . && git commit -m "..." && git push
4. Auto-Deployment     → [Deployment-Platform] baut und deployed automatisch
5. Live prüfen         → [Produktions-URL]
```

**Deployment-Zeit**: ca. [1-3 Minuten / etc.]

---

## Wichtige Befehle

```bash
# Lokaler Dev-Server
[z.B. npm run dev]

# Build testen
[z.B. npm run build]

# Deployment (automatisch bei Push oder manuell)
git add . && git commit -m "Beschreibung" && git push

# VPS Verbindung (falls self-hosted)
ssh root@[VPS_IP]

# DNS prüfen
dig +short [domain.com] A

# [Weitere projekt-spezifische Befehle]
```

---

## Projekt-Struktur

```
[projekt-name]/
├── [wichtige-ordner]/
│   ├── [unterordner]/
│   └── [wichtige-dateien]
├── .node-version          # [Falls Node.js]
├── package.json           # [Falls Node.js]
├── .env.local            # Lokal (nicht committen)
├── .env.example          # Template (committen)
└── .gitignore
```

---

## Nächste Schritte

- [ ] [Aufgabe 1]
- [ ] [Aufgabe 2]
- [ ] [Aufgabe 3]

---

## Nützliche Links

- **Setup-Guides**: https://github.com/patrickgruebener/setup-guides
- **Deployment-Guide**: [Dokploy Auto-Deployment](https://github.com/patrickgruebener/setup-guides/blob/main/deployment/dokploy-github-autodeploy.md)
- **SSH-Setup**: [SSH-Key Guide](https://github.com/patrickgruebener/setup-guides/blob/main/git/ssh-key-setup.md)
- [Weitere projekt-spezifische Links]

---

## Notizen

[Platz für zusätzliche Notizen, Besonderheiten, wichtige Entscheidungen, etc.]
