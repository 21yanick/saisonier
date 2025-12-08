#!/bin/bash
# Saisonier - Quick Run Script
# Startet automatisch den Android Emulator und die App
#
# Usage:
#   ./run.sh          → Lokale DB (localhost:8091)
#   ./run.sh --live   → Live DB (saisonier-api.21home.ch)

set -e

# Config
EMULATOR_NAME="${SAISONIER_EMULATOR:-Pixel_8_Pro}"
ADB="$HOME/Android/Sdk/platform-tools/adb"
EMULATOR="$HOME/Android/Sdk/emulator/emulator"
LIVE_URL="https://saisonier-api.21home.ch"

# Farben für Output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

start_emulator() {
    if $ADB devices | grep -q "emulator"; then
        echo -e "${GREEN}✓ Emulator läuft bereits${NC}"
        return 0
    fi

    echo -e "${YELLOW}→ Starte Emulator: $EMULATOR_NAME${NC}"
    # -gpu swiftshader_indirect = Software-Rendering (stabiler auf manchen Systemen)
    # Alternativ: -gpu host (Hardware), -gpu angle_indirect (ANGLE)
    $EMULATOR -avd "$EMULATOR_NAME" -no-snapshot-load -gpu swiftshader_indirect &

    echo -e "${YELLOW}→ Warte auf Emulator-Boot...${NC}"
    $ADB wait-for-device

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
if [ "$1" = "--live" ] || [ "$1" = "-l" ]; then
    echo -e "${CYAN}→ Verbinde mit LIVE DB: $LIVE_URL${NC}"
    flutter run -d emulator-5554 --dart-define=PB_URL="$LIVE_URL"
else
    echo -e "${YELLOW}→ Verwende lokale DB (localhost:8091)${NC}"
    flutter run -d emulator-5554
fi
