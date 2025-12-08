// ignore_for_file: avoid_print, depend_on_referenced_packages
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Sicheres Script zum Hinzufügen der shopping_list_items Collection
/// Löscht KEINE bestehenden Daten!
///
/// Verwendung:
///   cd tool && dart run add_shopping_collection.dart                    # Lokal
///   cd tool && PB_URL=https://saisonier-api.21home.ch dart run add_shopping_collection.dart  # Live

Future<void> main() async {
  final baseUrl = Platform.environment['PB_URL'] ?? 'http://127.0.0.1:8091';
  final adminEmail = Platform.environment['PB_EMAIL'] ?? 'admin@saisonier.ch';
  final adminPass = Platform.environment['PB_PASS'] ?? 'saisonier123';

  print('🛒 Shopping List Collection Setup');
  print('   Server: $baseUrl');
  print('');

  // 1. Authenticate as Admin
  String? token;
  try {
    final authRes = await http.post(
      Uri.parse('$baseUrl/api/collections/_superusers/auth-with-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'identity': adminEmail, 'password': adminPass}),
    );

    if (authRes.statusCode != 200) {
      print('❌ Auth fehlgeschlagen: ${authRes.body}');
      exit(1);
    }
    token = jsonDecode(authRes.body)['token'];
    print('✅ Authentifiziert als Admin');
  } catch (e) {
    print('❌ Verbindung fehlgeschlagen: $e');
    exit(1);
  }

  final headers = {
    'Authorization': token!,
    'Content-Type': 'application/json',
  };

  // 2. Check if collection already exists
  print('');
  print('📦 Prüfe ob Collection existiert...');

  final checkRes = await http.get(
    Uri.parse('$baseUrl/api/collections/shopping_list_items'),
    headers: headers,
  );

  if (checkRes.statusCode == 200) {
    print('✅ Collection "shopping_list_items" existiert bereits!');
    exit(0);
  }

  // 3. Get recipes collection ID for relation
  print('📦 Lade Recipes Collection ID...');
  String? recipesCollectionId;

  final recipesRes = await http.get(
    Uri.parse('$baseUrl/api/collections/recipes'),
    headers: headers,
  );

  if (recipesRes.statusCode == 200) {
    recipesCollectionId = jsonDecode(recipesRes.body)['id'];
    print('   Recipes ID: $recipesCollectionId');
  } else {
    print('⚠️  Recipes Collection nicht gefunden, source_recipe_id wird ohne Relation erstellt');
  }

  // 4. Create collection
  print('');
  print('🔨 Erstelle Collection "shopping_list_items"...');

  final fields = [
    {"name": "user_id", "type": "relation", "required": true, "collectionId": "_pb_users_auth_", "cascadeDelete": true, "maxSelect": 1},
    {"name": "item", "type": "text", "required": true},
    {"name": "amount", "type": "number", "required": false},
    {"name": "unit", "type": "text", "required": false},
    {"name": "note", "type": "text", "required": false},
    {"name": "is_checked", "type": "bool", "required": false},
  ];

  // Add source_recipe_id with or without relation
  if (recipesCollectionId != null) {
    fields.add({
      "name": "source_recipe_id",
      "type": "relation",
      "required": false,
      "collectionId": recipesCollectionId,
      "cascadeDelete": false,
      "maxSelect": 1
    });
  } else {
    fields.add({
      "name": "source_recipe_id",
      "type": "text",
      "required": false
    });
  }

  final createRes = await http.post(
    Uri.parse('$baseUrl/api/collections'),
    headers: headers,
    body: jsonEncode({
      "name": "shopping_list_items",
      "type": "base",
      "fields": fields,
      "listRule": "@request.auth.id = user_id.id",
      "viewRule": "@request.auth.id = user_id.id",
      "createRule": "@request.auth.id != ''",
      "updateRule": "@request.auth.id = user_id.id",
      "deleteRule": "@request.auth.id = user_id.id"
    }),
  );

  if (createRes.statusCode == 200) {
    print('✅ Collection "shopping_list_items" erfolgreich erstellt!');
  } else {
    print('❌ Fehler beim Erstellen: ${createRes.body}');
    exit(1);
  }

  print('');
  print('🎉 Fertig!');
}
