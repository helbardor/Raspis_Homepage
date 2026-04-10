#!/bin/bash
# Skript zum Aktualisieren der Homepage und Synchronisieren mit GitHub

set -e

echo "=== Helbardor Homepage Update ==="
echo ""

# 1. Homepage von Git-Repo ins Web-Verzeichnis kopieren
echo "1. Kopiere Homepage ins Web-Verzeichnis..."
sudo cp index.html /var/www/html/
echo "   ✓ Homepage aktualisiert"

# 2. Git Status prüfen
echo ""
echo "2. Prüfe Git Status..."
git status --short

# 3. Änderungen committen
echo ""
echo "3. Committe Änderungen..."
git add .
if git diff --cached --quiet; then
    echo "   ✓ Keine Änderungen zum Committen"
else
    git commit -m "Update: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "   ✓ Änderungen committed"
fi

# 4. Prüfe ob Remote konfiguriert ist
echo ""
echo "4. Prüfe Remote-Konfiguration..."
if git remote | grep -q origin; then
    echo "   ✓ Remote 'origin' konfiguriert"
    echo "   ℹ️  Führe 'git push' manuell aus oder konfiguriere GitHub Token"
else
    echo "   ⚠️  Kein Remote konfiguriert"
    echo "   ℹ️  Siehe setup-github.md für GitHub Setup"
fi

# 5. Nginx neu laden
echo ""
echo "5. Lade nginx neu..."
sudo systemctl reload nginx
echo "   ✓ nginx neu geladen"

echo ""
echo "=== Fertig ==="
echo "Homepage ist unter http://192.168.178.62 erreichbar"
echo "Git Repository: ~/helbardor-homepage/"