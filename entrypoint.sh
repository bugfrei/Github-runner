#!/bin/bash

# Abbrechen bei Fehler
set -e

# Optional: Token und Repo-URL aus Umgebungsvariablen
REPO_URL=${REPO_URL:-"https://github.com/DEIN_ORG/DEIN_REPO"}

# Prüfe, ob der Runner bereits konfiguriert ist
if [ ! -f .runner ]; then
    echo "🔧 Konfiguriere neuen GitHub Runner..."

    if [ -z "$RUNNER_TOKEN" ]; then
        echo "❌ RUNNER_TOKEN fehlt. Abbruch."
        exit 1
    fi

    # Automatische Konfiguration
    # ./config.sh --url "$REPO_URL" --token "$RUNNER_TOKEN" --unattended --replace
    ./config.sh --url "$REPO_URL" --token "$RUNNER_TOKEN"
else
    echo "✅ Runner ist bereits konfiguriert. Starte direkt."
fi

# Starte den Runner
exec ./run.sh

