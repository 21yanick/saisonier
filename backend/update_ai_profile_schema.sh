#!/bin/bash
# Update ai_profiles collection to add missing nutrition_focus values
# Run with: ./update_ai_profile_schema.sh <ADMIN_EMAIL> <ADMIN_PASSWORD>

set -e

POCKETBASE_URL="${POCKETBASE_URL:-http://localhost:8091}"
ADMIN_EMAIL="${1}"
ADMIN_PASSWORD="${2}"

echo "=== Update ai_profiles Schema ==="

if [ -z "$ADMIN_EMAIL" ] || [ -z "$ADMIN_PASSWORD" ]; then
    echo "Usage: ./update_ai_profile_schema.sh <ADMIN_EMAIL> <ADMIN_PASSWORD>"
    exit 1
fi

# Authenticate
echo "1. Authenticating..."
AUTH_RESPONSE=$(curl -s -X POST "$POCKETBASE_URL/api/collections/_superusers/auth-with-password" \
    -H "Content-Type: application/json" \
    -d "{\"identity\": \"$ADMIN_EMAIL\", \"password\": \"$ADMIN_PASSWORD\"}")

TOKEN=$(echo "$AUTH_RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin).get('token',''))" 2>/dev/null)

if [ -z "$TOKEN" ]; then
    echo "ERROR: Auth failed!"
    echo "$AUTH_RESPONSE"
    exit 1
fi
echo "   OK!"

# Get ai_profiles collection ID
echo "2. Getting ai_profiles collection..."
COLLECTION=$(curl -s -X GET "$POCKETBASE_URL/api/collections/ai_profiles" \
    -H "Authorization: $TOKEN")

COLLECTION_ID=$(echo "$COLLECTION" | python3 -c "import sys,json; print(json.load(sys.stdin).get('id',''))" 2>/dev/null)
echo "   Collection ID: $COLLECTION_ID"

if [ -z "$COLLECTION_ID" ]; then
    echo "ERROR: Could not find ai_profiles collection"
    exit 1
fi

# Get current fields and update nutrition_focus
echo "3. Updating nutrition_focus field values..."

# We need to patch the collection with updated fields
# Get current fields first
FIELDS=$(echo "$COLLECTION" | python3 -c "import sys,json; print(json.dumps(json.load(sys.stdin).get('fields',[])))" 2>/dev/null)

# Update using Python to modify the nutrition_focus field
UPDATED_FIELDS=$(echo "$FIELDS" | python3 -c "
import sys, json
fields = json.load(sys.stdin)
for field in fields:
    if field.get('name') == 'nutrition_focus':
        field['values'] = ['highProtein', 'lowCarb', 'balanced', 'vegetableFocus', 'lowSugar', 'wholesome']
print(json.dumps(fields))
")

# Patch the collection
RESPONSE=$(curl -s -X PATCH "$POCKETBASE_URL/api/collections/$COLLECTION_ID" \
    -H "Content-Type: application/json" \
    -H "Authorization: $TOKEN" \
    -d "{\"fields\": $UPDATED_FIELDS}")

if echo "$RESPONSE" | grep -q '"id"'; then
    echo "   OK! Schema updated successfully."
    echo ""
    echo "The nutrition_focus field now accepts:"
    echo "  - highProtein, lowCarb, balanced (existing)"
    echo "  - vegetableFocus, lowSugar, wholesome (new)"
else
    echo "ERROR updating schema:"
    echo "$RESPONSE"
    exit 1
fi
