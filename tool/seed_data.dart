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
        {"name": "title", "type": "text", "required": true, "presentable": true},
        {"name": "vegetable_id", "type": "relation", "required": false, "collectionId": vegCollectionId, "cascadeDelete": false, "maxSelect": 1},
        {"name": "image", "type": "file", "maxSelect": 1, "maxSize": 5242880, "mimeTypes": ["image/png","image/jpeg","image/jpg","image/webp"]},
        {"name": "time_min", "type": "number", "required": false},
        {"name": "servings", "type": "number", "required": false, "min": 1},
        {"name": "ingredients", "type": "json", "required": false},
        {"name": "steps", "type": "json", "required": false},
        // Phase 11: User Recipes
        {"name": "source", "type": "select", "required": true, "maxSelect": 1, "values": ["curated", "user"]},
        {"name": "user_id", "type": "relation", "required": false, "collectionId": "_pb_users_auth_", "cascadeDelete": true, "maxSelect": 1},
        {"name": "is_public", "type": "bool", "required": false},
        {"name": "difficulty", "type": "select", "required": false, "maxSelect": 1, "values": ["easy", "medium", "hard"]}
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

  // Cache vegetable IDs for recipe seeding
  final Map<String, String> vegIdMap = {};

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
  
  // Sample Recipes (curated)
  final recipes = [
    // === KARTOFFELN ===
    {
      "vegetable": "Kartoffeln festkochend",
      "title": "Klassische Berner Rösti",
      "time_min": 45,
      "servings": 4,
      "difficulty": "easy",
      "source": "curated",
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
      "vegetable": "Kartoffeln mehligkochend",
      "title": "Cremiges Kartoffelstock",
      "time_min": 35,
      "servings": 4,
      "difficulty": "easy",
      "source": "curated",
      "ingredients": [
        {"item": "Mehligkochende Kartoffeln", "amount": "800g"},
        {"item": "Butter", "amount": "50g"},
        {"item": "Milch", "amount": "2dl"},
        {"item": "Muskatnuss", "amount": "1 Prise"},
        {"item": "Salz", "amount": "nach Geschmack"}
      ],
      "steps": [
        "Kartoffeln schälen und in gleich grosse Stücke schneiden.",
        "In Salzwasser weich kochen, ca. 20 Min.",
        "Abgiessen und kurz ausdampfen lassen.",
        "Milch und Butter erwärmen.",
        "Kartoffeln durch die Presse drücken oder stampfen.",
        "Warme Milch-Butter unterrühren, mit Muskat und Salz abschmecken."
      ]
    },
    {
      "vegetable": "Frühkartoffeln",
      "title": "Gschwellti mit Käse",
      "time_min": 25,
      "servings": 4,
      "difficulty": "easy",
      "source": "curated",
      "ingredients": [
        {"item": "Frühkartoffeln", "amount": "1kg"},
        {"item": "Gruyère AOP", "amount": "200g"},
        {"item": "Butter", "amount": "2 EL"},
        {"item": "Schnittlauch", "amount": "1 Bund"}
      ],
      "steps": [
        "Frühkartoffeln waschen, Schale dran lassen.",
        "In Salzwasser knapp weich kochen, ca. 15-20 Min.",
        "Abgiessen und mit Butter schwenken.",
        "Käse in Scheiben schneiden.",
        "Kartoffeln mit Käse und frischem Schnittlauch servieren."
      ]
    },

    // === KAROTTEN ===
    {
      "vegetable": "Karotten",
      "title": "Aargauer Rüeblisuppe",
      "time_min": 30,
      "servings": 4,
      "difficulty": "easy",
      "source": "curated",
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
      "vegetable": "Karotten",
      "title": "Glasierte Rüebli",
      "time_min": 20,
      "servings": 4,
      "difficulty": "easy",
      "source": "curated",
      "ingredients": [
        {"item": "Rüebli", "amount": "500g"},
        {"item": "Butter", "amount": "30g"},
        {"item": "Zucker", "amount": "1 EL"},
        {"item": "Petersilie", "amount": "2 EL gehackt"}
      ],
      "steps": [
        "Rüebli schälen und schräg in Scheiben schneiden.",
        "In wenig Salzwasser bissfest kochen, ca. 8 Min.",
        "Abgiessen, Butter und Zucker beigeben.",
        "Unter Schwenken glasieren bis leicht karamellisiert.",
        "Mit frischer Petersilie bestreuen."
      ]
    },

    // === ÄPFEL ===
    {
      "vegetable": "Äpfel Herbst",
      "title": "Grossmutters Apfelwähe",
      "time_min": 60,
      "servings": 8,
      "difficulty": "medium",
      "source": "curated",
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
    },
    {
      "vegetable": "Äpfel Lager",
      "title": "Öpfelchüechli",
      "time_min": 40,
      "servings": 4,
      "difficulty": "medium",
      "source": "curated",
      "ingredients": [
        {"item": "Äpfel (säuerlich)", "amount": "4"},
        {"item": "Mehl", "amount": "150g"},
        {"item": "Ei", "amount": "1"},
        {"item": "Milch", "amount": "2dl"},
        {"item": "Zucker und Zimt", "amount": "zum Bestreuen"}
      ],
      "steps": [
        "Teig aus Mehl, Ei und Milch anrühren, 15 Min. ruhen lassen.",
        "Äpfel schälen, Kerngehäuse ausstechen, in 1cm Ringe schneiden.",
        "Apfelringe durch den Teig ziehen.",
        "In heissem Öl goldbraun ausbacken.",
        "Auf Küchenpapier abtropfen, mit Zimtzucker bestreuen."
      ]
    },

    // === LAUCH ===
    {
      "vegetable": "Lauch",
      "title": "Lauchwähe",
      "time_min": 50,
      "servings": 6,
      "difficulty": "medium",
      "source": "curated",
      "ingredients": [
        {"item": "Kuchenteig", "amount": "1 rechteckig"},
        {"item": "Lauch", "amount": "600g"},
        {"item": "Speckwürfeli", "amount": "100g"},
        {"item": "Eier", "amount": "3"},
        {"item": "Rahm", "amount": "2dl"},
        {"item": "Gruyère gerieben", "amount": "100g"}
      ],
      "steps": [
        "Teig in Form legen und einstechen.",
        "Lauch in Ringe schneiden, waschen.",
        "Speck anbraten, Lauch beigeben und dünsten.",
        "Eier mit Rahm verquirlen, würzen.",
        "Lauch auf Teig verteilen, Guss darüber, Käse bestreuen.",
        "Bei 200 Grad ca. 30 Min. backen."
      ]
    },
    {
      "vegetable": "Lauch",
      "title": "Lauch-Kartoffel-Suppe",
      "time_min": 35,
      "servings": 4,
      "difficulty": "easy",
      "source": "curated",
      "ingredients": [
        {"item": "Lauch", "amount": "400g"},
        {"item": "Kartoffeln", "amount": "300g"},
        {"item": "Gemüsebouillon", "amount": "1L"},
        {"item": "Rahm", "amount": "1dl"},
        {"item": "Schnittlauch", "amount": "zum Garnieren"}
      ],
      "steps": [
        "Lauch putzen und in Ringe schneiden.",
        "Kartoffeln schälen und würfeln.",
        "Lauch in Butter andünsten.",
        "Kartoffeln und Bouillon beigeben, 20 Min. köcheln.",
        "Pürieren, Rahm unterziehen, mit Schnittlauch servieren."
      ]
    },

    // === KÜRBIS ===
    {
      "vegetable": "Kürbis",
      "title": "Kürbissuppe mit Ingwer",
      "time_min": 40,
      "servings": 4,
      "difficulty": "easy",
      "source": "curated",
      "ingredients": [
        {"item": "Kürbis (z.B. Butternut)", "amount": "800g"},
        {"item": "Zwiebel", "amount": "1"},
        {"item": "Ingwer frisch", "amount": "2cm"},
        {"item": "Kokosmilch", "amount": "2dl"},
        {"item": "Gemüsebouillon", "amount": "5dl"},
        {"item": "Kürbiskernöl", "amount": "zum Servieren"}
      ],
      "steps": [
        "Kürbis schälen, entkernen und würfeln.",
        "Zwiebel und Ingwer fein hacken, andünsten.",
        "Kürbis beigeben, kurz mitdünsten.",
        "Mit Bouillon ablöschen, 20 Min. köcheln.",
        "Pürieren, Kokosmilch unterziehen.",
        "Mit einem Schuss Kürbiskernöl servieren."
      ]
    },
    {
      "vegetable": "Kürbis",
      "title": "Ofenkürbis mit Feta",
      "time_min": 45,
      "servings": 4,
      "difficulty": "easy",
      "source": "curated",
      "ingredients": [
        {"item": "Kürbis (Hokkaido)", "amount": "1kg"},
        {"item": "Olivenöl", "amount": "3 EL"},
        {"item": "Feta", "amount": "150g"},
        {"item": "Thymian", "amount": "einige Zweige"},
        {"item": "Kürbiskerne", "amount": "2 EL"},
        {"item": "Honig", "amount": "1 EL"}
      ],
      "steps": [
        "Kürbis in Spalten schneiden (bei Hokkaido Schale dran lassen).",
        "Mit Olivenöl und Thymian marinieren.",
        "Bei 200 Grad ca. 30 Min. rösten.",
        "Feta darüberbröckeln, Kürbiskerne bestreuen.",
        "Mit etwas Honig beträufeln und servieren."
      ]
    },

    // === SPINAT ===
    {
      "vegetable": "Spinat",
      "title": "Spinatwähe",
      "time_min": 50,
      "servings": 6,
      "difficulty": "medium",
      "source": "curated",
      "ingredients": [
        {"item": "Kuchenteig", "amount": "1"},
        {"item": "Spinat frisch", "amount": "500g"},
        {"item": "Zwiebel", "amount": "1"},
        {"item": "Eier", "amount": "3"},
        {"item": "Rahm", "amount": "2dl"},
        {"item": "Sbrinz gerieben", "amount": "50g"}
      ],
      "steps": [
        "Teig in Form legen, einstechen.",
        "Spinat waschen, blanchieren, ausdrücken und hacken.",
        "Zwiebel andünsten, Spinat beigeben.",
        "Eier mit Rahm verquirlen, würzen.",
        "Spinat auf Teig, Guss darüber, Käse bestreuen.",
        "Bei 200 Grad ca. 30 Min. backen."
      ]
    },

    // === SPARGEL ===
    {
      "vegetable": "Spargel",
      "title": "Spargeln mit Sauce Hollandaise",
      "time_min": 35,
      "servings": 4,
      "difficulty": "medium",
      "source": "curated",
      "ingredients": [
        {"item": "Weisse Spargeln", "amount": "1kg"},
        {"item": "Butter", "amount": "150g"},
        {"item": "Eigelb", "amount": "3"},
        {"item": "Zitronensaft", "amount": "1 EL"},
        {"item": "Salz, Pfeffer", "amount": "nach Geschmack"}
      ],
      "steps": [
        "Spargeln schälen, holzige Enden abschneiden.",
        "In Salzwasser mit etwas Zucker ca. 15 Min. kochen.",
        "Für die Sauce: Eigelb mit 2 EL Wasser über Wasserbad schaumig schlagen.",
        "Flüssige Butter langsam unterrühren.",
        "Mit Zitronensaft, Salz und Pfeffer abschmecken.",
        "Spargeln mit Sauce servieren, dazu Gschwellti."
      ]
    },

    // === RHABARBER ===
    {
      "vegetable": "Rhabarber",
      "title": "Rhabarberkompott",
      "time_min": 20,
      "servings": 4,
      "difficulty": "easy",
      "source": "curated",
      "ingredients": [
        {"item": "Rhabarber", "amount": "500g"},
        {"item": "Zucker", "amount": "100g"},
        {"item": "Vanilleschote", "amount": "1/2"},
        {"item": "Wasser", "amount": "1dl"}
      ],
      "steps": [
        "Rhabarber waschen und in 2cm Stücke schneiden.",
        "Zucker mit Wasser und Vanillemark aufkochen.",
        "Rhabarber beigeben und bei kleiner Hitze 5-8 Min. köcheln.",
        "Nicht zu stark rühren, damit Stücke erhalten bleiben.",
        "Warm oder kalt servieren, z.B. mit Vanilleglace."
      ]
    },
    {
      "vegetable": "Rhabarber",
      "title": "Rhabarberwähe",
      "time_min": 55,
      "servings": 8,
      "difficulty": "medium",
      "source": "curated",
      "ingredients": [
        {"item": "Kuchenteig", "amount": "1"},
        {"item": "Rhabarber", "amount": "600g"},
        {"item": "Zucker", "amount": "100g"},
        {"item": "Eier", "amount": "2"},
        {"item": "Rahm", "amount": "2dl"}
      ],
      "steps": [
        "Teig in Form legen und einstechen.",
        "Rhabarber in Stücke schneiden, auf Teig verteilen.",
        "Mit der Hälfte des Zuckers bestreuen.",
        "Eier, Rahm und restlichen Zucker verquirlen.",
        "Guss über Rhabarber giessen.",
        "Bei 200 Grad ca. 35-40 Min. backen."
      ]
    },

    // === FEDERKOHL / KALE ===
    {
      "vegetable": "Federkohl",
      "title": "Federkohl-Chips",
      "time_min": 25,
      "servings": 4,
      "difficulty": "easy",
      "source": "curated",
      "ingredients": [
        {"item": "Federkohl", "amount": "200g"},
        {"item": "Olivenöl", "amount": "2 EL"},
        {"item": "Salz", "amount": "1/2 TL"},
        {"item": "Paprikapulver", "amount": "optional"}
      ],
      "steps": [
        "Federkohl waschen und trocknen, Blätter von Stielen zupfen.",
        "Blätter in mundgerechte Stücke reissen.",
        "Mit Olivenöl und Salz massieren.",
        "Auf Backblech verteilen, nicht überlappen.",
        "Bei 150 Grad ca. 15-20 Min. backen bis knusprig.",
        "Sofort servieren."
      ]
    },

    // === WIRZ ===
    {
      "vegetable": "Wirz",
      "title": "Wirzrouladen",
      "time_min": 75,
      "servings": 4,
      "difficulty": "medium",
      "source": "curated",
      "ingredients": [
        {"item": "Wirzblätter gross", "amount": "8"},
        {"item": "Hackfleisch gemischt", "amount": "400g"},
        {"item": "Zwiebel", "amount": "1"},
        {"item": "Ei", "amount": "1"},
        {"item": "Tomatensauce", "amount": "3dl"}
      ],
      "steps": [
        "Wirzblätter 3 Min. blanchieren, abschrecken.",
        "Hackfleisch mit Zwiebel, Ei und Gewürzen mischen.",
        "Füllung auf Blätter verteilen und einrollen.",
        "Rouladen in Bratpfanne anbraten.",
        "Mit Tomatensauce ablöschen und 40 Min. schmoren.",
        "Mit Kartoffelstock servieren."
      ]
    },

    // === TOMATEN ===
    {
      "vegetable": "Tomaten",
      "title": "Caprese Salat",
      "time_min": 10,
      "servings": 4,
      "difficulty": "easy",
      "source": "curated",
      "ingredients": [
        {"item": "Tomaten reif", "amount": "4 grosse"},
        {"item": "Mozzarella di Bufala", "amount": "2 Kugeln"},
        {"item": "Basilikum frisch", "amount": "1 Bund"},
        {"item": "Olivenöl extra vergine", "amount": "4 EL"},
        {"item": "Fleur de Sel", "amount": "nach Geschmack"}
      ],
      "steps": [
        "Tomaten in Scheiben schneiden.",
        "Mozzarella abtropfen und in Scheiben schneiden.",
        "Abwechselnd auf Teller anrichten.",
        "Basilikumblätter darauf verteilen.",
        "Grosszügig mit Olivenöl beträufeln.",
        "Mit Fleur de Sel würzen und sofort servieren."
      ]
    },
    {
      "vegetable": "Tomaten",
      "title": "Gefüllte Tomaten",
      "time_min": 45,
      "servings": 4,
      "difficulty": "medium",
      "source": "curated",
      "ingredients": [
        {"item": "Fleischtomaten", "amount": "8"},
        {"item": "Reis", "amount": "150g"},
        {"item": "Fetakäse", "amount": "100g"},
        {"item": "Oliven", "amount": "50g"},
        {"item": "Frische Kräuter", "amount": "3 EL"}
      ],
      "steps": [
        "Tomatendeckel abschneiden, aushöhlen.",
        "Reis kochen und abkühlen lassen.",
        "Reis mit zerbröckeltem Feta, gehackten Oliven und Kräutern mischen.",
        "Tomaten füllen, Deckel aufsetzen.",
        "Bei 180 Grad ca. 25 Min. backen.",
        "Warm oder lauwarm servieren."
      ]
    },

    // === ZUCCHETTI ===
    {
      "vegetable": "Zucchetti",
      "title": "Zucchetti-Puffer",
      "time_min": 30,
      "servings": 4,
      "difficulty": "easy",
      "source": "curated",
      "ingredients": [
        {"item": "Zucchetti", "amount": "500g"},
        {"item": "Eier", "amount": "2"},
        {"item": "Mehl", "amount": "3 EL"},
        {"item": "Parmesan gerieben", "amount": "50g"},
        {"item": "Öl zum Braten", "amount": ""},
        {"item": "Sauerrahm", "amount": "zum Servieren"}
      ],
      "steps": [
        "Zucchetti grob raffeln und salzen, 10 Min. ziehen lassen.",
        "Gut ausdrücken.",
        "Mit Eiern, Mehl und Parmesan mischen, würzen.",
        "In heissem Öl kleine Puffer beidseitig goldbraun braten.",
        "Auf Küchenpapier abtropfen.",
        "Mit Sauerrahm servieren."
      ]
    },

    // === ERDBEEREN ===
    {
      "vegetable": "Erdbeeren",
      "title": "Erdbeeren mit Rahm",
      "time_min": 10,
      "servings": 4,
      "difficulty": "easy",
      "source": "curated",
      "ingredients": [
        {"item": "Erdbeeren", "amount": "500g"},
        {"item": "Vollrahm", "amount": "2dl"},
        {"item": "Puderzucker", "amount": "2 EL"},
        {"item": "Vanillezucker", "amount": "1 Päckchen"}
      ],
      "steps": [
        "Erdbeeren waschen, rüsten und je nach Grösse halbieren.",
        "Rahm mit Puderzucker und Vanillezucker steif schlagen.",
        "Erdbeeren auf Schälchen verteilen.",
        "Schlagrahm grosszügig darübergeben.",
        "Sofort servieren."
      ]
    },
    {
      "vegetable": "Erdbeeren",
      "title": "Erdbeerkuchen",
      "time_min": 45,
      "servings": 10,
      "difficulty": "medium",
      "source": "curated",
      "ingredients": [
        {"item": "Biskuitboden", "amount": "1"},
        {"item": "Erdbeeren", "amount": "750g"},
        {"item": "Vanillepudding", "amount": "500g"},
        {"item": "Tortenguss rot", "amount": "1 Päckchen"}
      ],
      "steps": [
        "Biskuitboden auf Platte legen.",
        "Vanillepudding darauf verteilen.",
        "Erdbeeren waschen, rüsten und dicht auf Pudding setzen.",
        "Tortenguss nach Anleitung zubereiten.",
        "Über Erdbeeren giessen und fest werden lassen.",
        "Gekühlt servieren."
      ]
    },

    // === KIRSCHEN ===
    {
      "vegetable": "Kirschen",
      "title": "Chriesiauflauf",
      "time_min": 50,
      "servings": 6,
      "difficulty": "medium",
      "source": "curated",
      "ingredients": [
        {"item": "Kirschen entsteint", "amount": "500g"},
        {"item": "Butter", "amount": "50g"},
        {"item": "Zucker", "amount": "80g"},
        {"item": "Eier", "amount": "3"},
        {"item": "Mehl", "amount": "100g"},
        {"item": "Milch", "amount": "2dl"}
      ],
      "steps": [
        "Butter mit Zucker schaumig rühren.",
        "Eier einzeln unterrühren.",
        "Mehl und Milch abwechselnd unterheben.",
        "Kirschen in gefettete Form geben.",
        "Teig darübergiessen.",
        "Bei 180 Grad ca. 35 Min. backen bis goldbraun."
      ]
    },

    // === ZWETSCHGEN ===
    {
      "vegetable": "Zwetschgen",
      "title": "Zwetschgenwähe",
      "time_min": 55,
      "servings": 8,
      "difficulty": "medium",
      "source": "curated",
      "ingredients": [
        {"item": "Kuchenteig", "amount": "1"},
        {"item": "Zwetschgen", "amount": "800g"},
        {"item": "Zucker", "amount": "80g"},
        {"item": "Zimt", "amount": "1 TL"},
        {"item": "Rahm-Guss", "amount": "2dl"}
      ],
      "steps": [
        "Teig in Form legen und einstechen.",
        "Zwetschgen halbieren und entsteinen.",
        "Dachziegelartig auf Teig legen.",
        "Mit Zimtzucker bestreuen.",
        "Guss darübergiessen.",
        "Bei 200 Grad ca. 35-40 Min. backen."
      ]
    },

    // === HIMBEEREN ===
    {
      "vegetable": "Himbeeren",
      "title": "Himbeer-Joghurt-Mousse",
      "time_min": 20,
      "servings": 4,
      "difficulty": "easy",
      "source": "curated",
      "ingredients": [
        {"item": "Himbeeren", "amount": "300g"},
        {"item": "Griechischer Joghurt", "amount": "400g"},
        {"item": "Honig", "amount": "3 EL"},
        {"item": "Vanillezucker", "amount": "1 Päckchen"}
      ],
      "steps": [
        "Die Hälfte der Himbeeren pürieren.",
        "Joghurt mit Honig und Vanillezucker verrühren.",
        "Himbeerpüree unterheben (nicht ganz vermischen für Marmor-Effekt).",
        "In Gläser füllen.",
        "Mit restlichen Himbeeren garnieren.",
        "Gekühlt servieren."
      ]
    },

    // === NÜSSLISALAT ===
    {
      "vegetable": "Nüsslisalat",
      "title": "Nüsslisalat mit Speck und Ei",
      "time_min": 20,
      "servings": 4,
      "difficulty": "easy",
      "source": "curated",
      "ingredients": [
        {"item": "Nüsslisalat", "amount": "200g"},
        {"item": "Speckwürfeli", "amount": "100g"},
        {"item": "Eier", "amount": "4"},
        {"item": "Essig", "amount": "2 EL"},
        {"item": "Öl", "amount": "4 EL"},
        {"item": "Senf", "amount": "1 TL"}
      ],
      "steps": [
        "Nüsslisalat waschen und trocknen.",
        "Speckwürfeli knusprig braten.",
        "Eier wachsweich kochen (6 Min.), schälen und halbieren.",
        "Sauce aus Essig, Öl und Senf rühren.",
        "Salat mit Sauce mischen, auf Tellern anrichten.",
        "Mit Speck und Ei garnieren."
      ]
    },

    // === CHICORÉE ===
    {
      "vegetable": "Chicorée",
      "title": "Überbackener Chicorée",
      "time_min": 35,
      "servings": 4,
      "difficulty": "easy",
      "source": "curated",
      "ingredients": [
        {"item": "Chicorée", "amount": "4 Stück"},
        {"item": "Kochschinken", "amount": "4 Scheiben"},
        {"item": "Béchamelsauce", "amount": "3dl"},
        {"item": "Gruyère gerieben", "amount": "100g"}
      ],
      "steps": [
        "Chicorée halbieren, in Salzwasser 10 Min. kochen.",
        "Abtropfen lassen.",
        "Mit Schinken umwickeln, in Gratinform legen.",
        "Mit Béchamelsauce übergiessen.",
        "Käse darüberstreuen.",
        "Bei 200 Grad ca. 20 Min. überbacken."
      ]
    },

    // === RANDEN ===
    {
      "vegetable": "Randen",
      "title": "Randensalat",
      "time_min": 70,
      "servings": 4,
      "difficulty": "easy",
      "source": "curated",
      "ingredients": [
        {"item": "Randen roh", "amount": "500g"},
        {"item": "Meerrettich frisch gerieben", "amount": "2 EL"},
        {"item": "Apfelessig", "amount": "3 EL"},
        {"item": "Rapsöl", "amount": "4 EL"},
        {"item": "Kümmel", "amount": "1/2 TL"}
      ],
      "steps": [
        "Randen im Ofen bei 200 Grad ca. 60 Min. garen (in Alufolie).",
        "Abkühlen lassen, schälen und in feine Scheiben schneiden.",
        "Sauce aus Meerrettich, Essig, Öl und Kümmel mischen.",
        "Randen mit Sauce marinieren.",
        "Mindestens 1 Stunde ziehen lassen.",
        "Als Beilage servieren."
      ]
    },

    // === ROSENKOHL ===
    {
      "vegetable": "Rosenkohl",
      "title": "Gebratener Rosenkohl mit Speck",
      "time_min": 25,
      "servings": 4,
      "difficulty": "easy",
      "source": "curated",
      "ingredients": [
        {"item": "Rosenkohl", "amount": "500g"},
        {"item": "Speckwürfeli", "amount": "100g"},
        {"item": "Butter", "amount": "30g"},
        {"item": "Muskatnuss", "amount": "1 Prise"}
      ],
      "steps": [
        "Rosenkohl putzen, halbieren.",
        "In Salzwasser 5 Min. blanchieren, abschrecken.",
        "Speck in Bratpfanne knusprig braten.",
        "Butter und Rosenkohl beigeben.",
        "Bei hoher Hitze anbraten bis karamellisiert.",
        "Mit Muskat würzen und servieren."
      ]
    },

    // === FENCHEL ===
    {
      "vegetable": "Fenchel",
      "title": "Fenchel-Orangen-Salat",
      "time_min": 15,
      "servings": 4,
      "difficulty": "easy",
      "source": "curated",
      "ingredients": [
        {"item": "Fenchel", "amount": "2 Knollen"},
        {"item": "Orangen", "amount": "2"},
        {"item": "Olivenöl", "amount": "3 EL"},
        {"item": "Zitronensaft", "amount": "1 EL"},
        {"item": "Schwarze Oliven", "amount": "50g"}
      ],
      "steps": [
        "Fenchel in hauchdünne Scheiben hobeln, Grün aufbewahren.",
        "Orangen filetieren, Saft auffangen.",
        "Fenchel und Orangenfilets anrichten.",
        "Olivenöl mit Zitronen- und Orangensaft mischen.",
        "Salat damit beträufeln.",
        "Mit Oliven und Fenchelgrün garnieren."
      ]
    },

    // === HIRSCH (FLEISCH) ===
    {
      "vegetable": "Hirsch",
      "title": "Hirschpfeffer",
      "time_min": 150,
      "servings": 6,
      "difficulty": "hard",
      "source": "curated",
      "ingredients": [
        {"item": "Hirschragout", "amount": "1kg"},
        {"item": "Rotwein", "amount": "5dl"},
        {"item": "Zwiebeln", "amount": "3"},
        {"item": "Wacholderbeeren", "amount": "8"},
        {"item": "Lorbeerblätter", "amount": "2"},
        {"item": "Rahm", "amount": "2dl"}
      ],
      "steps": [
        "Fleisch würfeln und scharf anbraten.",
        "Zwiebeln beigeben und mitrösten.",
        "Mit Rotwein ablöschen.",
        "Gewürze beigeben, 2 Stunden sanft schmoren.",
        "Sauce evtl. binden und Rahm unterziehen.",
        "Mit Spätzli und Rotkohl servieren."
      ]
    },

    // === KALBFLEISCH ===
    {
      "vegetable": "Kalbfleisch",
      "title": "Zürcher Geschnetzeltes",
      "time_min": 30,
      "servings": 4,
      "difficulty": "medium",
      "source": "curated",
      "ingredients": [
        {"item": "Kalbfleisch (Schulter)", "amount": "600g"},
        {"item": "Champignons", "amount": "200g"},
        {"item": "Zwiebel", "amount": "1"},
        {"item": "Weisswein", "amount": "1dl"},
        {"item": "Rahm", "amount": "2dl"},
        {"item": "Butter", "amount": "40g"}
      ],
      "steps": [
        "Fleisch in feine Streifen schneiden.",
        "In heisser Butter portionenweise scharf anbraten.",
        "Warm stellen.",
        "Zwiebeln und Champignons andünsten.",
        "Mit Weisswein ablöschen.",
        "Rahm beigeben, einköcheln lassen.",
        "Fleisch zurück in die Sauce geben, heiss servieren.",
        "Mit Rösti servieren."
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
      "servings": r['servings'],
      "difficulty": r['difficulty'],
      "source": r['source'],
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
