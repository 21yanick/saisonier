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
        {"name": "type", "type": "select", "maxSelect": 1, "values": ["vegetable", "fruit", "herb", "nut", "salad", "mushroom"]},
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

  // Create recipes
  final createRecipesRes = await http.post(
    Uri.parse('$baseUrl/api/collections'),
    headers: headers,
    body: jsonEncode({
      "name": "recipes",
      "type": "base",
      "fields": [
        {"name": "title", "type": "text", "required": true, "presentable": true},
        {"name": "vegetable_id", "type": "relation", "required": true, "collectionId": vegCollectionId, "cascadeDelete": false, "maxSelect": 1},
        {"name": "image", "type": "file", "maxSelect": 1, "maxSize": 5242880, "mimeTypes": ["image/png","image/jpeg","image/jpg"]},
        {"name": "time_min", "type": "number", "required": false},
        {"name": "ingredients", "type": "json", "required": false},
        {"name": "steps", "type": "json", "required": false}
      ],
      "listRule": "", // Public
      "viewRule": ""  // Public
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
  final file = File('vegetables_switzerland.json');
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

  // Cache vegetable IDs for recipe seeding
  final Map<String, String> vegIdMap = {};

  if (!skipVegSeeding) {
    int count = 0;
    for (final item in data) {
      final name = item['name'];
      print('Importing $name...');
      
      // Default tier logic
      int tier = 3; 
      final n = name.toString().toLowerCase();
      if (['kartoffeln', 'karotten', 'äpfel', 'tomaten', 'nüsslisalat', 'erdbeeren'].contains(n)) {
        tier = 1;
      } else if (['zwiebeln', 'knoblauch', 'broccoli', 'peperoni'].contains(n)) {
        tier = 2;
      }

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
        // Store ID
        final vData = jsonDecode(createRes.body);
        vegIdMap[name] = vData['id'];
      }
    }
    print('Imported $count vegetables.');
  }

  // Refetch all vegetables to populate map if we skipped seeding or missed some
  if (vegIdMap.isEmpty || skipVegSeeding) {
     print('Fetching existing vegetable IDs for recipes...');
     // Max 500 for now
     final allVeg = await http.get(
        Uri.http('127.0.0.1:8091', '/api/collections/vegetables/records', {'perPage': '500'}),
        headers: headers,
     );
     if (allVeg.statusCode == 200) {
       final items = jsonDecode(allVeg.body)['items'] as List;
       for (final i in items) {
         vegIdMap[i['name']] = i['id'];
       }
     }
  }

  // --- Seed Recipes ---
  print('Seeding Recipes...');
  
  // Sample Recipes
  final recipes = [
    {
      "vegetable": "Kartoffeln",
      "title": "Klassische Berner Rösti",
      "time_min": 45,
      "ingredients": [
        {"item": "Festkochende Kartoffeln", "amount": "1kg"},
        {"item": "Butter", "amount": "2 EL"},
        {"item": "Salz", "amount": "1 TL"}
      ],
      "steps": [
        "Kartoffeln am Vortag weich kochen (Gschwellti).",
        "Schälen und an der Röstiraffel reiben.",
        "Butter in Bratpfanne heiss werden lassen.",
        "Kartoffeln beigeben, salzen und unter gelegentlichem Wenden anbraten.",
        "Zu einem Kuchen formen und 15-20 Min. goldgelb braten."
      ]
    },
    {
      "vegetable": "Karotten",
      "title": "Aargauer Rüeblisuppe",
      "time_min": 30,
      "ingredients": [
        {"item": "Rüebli", "amount": "600g"},
        {"item": "Zwiebel", "amount": "1"},
        {"item": "Gemüsebouillon", "amount": "1L"},
        {"item": "Rahm", "amount": "1dl"}
      ],
      "steps": [
        "Rüebli schälen und in Scheiben schneiden.",
        "Zwiebel hacken und andünsten.",
        "Rüebli beigeben und kurz mitdünsten.",
        "Mit Bouillon ablöschen und 20 Min. köcheln.",
        "Pürieren und Rahm beigeben."
      ]
    },
    {
      "vegetable": "Äpfel",
      "title": "Grossmutter's Apfelwähe",
      "time_min": 60,
      "ingredients": [
        {"item": "Kuchenteig", "amount": "1 runde Form"},
        {"item": "Äpfel", "amount": "4 grosse"},
        {"item": "Guss (Milch/Ei)", "amount": "2dl"},
        {"item": "Zucker/Zimt", "amount": "nach Belieben"}
      ],
      "steps": [
        "Teig in Form legen und einstechen.",
        "Äpfel in Schnitze schneiden und dachziegelartig belegen.",
        "Guss darübergiessen.",
        "Bei 200 Grad ca. 35-40 Min backen."
      ]
    }
  ];

  for (final r in recipes) {
    final vegName = r['vegetable'];
    final vegId = vegIdMap[vegName]; // We hope names match exactly with seeded data
    
    if (vegId == null) {
      print('Skipping recipe ${r['title']}: Vegetable $vegName not found.');
      continue;
    }

    // Check if exists
    // Simple check by title to avoid dupes
    // Pocketbase filter syntax
    final existsRes = await http.get(
      Uri.http('127.0.0.1:8091', '/api/collections/recipes/records', {
        'filter': 'title="${r['title']}"' 
      }),
      headers: headers
    );
    
    if (existsRes.statusCode == 200 && (jsonDecode(existsRes.body)['totalItems'] ?? 0) > 0) {
      print('Recipe "${r['title']}" already exists.');
      continue;
    }

    final body = {
      "title": r['title'],
      "vegetable_id": vegId,
      "time_min": r['time_min'],
      "ingredients": r['ingredients'],
      "steps": r['steps'],
    };

    final createRes = await http.post(
      Uri.parse('$baseUrl/api/collections/recipes/records'),
      headers: headers,
      body: jsonEncode(body)
    );

    if (createRes.statusCode == 200) {
      print('Created recipe: ${r['title']}');
    } else {
      print('Failed to create recipe ${r['title']}: ${createRes.body}');
    }
  }

  print('Seeding complete.');
}
