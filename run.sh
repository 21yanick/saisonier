#!/bin/bash
# Saisonier - Quick Run Script
# Startet automatisch den Android Emulator und die App

set -e

# Emulator Name - überschreibbar via $SAISONIER_EMULATOR
EMULATOR_NAME="${SAISONIER_EMULATOR:-Pixel_8_Pro}"
ADB="$HOME/Android/Sdk/platform-tools/adb"
EMULATOR="$HOME/Android/Sdk/emulator/emulator"

# Farben für Output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

start_emulator() {
    # Prüfe ob Emulator bereits läuft
    if $ADB devices | grep -q "emulator"; then
        echo -e "${GREEN}✓ Emulator läuft bereits${NC}"
        return 0
    fi

    echo -e "${YELLOW}→ Starte Emulator: $EMULATOR_NAME${NC}"
    $EMULATOR -avd "$EMULATOR_NAME" -no-snapshot-load &

    echo -e "${YELLOW}→ Warte auf Emulator-Boot...${NC}"
    $ADB wait-for-device

    # Warte bis System vollständig gebootet ist
    while [ "$($ADB shell getprop sys.boot_completed 2>/dev/null)" != "1" ]; do
        sleep 1
    done
    echo -e "${GREEN}✓ Emulator bereit${NC}"
}

echo -e "${YELLOW}🚀 Saisonier Dev Runner${NC}"

# Nur Emulator starten (für VS Code Task)
if [ "$1" = "--emulator-only" ]; then
    start_emulator
    exit 0
fi

start_emulator

# Starte Flutter App
echo -e "${YELLOW}→ Starte Flutter App...${NC}"
flutter run -d emulator-5554
