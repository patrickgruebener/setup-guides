# Playwright MCP – Setup Guide

Playwright MCP gibt Claude Code echten Browser-Zugriff: Screenshots, DOM-Inspektion, Navigation, JS-Execution, Login-Flows.

## Voraussetzungen

- Node.js v18+ (check: `node --version`)
- Claude Code CLI installiert

## Installation (einmalig)

### 1. MCP-Server registrieren

```bash
# User-scope: verfügbar in allen Projekten
claude mcp add --transport stdio --scope user playwright -- npx -y @playwright/mcp@latest
```

Alternativ nur für ein Projekt (local scope):
```bash
claude mcp add --transport stdio playwright -- npx -y @playwright/mcp@latest
```

### 2. Browser installieren

```bash
npx playwright install
```

Installiert Chromium, Firefox und WebKit (~200 MB).

### 3. Installation prüfen

```bash
claude mcp list
```

`playwright` sollte in der Liste erscheinen.

## Konfiguration

Config landet in `~/.claude-config-personal/.claude.json` (user scope) oder `~/.claude.json`:

```json
{
  "mcpServers": {
    "playwright": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest"],
      "env": {}
    }
  }
}
```

## Wichtig nach Setup

Claude Code neu starten, damit der MCP-Server geladen wird. Die Tools sind in bestehenden Sessions nicht verfügbar.

## Was Claude damit kann

- Webseiten vollständig laden inkl. JavaScript
- Screenshots machen
- DOM inspizieren
- Navigation, Klicks, Formulare
- Login-geschützte Bereiche aufrufen
- Network-Requests beobachten

## Troubleshooting

**Server startet nicht:**
```bash
npx @playwright/mcp@latest --version
```

**Timeout bei Start:**
```bash
MCP_TIMEOUT=10000 claude
```

**Browsers fehlen:**
```bash
npx playwright install
```

**MCP-Tools tauchen in Claude nicht auf, obwohl Playwright installiert ist:**
Playwright CLI (`npx playwright --version`) kann funktionieren, aber die MCP-Tools fehlen trotzdem. Ursachen:
- MCP-Server nicht registriert (`claude mcp list` prüfen)
- Claude Code nicht neu gestartet nach `claude mcp add`
- Config in falschem Scope (user vs. local)

Fix: `claude mcp add --scope user playwright -- npx -y @playwright/mcp@latest` + Claude Code neu starten.

**Chromium-Version stimmt nicht (Executable doesn't exist):**
Playwright installiert Browser-Binaries versioniert. Wenn ein neues Playwright-Package eine andere Version erwartet als installiert, schlägt launch() fehl. Workaround für lokale Scripts:
```js
executablePath: '/Users/patrick/Library/Caches/ms-playwright/chromium-1208/chrome-mac-arm64/Google Chrome for Testing.app/Contents/MacOS/Google Chrome for Testing'
```
Dauerlösung: `npx playwright install chromium` für die fehlende Version nachinstallieren.

## Hinweise

- `@playwright/mcp@latest` lädt das Package bei jedem Start via npx. Einmal gecacht, startet es schnell.
- Headless by default. Kein sichtbares Browserfenster.
- Pakete: `@playwright/mcp` (Microsoft, offiziell)
