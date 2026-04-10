#!/bin/bash
# Skript zum Aktualisieren der Homepage und Synchronisieren mit GitHub

set -e

echo "=== Helbardor Homepage Update ==="
echo ""

# 1. Homepage von Git-Repo ins Web-Verzeichnis kopieren
echo "1. Kopiere Homepage ins Web-Verzeichnis..."
sudo cp index.html /var/www/html/
echo "   ✓ Homepage aktualisiert"

# 2. Website Monitoring Status prüfen (optional)
echo ""
echo "2. Prüfe Website-Status..."
echo "   • OpenClaw (localhost:18789): $(timeout 3 curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:18789/ 2>/dev/null || echo 'offline')"
echo "   • Fewo Amertens: $(timeout 5 curl -s -o /dev/null -w '%{http_code}' https://fewo.amertens.me/ 2>/dev/null || echo 'offline')"
echo "   • Oasendergesundheit: $(timeout 5 curl -s -o /dev/null -w '%{http_code}' https://oasendergesundheit.de/ 2>/dev/null || echo 'offline')"

# 3. Git Status prüfen
echo ""
echo "3. Prüfe Git Status..."
git status --short

# 4. Änderungen committen
echo ""
echo "4. Committe Änderungen..."
git add .
if git diff --cached --quiet; then
    echo "   ✓ Keine Änderungen zum Committen"
else
    git commit -m "Update: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "   ✓ Änderungen committed"
fi

# 5. Zu GitHub pushen
echo ""
echo "5. Synchronisiere mit GitHub..."
if git remote | grep -q origin; then
    git push origin main
    echo "   ✓ Zu GitHub gepusht"
else
    echo "   ⚠️  Kein Remote konfiguriert"
    echo "   ℹ️  Repository: git@github.com:helbardor/Raspis_Homepage.git"
fi

# 6. Nginx neu laden
echo ""
echo "6. Lade nginx neu..."
sudo systemctl reload nginx
echo "   ✓ nginx neu geladen"

echo ""
echo "=== Fertig ==="
echo "Homepage ist unter http://192.168.178.62 erreichbar"
echo "Git Repository: $(pwd)"
echo "GitHub: https://github.com/helbardor/Raspis_Homepage"
echo ""
echo "Überwachte Websites:"
echo "  • OpenClaw: http://127.0.0.1:18789/"
echo "  • Fewo Amertens: https://fewo.amertens.me/"
echo "  • Oasendergesundheit: https://oasendergesundheit.de/"
echo ""
echo "Monitoring: Alle 60 Sekunden automatische Prüfung"
echo "Manuelle Prüfung: 'Jetzt prüfen' Button auf der Homepage"