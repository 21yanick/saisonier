#!/bin/bash
# Setup AI Collections in PocketBase v0.23+
# Uses "fields" instead of "schema"

set -e

POCKETBASE_URL="${1:-http://localhost:8091}"
ADMIN_EMAIL="${2}"
ADMIN_PASSWORD="${3}"

echo "=== Saisonier AI Collections Setup ==="
echo "PocketBase URL: $POCKETBASE_URL"

if [ -z "$ADMIN_EMAIL" ] || [ -z "$ADMIN_PASSWORD" ]; then
    echo ""
    echo "Usage: ./setup_ai_collections.sh [URL] [EMAIL] [PASSWORD]"
    exit 1
fi

# Authenticate
echo ""
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

# ============================================
# ai_profiles Collection
# ============================================
echo ""
echo "2. Creating ai_profiles..."

RESPONSE=$(curl -s -X POST "$POCKETBASE_URL/api/collections" \
    -H "Content-Type: application/json" \
    -H "Authorization: $TOKEN" \
    -d '{
  "name": "ai_profiles",
  "type": "base",
  "fields": [
    {
      "name": "user_id",
      "type": "relation",
      "required": true,
      "collectionId": "_pb_users_auth_",
      "cascadeDelete": true,
      "maxSelect": 1
    },
    {
      "name": "cuisine_preferences",
      "type": "json",
      "required": false,
      "maxSize": 0
    },
    {
      "name": "flavor_profile",
      "type": "json",
      "required": false,
      "maxSize": 0
    },
    {
      "name": "likes",
      "type": "json",
      "required": false,
      "maxSize": 0
    },
    {
      "name": "protein_preferences",
      "type": "json",
      "required": false,
      "maxSize": 0
    },
    {
      "name": "budget_level",
      "type": "select",
      "required": false,
      "maxSelect": 1,
      "values": ["budget", "normal", "premium"]
    },
    {
      "name": "meal_prep_style",
      "type": "select",
      "required": false,
      "maxSelect": 1,
      "values": ["daily", "mealPrep", "mixed"]
    },
    {
      "name": "cooking_days_per_week",
      "type": "number",
      "required": false,
      "min": 1,
      "max": 7
    },
    {
      "name": "health_goals",
      "type": "json",
      "required": false,
      "maxSize": 0
    },
    {
      "name": "nutrition_focus",
      "type": "select",
      "required": false,
      "maxSelect": 1,
      "values": ["highProtein", "lowCarb", "balanced"]
    },
    {
      "name": "equipment",
      "type": "json",
      "required": false,
      "maxSize": 0
    },
    {
      "name": "learning_context",
      "type": "json",
      "required": false,
      "maxSize": 0
    },
    {
      "name": "onboarding_completed",
      "type": "bool",
      "required": false
    }
  ]
}')

PROFILE_ID=$(echo "$RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin).get('id',''))" 2>/dev/null)

if [ -n "$PROFILE_ID" ]; then
    echo "   Created! (ID: $PROFILE_ID)"

    echo "   Setting rules..."
    curl -s -X PATCH "$POCKETBASE_URL/api/collections/$PROFILE_ID" \
        -H "Content-Type: application/json" \
        -H "Authorization: $TOKEN" \
        -d '{
      "listRule": "@request.auth.id = user_id",
      "viewRule": "@request.auth.id = user_id",
      "createRule": "@request.auth.id != \"\"",
      "updateRule": "@request.auth.id = user_id",
      "deleteRule": "@request.auth.id = user_id"
    }' > /dev/null
    echo "   ai_profiles ready!"
else
    echo "   ERROR: $RESPONSE"
fi

# ============================================
# ai_requests Collection
# ============================================
echo ""
echo "3. Creating ai_requests..."

RESPONSE=$(curl -s -X POST "$POCKETBASE_URL/api/collections" \
    -H "Content-Type: application/json" \
    -H "Authorization: $TOKEN" \
    -d '{
  "name": "ai_requests",
  "type": "base",
  "fields": [
    {
      "name": "user_id",
      "type": "relation",
      "required": true,
      "collectionId": "_pb_users_auth_",
      "cascadeDelete": false,
      "maxSelect": 1
    },
    {
      "name": "request_type",
      "type": "select",
      "required": true,
      "maxSelect": 1,
      "values": ["recipe_gen", "weekplan_gen", "image_gen"]
    },
    {
      "name": "prompt_hash",
      "type": "text",
      "required": false
    },
    {
      "name": "tokens_used",
      "type": "number",
      "required": false,
      "min": 0
    },
    {
      "name": "response_data",
      "type": "json",
      "required": false,
      "maxSize": 0
    },
    {
      "name": "success",
      "type": "bool",
      "required": false
    },
    {
      "name": "error_message",
      "type": "text",
      "required": false
    }
  ]
}')

REQUEST_ID=$(echo "$RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin).get('id',''))" 2>/dev/null)

if [ -n "$REQUEST_ID" ]; then
    echo "   Created! (ID: $REQUEST_ID)"

    echo "   Setting rules..."
    curl -s -X PATCH "$POCKETBASE_URL/api/collections/$REQUEST_ID" \
        -H "Content-Type: application/json" \
        -H "Authorization: $TOKEN" \
        -d '{
      "listRule": "@request.auth.id = user_id",
      "viewRule": "@request.auth.id = user_id"
    }' > /dev/null
    echo "   ai_requests ready!"
else
    echo "   ERROR: $RESPONSE"
fi

echo ""
echo "=== Done! ==="
