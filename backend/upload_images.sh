#!/bin/bash
# Lädt komprimierte Bilder zu PocketBase hoch
# Matcht Dateinamen mit Vegetable-Namen in der DB

BASE_URL="https://saisonier-api.21home.ch"
EMAIL="admin@saisonier.ch"
PASS="saisonier123"
IMG_DIR="seed_images_compressed"

echo "=== PocketBase Image Upload ==="
echo "Server: $BASE_URL"
echo "Bilder: $IMG_DIR"
echo ""

# 1. Authentifizieren
echo "Authentifiziere..."
AUTH_RESPONSE=$(curl -s -X POST "$BASE_URL/api/collections/_superusers/auth-with-password" \
    -H "Content-Type: application/json" \
    -d "{\"identity\":\"$EMAIL\",\"password\":\"$PASS\"}")

TOKEN=$(echo "$AUTH_RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin).get('token',''))" 2>/dev/null)

if [ -z "$TOKEN" ]; then
    echo "FEHLER: Auth fehlgeschlagen!"
    echo "$AUTH_RESPONSE"
    exit 1
fi
echo "OK - Token erhalten"
echo ""

# 2. Alle Vegetables holen
echo "Lade Vegetables aus DB..."
VEGETABLES=$(curl -s "$BASE_URL/api/collections/vegetables/records?perPage=500" \
    -H "Authorization: $TOKEN")

TOTAL=$(echo "$VEGETABLES" | python3 -c "import sys,json; print(json.load(sys.stdin).get('totalItems',0))" 2>/dev/null)
echo "Gefunden: $TOTAL Vegetables"
echo ""

# 3. Für jedes Bild uploaden
echo "=== Starte Upload ==="
shopt -s nullglob

success=0
skipped=0
failed=0

for img in "$IMG_DIR"/*.webp; do
    filename=$(basename "$img")
    name="${filename%.*}"

    # Vegetable ID finden
    veggie_id=$(echo "$VEGETABLES" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for item in data.get('items', []):
    if item.get('name') == '''$name''':
        print(item.get('id'))
        break
" 2>/dev/null)

    if [ -z "$veggie_id" ]; then
        echo "SKIP: $name (nicht in DB)"
        ((skipped++))
        continue
    fi

    # Prüfen ob schon ein Bild existiert
    existing_img=$(echo "$VEGETABLES" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for item in data.get('items', []):
    if item.get('id') == '$veggie_id':
        print(item.get('image', ''))
        break
" 2>/dev/null)

    if [ -n "$existing_img" ]; then
        echo "SKIP: $name (hat bereits Bild: $existing_img)"
        ((skipped++))
        continue
    fi

    echo -n "UPLOAD: $name -> $veggie_id ... "

    # Bild hochladen
    UPLOAD_RESPONSE=$(curl -s -X PATCH "$BASE_URL/api/collections/vegetables/records/$veggie_id" \
        -H "Authorization: $TOKEN" \
        -F "image=@$img")

    # Erfolg prüfen
    if echo "$UPLOAD_RESPONSE" | grep -q '"image"'; then
        new_img=$(echo "$UPLOAD_RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin).get('image',''))" 2>/dev/null)
        echo "OK ($new_img)"
        ((success++))
    else
        error=$(echo "$UPLOAD_RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin).get('message','Unknown error'))" 2>/dev/null)
        echo "FEHLER: $error"
        ((failed++))
    fi
done

echo ""
echo "=== Fertig! ==="
echo "Erfolgreich: $success"
echo "Übersprungen: $skipped"
echo "Fehlgeschlagen: $failed"
