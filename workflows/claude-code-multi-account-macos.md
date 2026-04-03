# Claude Code: Multi-Account Setup macOS

Zwei Claude-Accounts (z.B. persönlicher Max-Plan + Team-Account) in verschiedenen Editoren betreiben.

---

## Ziel

| Editor | Account |
|--------|---------|
| Cursor (Dock + Terminal) | Persönlich (Max Plan) |
| VS Code (Terminal `code .`) | Client/Team-Account |

---

## Funktionsprinzip

Claude Code bestimmt den Account in dieser Reihenfolge:

1. `CLAUDE_CONFIG_DIR` Env-Var → `.claude.json` im angegebenen Verzeichnis
2. Kein `CLAUDE_CONFIG_DIR` → `~/.claude/.claude.json`
3. Kein `.claude.json` → macOS Keychain ("Claude Code-credentials")

**Wichtig:** `terminal.integrated.env.osx` in VS Code/Cursor-Settings wirkt NUR im Terminal-Panel, NICHT im Extension Host (wo Claude Code läuft). Für den Extension Host muss die Env-Var im Editor-Prozess selbst gesetzt sein.

---

## Setup

### 1. Config-Verzeichnisse anlegen

```bash
mkdir -p ~/.claude-config-personal ~/.claude-config-client
```

### 2. Persönlichen Account einloggen

In einem normalen Terminal (nicht aus Claude Code Session heraus):

```bash
CLAUDE_CONFIG_DIR=~/.claude-config-personal claude login
```

→ Schreibt Credentials nach `~/.claude-config-personal/.claude.json`

### 3. Settings in beide Config-Dirs kopieren

```bash
cp ~/.claude/settings.json ~/.claude-config-personal/settings.json
cp ~/.claude/settings.json ~/.claude-config-client/settings.json
```

### 4. ~/.claude auf persönlichen Account setzen

```bash
cp ~/.claude-config-personal/.claude.json ~/.claude/.claude.json
```

→ `~/.claude` (Default, Cursor Dock-Start) zeigt nun auf persönlichen Account.

### 5. CLAUDE_CONFIG_DIR global via launchctl setzen

Damit Cursor beim Dock-Start direkt den richtigen Config-Dir nutzt:

```bash
launchctl setenv CLAUDE_CONFIG_DIR /Users/patrick/.claude-config-personal
```

#### Persistent machen (LaunchAgent)

Datei: `~/Library/LaunchAgents/com.patrick.claude-env.plist`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.patrick.claude-env</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/launchctl</string>
        <string>setenv</string>
        <string>CLAUDE_CONFIG_DIR</string>
        <string>/Users/patrick/.claude-config-personal</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
```

```bash
launchctl load ~/Library/LaunchAgents/com.patrick.claude-env.plist
```

### 6. VS Code Shell-Funktion in ~/.zshrc

Die `code`-Funktion überschreibt die globale launchctl-Einstellung für VS Code:

```bash
# Claude Code - Account Trennung per Editor
# ~/.claude           = persönlicher Account (Default, Cursor Dock-Start)
# ~/.claude-config-client = Team-Account (VS Code via Terminal)
function code() {
    CLAUDE_CONFIG_DIR=/Users/patrick/.claude-config-client "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" "$@"
}
```

### 7. Team-Account in ~/.claude-config-client einloggen

In normalem Terminal:

```bash
CLAUDE_CONFIG_DIR=~/.claude-config-client claude login
```

→ Mit Team-Account einloggen.

---

## Verhalten nach Setup

| Szenario | Account |
|----------|---------|
| Cursor (Dock-Start) | Persönlich ✓ |
| `cursor .` aus Terminal | Persönlich ✓ |
| `code .` aus Terminal | Team ✓ |
| VS Code (Dock-Start) | Persönlich (Kompromiss) |

VS Code sollte für Client-Projekte immer aus dem Terminal geöffnet werden.

---

## Troubleshooting

| Problem | Ursache | Fix |
|---------|---------|-----|
| Extension zeigt falschen Account nach Neustart | launchctl nicht persistent | LaunchAgent plist anlegen und laden |
| `claude login` schlägt fehl | Nested Session (Claude Code läuft) | In normalem Terminal (Terminal.app) ausführen |
| `terminal.integrated.env.osx` hat keinen Effekt | Gilt nur für Terminal-Panel | launchctl-Approach verwenden |
| Nach Login immer noch alter Account | Keychain hat Priorität vor `.claude.json` | `claude logout && claude login` im Editor-Terminal |

---

## Schreibschutz: PreToolUse Hooks

Beide Instanzen laufen als derselbe macOS-User und haben vollen Dateisystemzugriff. Schutz gegen Cross-Contamination läuft über PreToolUse Hooks.

### Hook 1: protect-waf-volume.sh (in personal config)
Fragt (ask) wenn Personal-Claude auf `/Volumes/MarketingOnline/` schreiben will.

### Hook 2: protect-personal-system.sh (in client config)
Blockt (deny) wenn WAF-Claude Edit/Write auf persönliche Pfade ausführt.
Fragt (ask) wenn WAF-Claude Bash-Befehle mit persönlichen Pfaden ausführt.

**Erlaubte Pfade für WAF-Claude:** `/Volumes/MarketingOnline/`, `/tmp/`, `~/Documents/Freelance/W.A.F./`, `~/.claude-config-client/`
**Gesperrte Pfade für WAF-Claude:** `~/Documents/memory/`, `~/Documents/CLAUDE.md`, `~/.claude/`, `~/.claude-config-personal/`

Hook-Scripts: `~/.claude/hooks/` (von beiden Instanzen lesbar)

---

## WICHTIG: Settings-Dateien

`~/.claude/settings.json` wird NICHT geladen wenn `CLAUDE_CONFIG_DIR` gesetzt ist. Jede Instanz hat ihre eigene Settings-Datei:

- **Personal:** `~/.claude-config-personal/settings.json`
- **Client:** `~/.claude-config-client/settings.json`

Settings-Änderungen IMMER in die richtige Config schreiben!

---

## Dateien-Übersicht

```
~/.claude/                              # Default-Config (Fallback, ggf. ungenutzt)
~/.claude/.claude.json                  # Personal credentials (Kopie)
~/.claude/settings.json                 # Fallback Settings (nicht aktiv bei CLAUDE_CONFIG_DIR)
~/.claude/hooks/                        # Hook-Scripts (zentral, von beiden Instanzen genutzt)
~/.claude/hooks/protect-waf-volume.sh   # Personal → WAF: ask
~/.claude/hooks/protect-personal-system.sh  # WAF → Personal: deny/ask
~/.claude-config-personal/              # Personal-Config-Dir (Cursor)
~/.claude-config-personal/.claude.json  # Personal credentials (Original)
~/.claude-config-personal/settings.json # Personal Settings (AKTIV)
~/.claude-config-client/                # Client/Team-Config-Dir (VS Code)
~/.claude-config-client/.claude.json    # Team credentials (nach Login)
~/.claude-config-client/settings.json   # Client Settings (AKTIV)
~/Library/LaunchAgents/com.patrick.claude-env.plist  # Persistenter launchctl
```
