#!/bin/bash

# ============================================
# Next.js SaaS Starter - Projekt-Generator
# ============================================
# Erstellt ein neues Projekt aus dem next-saas-starter Template
#
# Verwendung:
#   ./new-saas-project.sh <projekt-name>
#
# Beispiel:
#   ./new-saas-project.sh my-invoice-app
# ============================================

set -e  # Beende bei Fehler

# Farben für Output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funktionen
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Check: Projektname angegeben?
if [ -z "$1" ]; then
    print_error "Fehler: Projektname fehlt!"
    echo ""
    echo "Verwendung:"
    echo "  ./new-saas-project.sh <projekt-name>"
    echo ""
    echo "Beispiel:"
    echo "  ./new-saas-project.sh my-invoice-app"
    exit 1
fi

PROJECT_NAME=$1
TEMPLATE_DIR="$HOME/Documents/Freelance/setup-guides/templates/next-saas-starter"
TARGET_DIR="$HOME/Documents/Freelance/setup-guides/projects/$PROJECT_NAME"

# Check: Template existiert?
if [ ! -d "$TEMPLATE_DIR" ]; then
    print_error "Template nicht gefunden: $TEMPLATE_DIR"
    print_info "Führe zuerst das Setup aus, um das Template zu klonen."
    exit 1
fi

# Check: Projekt existiert bereits?
if [ -d "$TARGET_DIR" ]; then
    print_error "Projekt existiert bereits: $TARGET_DIR"
    exit 1
fi

# Start
echo ""
print_info "Erstelle neues Projekt: $PROJECT_NAME"
echo ""

# 1. Template kopieren
print_info "Kopiere Template..."
cp -R "$TEMPLATE_DIR" "$TARGET_DIR"
print_success "Template kopiert"

# 2. Git-Verzeichnis entfernen (neues Projekt = neues Repo)
print_info "Entferne alte Git-Historie..."
rm -rf "$TARGET_DIR/.git"
print_success "Git-Historie entfernt"

# 3. .env.example zu .env kopieren
print_info "Erstelle .env Datei..."
cp "$TARGET_DIR/.env.example" "$TARGET_DIR/.env"
print_success ".env erstellt"

# 3.5. .node-version Datei erstellen (für Nixpacks/Dokploy)
print_info "Erstelle .node-version Datei..."
echo "20" > "$TARGET_DIR/.node-version"
print_success ".node-version erstellt"

# 3.6. pnpm-lock.yaml entfernen (wir nutzen npm)
print_info "Entferne pnpm-lock.yaml..."
rm -f "$TARGET_DIR/pnpm-lock.yaml"
print_success "pnpm-lock.yaml entfernt"

# 4. CLAUDE.md mit Projektnamen anpassen
print_info "Passe CLAUDE.md an..."
sed -i '' "s/\[PROJEKT-NAME\]/$PROJECT_NAME/g" "$TARGET_DIR/CLAUDE.md"
print_success "CLAUDE.md aktualisiert"

# 5. package.json name aktualisieren
print_info "Aktualisiere package.json..."
if command -v jq &> /dev/null; then
    jq ".name = \"$PROJECT_NAME\"" "$TARGET_DIR/package.json" > "$TARGET_DIR/package.json.tmp"
    mv "$TARGET_DIR/package.json.tmp" "$TARGET_DIR/package.json"
    print_success "package.json aktualisiert"
else
    print_warning "jq nicht installiert, package.json nicht automatisch aktualisiert"
fi

# 6. Git initialisieren
print_info "Initialisiere Git Repository..."
cd "$TARGET_DIR"
git init
git add .
git commit -m "Initial commit from next-saas-starter template

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
print_success "Git Repository initialisiert"

# Fertig!
echo ""
print_success "Projekt erfolgreich erstellt!"
echo ""
print_info "Nächste Schritte:"
echo ""
echo "  1. Zum Projekt wechseln:"
echo "     ${BLUE}cd $TARGET_DIR${NC}"
echo ""
echo "  2. CLAUDE.md öffnen und Platzhalter ausfüllen:"
echo "     ${BLUE}code CLAUDE.md${NC}"
echo ""
echo "  3. Dependencies installieren:"
echo "     ${BLUE}npm install${NC}"
echo ""
echo "  4. PostgreSQL Container in Dokploy erstellen (siehe CLAUDE.md)"
echo ""
echo "  5. .env konfigurieren (DB Connection String, Stripe Keys)"
echo ""
echo "  6. Stripe CLI einrichten:"
echo "     ${BLUE}stripe login${NC}"
echo ""
echo "  7. Datenbank Setup:"
echo "     ${BLUE}npm run db:setup${NC}"
echo "     ${BLUE}npm run db:migrate${NC}"
echo "     ${BLUE}npm run db:seed${NC}"
echo ""
echo "  8. Dev-Server starten:"
echo "     ${BLUE}npm run dev${NC}"
echo ""
print_info "CLAUDE.md enthält alle Details zum Stack und Workflow."
echo ""
