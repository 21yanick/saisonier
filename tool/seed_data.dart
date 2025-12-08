// ignore_for_file: avoid_print, depend_on_referenced_packages, prefer_const_declarations
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> main() async {
  final baseUrl = 'http://127.0.0.1:8091';
  // Default Local Admin credentials (USER MUST CREATE THIS IN PB UI FIRST)
  // Or we can try to create it if first run? No, PB requires UI for first admin.
  final adminEmail = 'admin@saisonier.ch';
  final adminPass = 'saisonier123';

  print('Seeding data to $baseUrl...');

  // 1. Authenticate as Admin
  String? token;
  try {
    final authRes = await http.post(
      Uri.parse('$baseUrl/api/collections/_superusers/auth-with-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'identity': adminEmail,
        'password': adminPass,
      }),
    );

    if (authRes.statusCode != 200) {
      print('Auth failed: ${authRes.body}');
      print('Please create admin account: $adminEmail / $adminPass via http://127.0.0.1:8091/_/');
      exit(1);
    }
    token = jsonDecode(authRes.body)['token'];
    print('Authenticated!');
  } catch (e) {
    print('Connection failed. Is Pocketbase running? $e');
    exit(1);
  }

  final headers = {
    'Authorization': token!,
    'Content-Type': 'application/json',
  };

  // 1.5 Clean up/Break relations before reset
  print('Cleaning up relations...');
  try {
     final uRes = await http.get(Uri.parse('$baseUrl/api/collections/users'), headers: headers);
     if (uRes.statusCode == 200) {
       final uData = jsonDecode(uRes.body);
       final List<dynamic> fields = uData['fields'];
       final initialLen = fields.length;
       fields.removeWhere((f) => f['name'] == 'favorites');

       if (fields.length < initialLen) {
         print('Removing "favorites" from users to allow clean reset...');
         await http.patch(
            Uri.parse('$baseUrl/api/collections/users'),
            headers: headers,
            body: jsonEncode({"fields": fields})
         );
       }
     }
  } catch(e) {
    print('Cleanup warning: $e');
  }

  print('Resetting "vegetables" collection...');
  try {
    // Delete recipes first because it relates to vegetables
    await http.delete(
      Uri.parse('$baseUrl/api/collections/recipes'),
      headers: headers,
    );
    // Try delete (ignore 404)
    await http.delete(
      Uri.parse('$baseUrl/api/collections/vegetables'),
      headers: headers,
    );
  } catch (_) {}

  print('Creating collection "vegetables"...');
  final createRes = await http.post(
    Uri.parse('$baseUrl/api/collections'),
    headers: headers,
    body: jsonEncode({
      "name": "vegetables",
      "type": "base",
      "fields": [
        {"name": "name", "type": "text", "required": true, "presentable": true},
        {"name": "type", "type": "select", "maxSelect": 1, "values": ["vegetable", "fruit", "herb", "nut", "salad", "mushroom", "meat"]},
        {"name": "image", "type": "file", "maxSelect": 1, "maxSize": 5242880, "mimeTypes": ["image/png","image/jpeg","image/jpg","image/webp"]},
        {"name": "months", "type": "json", "required": false},
        {"name": "hex_color", "type": "text", "required": false},
        {"name": "description", "type": "text", "required": false},
        {"name": "tier", "type": "number", "required": false}
      ],
      "listRule": "", // Public
      "viewRule": ""  // Public
    }),
  );

  if (createRes.statusCode != 200) {
    print('Failed to create collection: ${createRes.body}');
    // Fallback for older PB versions that use "schema" instead of "fields"
    print('Retrying with legacy "schema" format...');
    final createLegacyRes = await http.post(
        Uri.parse('$baseUrl/api/collections'),
        headers: headers,
        body: jsonEncode({
          "name": "vegetables",
          "type": "base",
          "schema": [
            {"name": "name", "type": "text", "required": true},
            {"name": "type", "type": "select", "options": {"values": ["vegetable", "fruit", "herb", "nut", "salad", "mushroom"]}},
            {"name": "image", "type": "file", "options": {"maxSelect": 1, "maxSize": 5242880, "mimeTypes": ["image/png","image/jpeg","image/jpg","image/webp"]}},
            {"name": "months", "type": "json"},
            {"name": "hex_color", "type": "text"},
            {"name": "description", "type": "text"},
            {"name": "tier", "type": "number"}
          ],
           "listRule": "", // Public
           "viewRule": ""  // Public
        }),
    );
     if (createLegacyRes.statusCode != 200) {
        print('Failed to create collection (legacy): ${createLegacyRes.body}');
        exit(1);
     }
  } else {
    print('Collection "vegetables" created successfully (Fields format)!');
  }

  // Fetch vegetables collection ID for relation
  String? vegCollectionId;
  try {
     final vRes = await http.get(Uri.parse('$baseUrl/api/collections/vegetables'), headers: headers);
     if (vRes.statusCode == 200) {
       vegCollectionId = jsonDecode(vRes.body)['id'];
     }
  } catch(e) {
    print('Failed to get vegetables id: $e');
  }

  if (vegCollectionId == null) {
    print('Cannot create recipes collection: vegetables collection ID not found.');
    exit(1);
  }

  // --- Collection: recipes ---
  print('Ensuring collection "recipes"...');
  try {
    // Check if exists
    await http.get(Uri.parse('$baseUrl/api/collections/recipes'), headers: headers);
  } catch (_) {
    // 404 likely, so create
  }

  // Create recipes (supports both curated and user recipes)
  final createRecipesRes = await http.post(
    Uri.parse('$baseUrl/api/collections'),
    headers: headers,
    body: jsonEncode({
      "name": "recipes",
      "type": "base",
      "fields": [
        // Basis
        {"name": "title", "type": "text", "required": true, "presentable": true},
        {"name": "description", "type": "text", "required": false},
        {"name": "image", "type": "file", "maxSelect": 1, "maxSize": 5242880, "mimeTypes": ["image/png","image/jpeg","image/jpg","image/webp"]},
        // Zeiten (getrennt)
        {"name": "prep_time_min", "type": "number", "required": false},
        {"name": "cook_time_min", "type": "number", "required": false},
        // Portionen & Schwierigkeit
        {"name": "servings", "type": "number", "required": false, "min": 1},
        {"name": "difficulty", "type": "select", "required": false, "maxSelect": 1, "values": ["easy", "medium", "hard"]},
        {"name": "category", "type": "select", "required": false, "maxSelect": 1, "values": ["main", "side", "dessert", "snack", "breakfast", "soup", "salad"]},
        // Inhalte
        {"name": "ingredients", "type": "json", "required": false},
        {"name": "steps", "type": "json", "required": false},
        {"name": "tags", "type": "json", "required": false},
        // Beziehungen
        {"name": "vegetable_id", "type": "relation", "required": false, "collectionId": vegCollectionId, "cascadeDelete": false, "maxSelect": 1},
        // Ownership
        {"name": "source", "type": "select", "required": true, "maxSelect": 1, "values": ["curated", "user"]},
        {"name": "user_id", "type": "relation", "required": false, "collectionId": "_pb_users_auth_", "cascadeDelete": true, "maxSelect": 1},
        {"name": "is_public", "type": "bool", "required": false},
        // Ernährung
        {"name": "is_vegetarian", "type": "bool", "required": false},
        {"name": "is_vegan", "type": "bool", "required": false},
        // Allergene
        {"name": "contains_gluten", "type": "bool", "required": false},
        {"name": "contains_lactose", "type": "bool", "required": false},
        {"name": "contains_nuts", "type": "bool", "required": false},
        {"name": "contains_eggs", "type": "bool", "required": false},
        {"name": "contains_soy", "type": "bool", "required": false},
        {"name": "contains_fish", "type": "bool", "required": false},
        {"name": "contains_shellfish", "type": "bool", "required": false}
      ],
      // Curated: public | User: owner-only or public if is_public=true
      "listRule": "source = 'curated' || user_id = @request.auth.id || (is_public = true && user_id != '')",
      "viewRule": "source = 'curated' || user_id = @request.auth.id || (is_public = true && user_id != '')",
      "createRule": "@request.auth.id != ''",
      "updateRule": "source = 'curated' || user_id = @request.auth.id",
      "deleteRule": "user_id = @request.auth.id"
    }),
  );
  if (createRecipesRes.statusCode == 200) {
    print('Collection "recipes" created successfully!');
  } else {
     // If it failed, it might already exist or error. Print but don't crash script.
     print('Note on "recipes": ${createRecipesRes.body}');
  }

  String? recipesCollectionId;
  try {
     final rRes = await http.get(Uri.parse('$baseUrl/api/collections/recipes'), headers: headers);
     if (rRes.statusCode == 200) {
       recipesCollectionId = jsonDecode(rRes.body)['id'];
     }
  } catch(e) {
    print('Failed to get recipes id: $e');
  }

  // --- Collection: user_profiles ---
  print('Ensuring collection "user_profiles"...');
  try {
    await http.get(Uri.parse('$baseUrl/api/collections/user_profiles'), headers: headers);
  } catch (_) {
    // 404 likely
  }

  // Create user_profiles
  final createProfilesRes = await http.post(
    Uri.parse('$baseUrl/api/collections'),
    headers: headers,
    body: jsonEncode({
      "name": "user_profiles",
      "type": "base",
      "fields": [
        {"name": "user_id", "type": "relation", "required": true, "collectionId": "_pb_users_auth_", "cascadeDelete": true, "maxSelect": 1},
        {"name": "household_size", "type": "number", "required": true, "min": 1},
        {"name": "children_count", "type": "number", "required": true, "min": 0},
        {"name": "children_ages", "type": "json", "required": false},
        {"name": "allergens", "type": "json", "required": false},
        {"name": "diet", "type": "text", "required": true},
        {"name": "dislikes", "type": "json", "required": false},
        {"name": "skill", "type": "text", "required": true},
        {"name": "max_cooking_time_min", "type": "number", "required": true},
        {"name": "bring_email", "type": "email", "required": false},
        {"name": "bring_list_uuid", "type": "text", "required": false}
      ],
      "listRule": "@request.auth.id = user_id.id",
      "viewRule": "@request.auth.id = user_id.id",
      "createRule": "@request.auth.id != ''",
      "updateRule": "@request.auth.id = user_id.id",
      "deleteRule": "@request.auth.id = user_id.id"
    }),
  );

  if (createProfilesRes.statusCode == 200) {
    print('Collection "user_profiles" created successfully!');
  } else {
    print('Note on "user_profiles": ${createProfilesRes.body}');
    // Check if it failed because it exists, strict checking would be better but this aligns with existing script style
  }

  // --- Collection: planned_meals (Phase 12) ---
  print('Ensuring collection "planned_meals"...');
  try {
    await http.get(Uri.parse('$baseUrl/api/collections/planned_meals'), headers: headers);
  } catch (_) {
    // 404 likely
  }

  final createPlannedMealsRes = await http.post(
    Uri.parse('$baseUrl/api/collections'),
    headers: headers,
    body: jsonEncode({
      "name": "planned_meals",
      "type": "base",
      "fields": [
        {"name": "user_id", "type": "relation", "required": true, "collectionId": "_pb_users_auth_", "cascadeDelete": true, "maxSelect": 1},
        {"name": "date", "type": "date", "required": true},
        {"name": "slot", "type": "select", "required": true, "maxSelect": 1, "values": ["breakfast", "lunch", "dinner"]},
        {"name": "recipe_id", "type": "relation", "required": false, "collectionId": recipesCollectionId, "cascadeDelete": false, "maxSelect": 1},
        {"name": "custom_title", "type": "text", "required": false},
        {"name": "servings", "type": "number", "required": true, "min": 1}
      ],
      // Owner only rules
      "listRule": "@request.auth.id = user_id.id",
      "viewRule": "@request.auth.id = user_id.id",
      "createRule": "@request.auth.id != ''",
      "updateRule": "@request.auth.id = user_id.id",
      "deleteRule": "@request.auth.id = user_id.id"
    }),
  );

  if (createPlannedMealsRes.statusCode == 200) {
    print('Collection "planned_meals" created successfully!');
  } else {
    print('Note on "planned_meals": ${createPlannedMealsRes.body}');
  }

  // --- Collection: users (Update) ---
  print('Updating "users" schema...');
  try {
    // 1. Get current users collection
    final usersRes = await http.get(
      Uri.parse('$baseUrl/api/collections/users'),
      headers: headers,
    );

    if (usersRes.statusCode == 200) {
      final usersData = jsonDecode(usersRes.body);
      final List<dynamic> fields = usersData['fields'];

      // Check if favorites already exists
      bool hasFavorites = false;
      for (final f in fields) {
        if (f['name'] == 'favorites') {
          hasFavorites = true;
          break;
        }
      }

      if (!hasFavorites) {
        // Add favorites relation
        // Depending on PB version, we might need to send ALL fields back.
        // We will append to the existing fields list.
        fields.add({
           "name": "favorites",
           "type": "relation",
           "collectionId": recipesCollectionId,
           "cascadeDelete": false,
           "maxSelect": null, // Multiple
           "displayFields": []
        });

        // Update collection
        final updateRes = await http.patch(
          Uri.parse('$baseUrl/api/collections/users'),
          headers: headers,
          body: jsonEncode({
            "fields": fields,
          }),
        );

        if (updateRes.statusCode == 200) {
           print('Users collection updated with "favorites" field.');
        } else {
           print('Failed to update users collection: ${updateRes.body}');
        }
      } else {
        print('"favorites" field already exists in users.');
      }
    }
  } catch (e) {
      print('Error accessing users: $e');
  }

  // 3. Import Data
  final file = File('vegetables_ch.json');
  final jsonContent = await file.readAsString();
  final List<dynamic> data = jsonDecode(jsonContent);

  // Check if we already have vegetable data
  final listRes = await http.get(
    Uri.http('127.0.0.1:8091', '/api/collections/vegetables/records', {'perPage': '1'}),
    headers: headers,
  );

  bool skipVegSeeding = false;
  if (listRes.statusCode == 200) {
    if ((jsonDecode(listRes.body)['totalItems'] ?? 0) > 0) {
      print('Vegetables collection already has data. Skipping vegetable seed.');
      skipVegSeeding = true;
    }
  }

  if (!skipVegSeeding) {
    int count = 0;
    for (final item in data) {
      final name = item['name'];
      print('Importing $name...');

      // Tier aus JSON übernehmen, falls vorhanden (vegetables_ch.json hat tier)
      // Fallback auf 3 wenn nicht definiert
      int tier = item['tier'] ?? 3;

      final body = {
        "name": name,
        "type": item['type'],
        "months": item['months'],
        "hex_color": item['hex_color'],
        "description": item['description'],
        "tier": tier,
      };

      final createRes = await http.post(
        Uri.parse('$baseUrl/api/collections/vegetables/records'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (createRes.statusCode != 200) {
        print('Failed to import $name: ${createRes.body}');
      } else {
        count++;
      }
    }
    print('Imported $count vegetables.');
  }

  // --- Rezepte werden separat geseeded ---
  print('');
  print('Hinweis: Rezepte werden separat geseeded.');
  print('Führe aus: cd tool && dart run recipe_seed.dart');
  print('');

  print('Seeding complete.');
}
