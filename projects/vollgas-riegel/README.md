# Projekt: vollgasriegel.de (WordPress E-Commerce)

**Stand:** 2026-02-06

## Kurzüberblick

- **Produkt:** E-Commerce-Shop für Vollgas Sportriegel (WordPress + WooCommerce)
- **Tech Stack:** WordPress 6.7.4, PHP 8.2, MySQL 8.0, WooCommerce, Flatsome Theme
- **Produktion (Live):** https://www.vollgasriegel.de
- **Lokal (Docker):** http://localhost:8082
- **Code-Root lokal:** `/Users/patrick/Documents/Freelance/Zinzino/vollgas-website-local/`
- **Original Backup:** `/Users/patrick/Documents/Freelance/Zinzino/vollgas-website-alt/www-vollgasriegel-de-20260206-105739-t55pknmvxi7p.wpress`

## Technische Details

- **WordPress Version:** 6.7.4
- **PHP Version:** 8.2
- **MySQL Version:** 8.0 (kompatibel mit Produktion: 5.7)
- **Theme:** Flatsome Child (Parent: Flatsome 3.20.2)
- **Datenbank Prefix:** `wp_`
- **Datenbank Größe:** ~185 MB
- **Totale Dateigröße:** ~2.1 GB (inkl. Uploads)

## Lokal starten (Docker)

**Voraussetzungen:**
- Docker Desktop für Mac/Windows
- ~5 GB freier Speicherplatz

### Quick Start

```bash
cd /Users/patrick/Documents/Freelance/Zinzino/vollgas-website-local

# Container starten
docker compose up -d

# Status prüfen
docker compose ps

# Logs ansehen
docker compose logs -f
```

**Zugriff:**
- **Webseite:** http://localhost:8082
- **WordPress Admin:** http://localhost:8082/wp-admin
- **phpMyAdmin:** http://localhost:8081 (Login: `root` / `rootpassword`)

### Container stoppen/verwalten

```bash
# Container stoppen
docker compose down

# Container neu starten (bei Problemen)
docker compose restart

# Kompletter Neustart (inkl. Datenbank löschen)
docker compose down -v
docker compose up -d
```

## Projektstruktur

```
vollgas-website-local/
├── docker-compose.yml         # Docker-Konfiguration
├── README.md                  # Ausführliche Anleitung
├── database.sql              # Datenbank-Export (Original, SERVMASK_PREFIX)
├── plugins/                  # WordPress-Plugins (38+ Plugins)
│   ├── woocommerce/          # WooCommerce Shop-System
│   ├── woocommerce-german-market/
│   ├── yith-woocommerce-points-and-rewards-premium/
│   └── ...
├── themes/                   # WordPress-Themes
│   ├── flatsome/             # Parent Theme
│   └── flatsome-child/       # Aktives Child Theme
├── uploads/                  # Medien-Uploads (Produktbilder, etc.)
├── languages/                # Sprachdateien (DE)
├── mu-plugins/               # Must-Use Plugins
└── cache/                    # Cache-Dateien
```

## Wichtige Plugins

- **WooCommerce:** Shop-System
- **WooCommerce German Market:** Deutsche Rechtskonformität
- **Yoast SEO:** SEO-Optimierung
- **WP Fastest Cache:** Performance
- **Stripe Gateway:** Zahlungen
- **PayPal Payments:** Zahlungen
- **B2B Market:** B2B-Funktionen
- **Customer Reviews:** Produktbewertungen

## Entwicklung mit VS Code & Claude Code

**Theme-Anpassungen:**
```
themes/flatsome-child/
├── style.css              # Child Theme Styles
├── functions.php          # Theme Functions
└── ...
```

**Plugin-Anpassungen:**
- Plugins können direkt in `plugins/` bearbeitet werden
- Änderungen sind sofort auf http://localhost:8082 sichtbar
- **WICHTIG:** Plugins-Updates könnten Änderungen überschreiben

**Datenbank-Änderungen:**
- Über phpMyAdmin: http://localhost:8081
- Oder über WP-CLI im Container:
  ```bash
  docker exec -it vollgas_wordpress wp --allow-root [command]
  ```

## Setup von .wpress Backup

### Extraktion durchgeführt am 2026-02-06

**Schritte:**
1. .wpress Datei mit `npx wpress-extract2` extrahiert (38.560 Dateien)
2. Docker-Setup erstellt (WordPress 6.7 + MySQL 8.0)
3. Datenbank importiert mit Prefix-Ersetzung:
   ```bash
   sed 's/SERVMASK_PREFIX_/wp_/g' database.sql | docker exec -i vollgas_db mysql ...
   ```
4. URLs aktualisiert (vollgasriegel.de → localhost:8082)
5. Theme-Einstellungen korrigiert (flatsome-child)

**Bekannte Probleme beim Setup:**
- MySQL 5.7 nicht auf ARM (Apple Silicon) → MySQL 8.0 mit Kompatibilitätsmodus
- SERVMASK_PREFIX muss ersetzt werden
- Theme-Einstellungen (template/stylesheet) müssen nach Import gesetzt werden

## Deployment (NICHT VORHANDEN)

**WICHTIG:** Dies ist eine reine lokale Entwicklungsumgebung. Es gibt aktuell kein automatisches Deployment zur Produktionsseite.

**Für Updates zur Produktion:**
1. Manuelle Änderungen über WordPress-Admin auf Produktionsseite
2. Oder FTP/SSH-Zugang zur Produktionsseite (Informationen beim Kunden/Hoster erfragen)
3. Oder neues .wpress Backup erstellen und auf Produktion importieren

**Original-Hoster:** Wahrscheinlich 1&1/IONOS (basierend auf Pfad im package.json)

## Datenbank-Management

### Backup erstellen

```bash
# Datenbank-Dump erstellen
docker exec vollgas_db mysqldump -u root -prootpassword wordpress > backup_$(date +%Y%m%d_%H%M%S).sql

# Mit Compression
docker exec vollgas_db mysqldump -u root -prootpassword wordpress | gzip > backup_$(date +%Y%m%d_%H%M%S).sql.gz
```

### Datenbank wiederherstellen

```bash
# Aus SQL-Datei
docker exec -i vollgas_db mysql -u root -prootpassword wordpress < backup.sql

# Aus komprimierter Datei
gunzip < backup.sql.gz | docker exec -i vollgas_db mysql -u root -prootpassword wordpress
```

### URLs zurück auf Produktion ändern (falls nötig)

```bash
docker exec vollgas_db mysql -u root -prootpassword wordpress -e "
UPDATE wp_options SET option_value = 'https://www.vollgasriegel.de' WHERE option_name = 'siteurl';
UPDATE wp_options SET option_value = 'https://www.vollgasriegel.de' WHERE option_name = 'home';
"
```

## Troubleshooting

### Weiße Seite / Keine Inhalte

**Lösung:** Theme-Einstellungen prüfen
```bash
docker exec vollgas_db mysql -u root -prootpassword wordpress -e "
UPDATE wp_options SET option_value = 'flatsome' WHERE option_name = 'template';
UPDATE wp_options SET option_value = 'flatsome-child' WHERE option_name = 'stylesheet';
"
```

### Container starten nicht

```bash
# Logs prüfen
docker compose logs

# Ports bereits belegt?
lsof -i :8082
lsof -i :8081

# Ports im docker-compose.yml ändern falls nötig
```

### Datenbank-Fehler

```bash
# Container neu starten
docker compose restart db

# Datenbank neu erstellen
docker compose down -v
docker compose up -d
# Dann Datenbank neu importieren (siehe oben)
```

### Performance-Probleme

```bash
# Cache-Verzeichnis leeren
rm -rf cache/*

# WordPress-Cache leeren (im Container)
docker exec -it vollgas_wordpress wp cache flush --allow-root
```

## Wichtige Referenzen

- **Projekt README:** `vollgas-website-local/README.md`
- **Docker Config:** `vollgas-website-local/docker-compose.yml`
- **Original Backup:** `vollgas-website-alt/www-vollgasriegel-de-20260206-105739-t55pknmvxi7p.wpress`

## Nächste Schritte (Optional)

- [ ] Git-Repository für Theme-Anpassungen einrichten
- [ ] Staging-Umgebung auf VPS (Dokploy/Coolify) aufsetzen
- [ ] CI/CD für automatisches Deployment
- [ ] Backup-Strategie für Produktions-Datenbank
- [ ] Performance-Optimierung (Redis Cache, CDN)

## Kontakt / Support

Bei Fragen zur Seite oder technischen Problemen kann Claude Code im VS Code verwendet werden, um direkt mit dem Projekt zu arbeiten.
