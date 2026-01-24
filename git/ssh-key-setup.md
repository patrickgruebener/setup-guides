# SSH-Key Setup für GitHub und VPS

Komplette Anleitung zum Generieren und Konfigurieren von SSH-Keys für GitHub und VPS-Zugriff.

## Inhaltsverzeichnis
1. [Was ist ein SSH-Key?](#was-ist-ein-ssh-key)
2. [SSH-Key generieren](#ssh-key-generieren)
3. [SSH-Key zu GitHub hinzufügen](#ssh-key-zu-github-hinzufügen)
4. [SSH-Key zu VPS hinzufügen](#ssh-key-zu-vps-hinzufügen)
5. [SSH-Verbindung testen](#ssh-verbindung-testen)
6. [Troubleshooting](#troubleshooting)

---

## Was ist ein SSH-Key?

Ein SSH-Key ist ein Schlüsselpaar für sichere, passwortlose Authentifizierung:
- **Private Key:** Bleibt auf deinem Computer (NIEMALS teilen!)
- **Public Key:** Wird auf Server/GitHub hinterlegt

**Vorteile:**
- Sicherer als Passwörter
- Keine Passwort-Eingabe nötig
- Standard für Git-Operations und Server-Zugriff

---

## SSH-Key generieren

### 1. Prüfen, ob bereits ein Key existiert

```bash
ls -la ~/.ssh/
```

**Bestehende Keys erkennen:**
- `id_ed25519` oder `id_rsa` → Private Key
- `id_ed25519.pub` oder `id_rsa.pub` → Public Key

**Falls Keys existieren:** Direkt zu [SSH-Key zu GitHub hinzufügen](#ssh-key-zu-github-hinzufügen) springen.

### 2. Neuen SSH-Key generieren (empfohlen: Ed25519)

```bash
ssh-keygen -t ed25519 -C "deine-email@example.com"
```

**Prompts beantworten:**

1. **Enter file in which to save the key:**
   - Einfach ENTER drücken (Standard: `~/.ssh/id_ed25519`)

2. **Enter passphrase:**
   - Optional: Passphrase eingeben für zusätzliche Sicherheit
   - Oder ENTER für keine Passphrase (einfacher, aber weniger sicher)

**Ausgabe:**
```
Your identification has been saved in /Users/username/.ssh/id_ed25519
Your public key has been saved in /Users/username/.ssh/id_ed25519.pub
```

### 3. SSH-Agent starten und Key hinzufügen

```bash
# SSH-Agent starten
eval "$(ssh-agent -s)"

# Key zum Agent hinzufügen
ssh-add ~/.ssh/id_ed25519
```

**Bei macOS (zusätzlich):**

`~/.ssh/config` bearbeiten oder erstellen:
```bash
nano ~/.ssh/config
```

Folgendes einfügen:
```
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
```

Speichern: `Ctrl+O`, `ENTER`, `Ctrl+X`

---

## SSH-Key zu GitHub hinzufügen

### 1. Public Key kopieren

**macOS:**
```bash
pbcopy < ~/.ssh/id_ed25519.pub
```

**Linux:**
```bash
cat ~/.ssh/id_ed25519.pub
# Ausgabe markieren und kopieren (Ctrl+Shift+C)
```

**Oder manuell anzeigen:**
```bash
cat ~/.ssh/id_ed25519.pub
```

Ausgabe sieht so aus:
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAbc123... deine-email@example.com
```

### 2. Zu GitHub hinzufügen

1. **GitHub öffnen:** https://github.com/settings/keys
2. **"New SSH key" klicken**
3. **Title:** z.B. "MacBook Pro" oder "Work Laptop"
4. **Key type:** Authentication Key
5. **Key:** Public Key einfügen (der komplette String von `ssh-ed25519` bis Email)
6. **"Add SSH key" klicken**
7. GitHub-Passwort bestätigen (falls gefragt)

### 3. SSH-Verbindung zu GitHub testen

```bash
ssh -T git@github.com
```

**Beim ersten Mal:**
```
The authenticity of host 'github.com' can't be established.
Are you sure you want to continue connecting (yes/no)?
```
→ `yes` eingeben

**Erfolgreiche Ausgabe:**
```
Hi username! You've successfully authenticated, but GitHub does not provide shell access.
```

---

## SSH-Key zu VPS hinzufügen

### Option 1: ssh-copy-id (einfachste Methode)

```bash
ssh-copy-id root@<VPS_IP>
```

**Beispiel:**
```bash
ssh-copy-id root@76.13.11.84
```

**Beim ersten Mal:**
- VPS-Passwort eingeben
- Key wird automatisch zur `~/.ssh/authorized_keys` hinzugefügt

### Option 2: Manuell kopieren (falls ssh-copy-id nicht verfügbar)

**1. Public Key anzeigen:**
```bash
cat ~/.ssh/id_ed25519.pub
```

**2. Zu VPS verbinden:**
```bash
ssh root@<VPS_IP>
# Passwort eingeben
```

**3. Auf VPS: authorized_keys bearbeiten:**
```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
nano ~/.ssh/authorized_keys
```

**4. Public Key einfügen:**
- Kompletten Public Key (von lokalem Computer) einfügen
- Speichern: `Ctrl+O`, `ENTER`, `Ctrl+X`

**5. Berechtigungen setzen:**
```bash
chmod 600 ~/.ssh/authorized_keys
```

**6. VPS-Verbindung beenden:**
```bash
exit
```

### 3. SSH-Verbindung zu VPS testen

```bash
ssh root@<VPS_IP>
```

**Erfolg:** Keine Passwort-Abfrage mehr!

---

## SSH-Verbindung testen

### GitHub Test

```bash
ssh -T git@github.com
```

**Erwartete Ausgabe:**
```
Hi username! You've successfully authenticated...
```

### VPS Test

```bash
ssh root@<VPS_IP>
```

**Erwartete Ausgabe:** Direkte Verbindung ohne Passwort-Eingabe

### Git mit SSH verwenden

**Neues Repository clonen:**
```bash
git clone git@github.com:username/repo.git
```

**Bestehende Remote ändern (von HTTPS zu SSH):**
```bash
# Aktuell prüfen
git remote -v

# Ändern
git remote set-url origin git@github.com:username/repo.git

# Prüfen
git remote -v
```

---

## Troubleshooting

### "Permission denied (publickey)"

**Problem:** SSH-Key wird nicht akzeptiert.

**Lösungen:**

1. **SSH-Agent prüfen:**
   ```bash
   ssh-add -l
   # Falls leer:
   ssh-add ~/.ssh/id_ed25519
   ```

2. **Key auf GitHub prüfen:**
   - https://github.com/settings/keys
   - Key vorhanden?
   - Richtig kopiert?

3. **Verbose-Modus für Details:**
   ```bash
   ssh -vT git@github.com
   ```

### "Host key verification failed"

**Problem:** GitHub-Host nicht bekannt.

**Lösung:**
```bash
ssh-keyscan github.com >> ~/.ssh/known_hosts
```

### SSH-Key wird nicht gefunden

**Problem:** Key existiert, aber SSH findet ihn nicht.

**Lösung:** SSH-Config erstellen/prüfen:
```bash
nano ~/.ssh/config
```

Einfügen:
```
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
```

### VPS-Zugriff funktioniert nicht

**1. Berechtigungen prüfen (auf VPS):**
```bash
ls -la ~/.ssh/
# authorized_keys sollte 600 sein
# .ssh Ordner sollte 700 sein

chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

**2. Public Key korrekt hinterlegt?**
```bash
cat ~/.ssh/authorized_keys
# Sollte deinen Public Key enthalten
```

**3. SSH-Daemon neu starten (auf VPS):**
```bash
systemctl restart sshd
```

### Mehrere SSH-Keys verwalten

**Für verschiedene Accounts (z.B. privat + work):**

**1. Weitere Keys generieren:**
```bash
ssh-keygen -t ed25519 -C "work@example.com" -f ~/.ssh/id_ed25519_work
```

**2. SSH-Config anpassen:**
```bash
nano ~/.ssh/config
```

```
# Privat
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519

# Work
Host github-work
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_work
```

**3. Git-Remote mit spezifischem Host:**
```bash
git remote add origin git@github-work:company/repo.git
```

---

## Best Practices

1. **Passphrase verwenden** (empfohlen für zusätzliche Sicherheit)
2. **Ed25519 statt RSA** (moderner, sicherer, schneller)
3. **Separate Keys für verschiedene Zwecke** (privat/work)
4. **Private Keys NIEMALS teilen oder committen**
5. **Regelmäßig Keys rotieren** (alle 1-2 Jahre)
6. **Alte Keys von GitHub/VPS entfernen**

---

## Zusammenfassung

**SSH-Key Setup in 3 Schritten:**

1. **Generieren:**
   ```bash
   ssh-keygen -t ed25519 -C "email@example.com"
   ssh-add ~/.ssh/id_ed25519
   ```

2. **GitHub:**
   ```bash
   pbcopy < ~/.ssh/id_ed25519.pub
   # → https://github.com/settings/keys → New SSH key
   ssh -T git@github.com  # Test
   ```

3. **VPS:**
   ```bash
   ssh-copy-id root@<VPS_IP>
   ssh root@<VPS_IP>  # Test
   ```

**Fertig!** Ab jetzt: Passwortloser Zugriff auf GitHub und VPS.

---

## Weiterführende Ressourcen

- [GitHub SSH Docs](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [SSH.com - SSH Keys Explained](https://www.ssh.com/academy/ssh/key)
- [Ed25519 vs RSA](https://security.stackexchange.com/questions/90077/ssh-key-ed25519-vs-rsa)

---

Letztes Update: Januar 2026
