# Setup Guides

Zentrale Sammlung wiederverwendbarer Setup-Guides für Deployment, Infrastruktur und DevOps-Workflows.

## Zweck

Dieses Repository dient als zentrale Dokumentations-Quelle für wiederkehrende Setup-Prozesse. Anstatt in jedem Projekt die gleichen Deployment-Schritte zu dokumentieren, kann einfach auf diese Guides verlinkt werden.

## Schnellstart für neue Projekte

**CLAUDE.md Template verwenden:**
```bash
# Im neuen Projekt-Verzeichnis
cp ~/Documents/Freelance/setup-guides/templates/CLAUDE.md ./CLAUDE.md
```

Dann Platzhalter anpassen und committen. [Vollständige Anleitung](templates/README.md)

## Verfügbare Guides

### Templates
- [CLAUDE.md Template](templates/CLAUDE.md) - Wiederverwendbares Projekt-Dokumentations-Template
- [Template-Verwendung](templates/README.md) - Anleitung zur Template-Nutzung

### Deployment
- [Dokploy + GitHub Auto-Deployment](deployment/dokploy-github-autodeploy.md) - Kompletter Guide für automatisches Deployment von GitHub zu Dokploy (PaaS)

### Git & SSH
- [SSH-Key Setup](git/ssh-key-setup.md) - SSH-Keys generieren und zu GitHub/VPS hinzufügen

## Verwendung

### In anderen Projekten referenzieren

**In CLAUDE.md oder README:**
```markdown
## Deployment
Setup-Anleitung: [Dokploy Auto-Deployment Guide](https://github.com/patrickgruebener/setup-guides/blob/main/deployment/dokploy-github-autodeploy.md)
```

**Als Link in Dokumentation:**
```markdown
Das Deployment folgt dem [Dokploy-Setup](https://github.com/patrickgruebener/setup-guides).
```

### Guides anpassen

Die Guides sind als Vorlagen gedacht. Für spezifische Projekte:
1. Guide als Basis verwenden
2. Projekt-spezifische Anpassungen vornehmen
3. Im eigenen Projekt dokumentieren (z.B. in CLAUDE.md)

## Struktur

```
setup-guides/
├── templates/          # Projekt-Templates (CLAUDE.md, etc.)
├── deployment/         # Deployment-Strategien (Dokploy, Docker, etc.)
├── git/                # Git-Workflows und SSH-Setup
├── domains/            # DNS und Domain-Konfiguration (geplant)
├── tools/              # Tool-Installationen (n8n, etc.) (geplant)
└── monitoring/         # Monitoring-Setups (geplant)
```

## Geplante Erweiterungen

- `deployment/nixpacks-configuration.md` - Erweiterte Nixpacks-Konfiguration
- `domains/ionos-dns-setup.md` - Vollständiger DNS-Setup-Guide
- `tools/n8n-installation.md` - n8n Workflow-Automation-Setup
- `monitoring/uptime-monitoring.md` - Server-Monitoring einrichten

## Beiträge

Diese Guides basieren auf realen Produktions-Setups und werden kontinuierlich erweitert. Bei Fragen oder Verbesserungsvorschlägen gerne ein Issue erstellen.

## Lizenz

Diese Guides sind frei verwendbar. Bei Verwendung in öffentlichen Projekten wäre ein Verweis auf dieses Repository nett, aber nicht erforderlich.
