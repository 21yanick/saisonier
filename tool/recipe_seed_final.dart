// ignore_for_file: avoid_print, depend_on_referenced_packages
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Comprehensive Recipe Seeder for Saisonier
/// Loads recipes from separate Dart files and seeds to PocketBase
///
/// Usage:
///   cd tool && dart run recipe_seed_final.dart

Future<void> main() async {
  final baseUrl = Platform.environment['PB_URL'] ?? 'https://saisonier-api.21home.ch';
  final adminEmail = Platform.environment['PB_EMAIL'] ?? 'admin@saisonier.ch';
  final adminPass = Platform.environment['PB_PASS'] ?? 'saisonier123';

  // Load all recipe parts
  final allRecipes = [
    ...recipesPartOne,
    ...recipesPartTwo,
    ...recipesPartThree,
    ...recipesPartFour,
  ];

  print('🍳 Saisonier Recipe Seeder - Complete Edition');
  print('   Server: $baseUrl');
  print('   Total recipes: ${allRecipes.length}');
  print('');

  // 1. Authenticate
  String? token;
  try {
    final authRes = await http.post(
      Uri.parse('$baseUrl/api/collections/_superusers/auth-with-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'identity': adminEmail, 'password': adminPass}),
    );
    if (authRes.statusCode != 200) {
      print('❌ Auth failed: ${authRes.body}');
      exit(1);
    }
    token = jsonDecode(authRes.body)['token'];
    print('✅ Authenticated');
  } catch (e) {
    print('❌ Connection failed: $e');
    exit(1);
  }

  final headers = {
    'Authorization': token!,
    'Content-Type': 'application/json',
  };

  // 2. Load vegetable IDs
  print('📦 Loading vegetables...');
  final Map<String, String> vegIdMap = {};
  final vegRes = await http.get(
    Uri.parse('$baseUrl/api/collections/vegetables/records?perPage=500'),
    headers: headers,
  );
  if (vegRes.statusCode == 200) {
    final items = jsonDecode(vegRes.body)['items'] as List;
    for (final v in items) {
      vegIdMap[v['name']] = v['id'];
    }
    print('   ${vegIdMap.length} vegetables loaded');
  } else {
    print('❌ Could not load vegetables');
    exit(1);
  }

  // 3. Seed recipes
  print('');
  print('🥗 Seeding ${allRecipes.length} recipes...');

  int created = 0, skipped = 0, failed = 0;

  for (final recipe in allRecipes) {
    final title = recipe['title'] as String;
    final vegName = recipe['vegetable'] as String?;
    final vegId = vegName != null ? vegIdMap[vegName] : null;

    if (vegName != null && vegId == null) {
      print('   ⚠️ $title: "$vegName" nicht gefunden');
      skipped++;
      continue;
    }

    // Check if exists
    final existsRes = await http.get(
      Uri.parse('$baseUrl/api/collections/recipes/records?filter=title="$title"'),
      headers: headers,
    );
    if (existsRes.statusCode == 200 &&
        (jsonDecode(existsRes.body)['totalItems'] ?? 0) > 0) {
      skipped++;
      continue;
    }

    final body = {
      'title': title,
      'description': recipe['description'] ?? '',
      'vegetable_id': vegId,
      'prep_time_min': recipe['prep_time_min'] ?? 0,
      'cook_time_min': recipe['cook_time_min'] ?? 30,
      'servings': recipe['servings'] ?? 4,
      'difficulty': recipe['difficulty'] ?? 'medium',
      'category': recipe['category'],
      'source': 'curated',
      'ingredients': recipe['ingredients'],
      'steps': recipe['steps'],
      'tags': recipe['tags'] ?? [],
      'is_vegetarian': recipe['is_vegetarian'] ?? false,
      'is_vegan': recipe['is_vegan'] ?? false,
      'contains_gluten': recipe['contains_gluten'] ?? false,
      'contains_lactose': recipe['contains_lactose'] ?? false,
      'contains_nuts': recipe['contains_nuts'] ?? false,
      'contains_eggs': recipe['contains_eggs'] ?? false,
      'contains_soy': recipe['contains_soy'] ?? false,
      'contains_fish': recipe['contains_fish'] ?? false,
      'contains_shellfish': recipe['contains_shellfish'] ?? false,
    };

    final createRes = await http.post(
      Uri.parse('$baseUrl/api/collections/recipes/records'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (createRes.statusCode == 200) {
      print('   ✅ $title');
      created++;
    } else {
      print('   ❌ $title: ${createRes.body}');
      failed++;
    }
  }

  print('');
  print('═══════════════════════════════════════');
  print('📊 Zusammenfassung:');
  print('   ✅ Erstellt: $created');
  print('   ⏭️ Übersprungen: $skipped');
  print('   ❌ Fehlgeschlagen: $failed');
  print('═══════════════════════════════════════');
}

// Include recipe data inline

final recipesPartOne = <Map<String, dynamic>>[
  {'vegetable': 'Artischocke', 'title': 'Gegrillte Artischocken', 'description': 'Mediterran mit Zitrone.', 'prep_time_min': 20, 'cook_time_min': 25, 'servings': 4, 'difficulty': 'medium', 'category': 'side', 'tags': ['mediterran'], 'is_vegetarian': true, 'is_vegan': true, 'ingredients': [{'item': 'Artischocken', 'amount': 4, 'unit': 'Stück'}, {'item': 'Zitrone', 'amount': 2, 'unit': 'Stück'}, {'item': 'Olivenöl', 'amount': 4, 'unit': 'EL'}], 'steps': ['Artischocken putzen.', 'In Zitronenwasser legen.', 'Vorkochen und grillen.']},
  {'vegetable': 'Artischocke', 'title': 'Artischocken-Pasta', 'description': 'Cremig mit Parmesan.', 'prep_time_min': 15, 'cook_time_min': 20, 'servings': 4, 'difficulty': 'easy', 'category': 'main', 'tags': ['schnell'], 'is_vegetarian': true, 'contains_gluten': true, 'contains_lactose': true, 'ingredients': [{'item': 'Penne', 'amount': 400, 'unit': 'g'}, {'item': 'Artischockenherzen', 'amount': 400, 'unit': 'g'}, {'item': 'Rahm', 'amount': 200, 'unit': 'ml'}], 'steps': ['Pasta kochen.', 'Artischocken anbraten.', 'Mit Rahm und Parmesan mischen.']},
  {'vegetable': 'Artischocke', 'title': 'Artischocken-Dip', 'description': 'Cremig für Apéro.', 'prep_time_min': 10, 'cook_time_min': 20, 'servings': 6, 'difficulty': 'easy', 'category': 'snack', 'tags': ['party'], 'is_vegetarian': true, 'contains_lactose': true, 'ingredients': [{'item': 'Artischockenherzen', 'amount': 400, 'unit': 'g'}, {'item': 'Frischkäse', 'amount': 200, 'unit': 'g'}, {'item': 'Parmesan', 'amount': 50, 'unit': 'g'}], 'steps': ['Hacken und mischen.', 'Überbacken.']},
  {'vegetable': 'Aubergine', 'title': 'Baba Ganoush', 'description': 'Orientalischer Dip.', 'prep_time_min': 15, 'cook_time_min': 40, 'servings': 6, 'difficulty': 'easy', 'category': 'snack', 'tags': ['vegan', 'party'], 'is_vegetarian': true, 'is_vegan': true, 'ingredients': [{'item': 'Auberginen', 'amount': 2, 'unit': 'Stück'}, {'item': 'Tahini', 'amount': 3, 'unit': 'EL'}, {'item': 'Zitronensaft', 'amount': 2, 'unit': 'EL'}], 'steps': ['Auberginen im Ofen rösten.', 'Mit Tahini pürieren.']},
  {'vegetable': 'Aubergine', 'title': 'Auberginen-Parmigiana', 'description': 'Italienischer Auflauf.', 'prep_time_min': 30, 'cook_time_min': 45, 'servings': 6, 'difficulty': 'medium', 'category': 'main', 'tags': ['comfort-food'], 'is_vegetarian': true, 'contains_lactose': true, 'ingredients': [{'item': 'Auberginen', 'amount': 3, 'unit': 'Stück'}, {'item': 'Passata', 'amount': 500, 'unit': 'ml'}, {'item': 'Mozzarella', 'amount': 250, 'unit': 'g'}], 'steps': ['Schichten und backen.']},
  {'vegetable': 'Aubergine', 'title': 'Gefüllte Auberginen', 'description': 'Mit Hackfleisch.', 'prep_time_min': 25, 'cook_time_min': 35, 'servings': 4, 'difficulty': 'medium', 'category': 'main', 'tags': ['meal-prep'], 'ingredients': [{'item': 'Auberginen', 'amount': 4, 'unit': 'Stück'}, {'item': 'Hackfleisch', 'amount': 300, 'unit': 'g'}, {'item': 'Tomaten', 'amount': 2, 'unit': 'Stück'}], 'steps': ['Aushöhlen.', 'Füllen.', 'Backen.']},
  {'vegetable': 'Blumenkohl', 'title': 'Blumenkohl-Käse-Gratin', 'description': 'Cremig überbacken.', 'prep_time_min': 15, 'cook_time_min': 30, 'servings': 4, 'difficulty': 'easy', 'category': 'main', 'tags': ['comfort-food'], 'is_vegetarian': true, 'contains_lactose': true, 'contains_gluten': true, 'ingredients': [{'item': 'Blumenkohl', 'amount': 1, 'unit': 'Stück'}, {'item': 'Gruyère', 'amount': 150, 'unit': 'g'}, {'item': 'Milch', 'amount': 500, 'unit': 'ml'}], 'steps': ['Blanchieren.', 'Béchamel.', 'Überbacken.']},
  {'vegetable': 'Blumenkohl', 'title': 'Blumenkohl-Wings', 'description': 'Vegane Alternative.', 'prep_time_min': 20, 'cook_time_min': 35, 'servings': 4, 'difficulty': 'easy', 'category': 'snack', 'tags': ['vegan', 'party'], 'is_vegetarian': true, 'is_vegan': true, 'contains_gluten': true, 'ingredients': [{'item': 'Blumenkohl', 'amount': 1, 'unit': 'Stück'}, {'item': 'Mehl', 'amount': 100, 'unit': 'g'}, {'item': 'Hot Sauce', 'amount': 4, 'unit': 'EL'}], 'steps': ['Panieren und backen.']},
  {'vegetable': 'Blumenkohl', 'title': 'Blumenkohl-Reis', 'description': 'Low-Carb Beilage.', 'prep_time_min': 10, 'cook_time_min': 10, 'servings': 4, 'difficulty': 'easy', 'category': 'side', 'tags': ['low-carb', 'vegan'], 'is_vegetarian': true, 'is_vegan': true, 'ingredients': [{'item': 'Blumenkohl', 'amount': 1, 'unit': 'Stück'}, {'item': 'Olivenöl', 'amount': 2, 'unit': 'EL'}], 'steps': ['Zerkleinern.', 'Anbraten.']},
  {'vegetable': 'Bohnen', 'title': 'Bohnen mit Speck', 'description': 'Klassische Beilage.', 'prep_time_min': 10, 'cook_time_min': 20, 'servings': 4, 'difficulty': 'easy', 'category': 'side', 'tags': ['comfort-food'], 'ingredients': [{'item': 'Grüne Bohnen', 'amount': 500, 'unit': 'g'}, {'item': 'Speckwürfeli', 'amount': 100, 'unit': 'g'}], 'steps': ['Kochen.', 'Mit Speck braten.']},
  {'vegetable': 'Bohnen', 'title': 'Bohnensalat', 'description': 'Mit Vinaigrette.', 'prep_time_min': 15, 'cook_time_min': 10, 'servings': 4, 'difficulty': 'easy', 'category': 'salad', 'tags': ['vegan', 'meal-prep'], 'is_vegetarian': true, 'is_vegan': true, 'ingredients': [{'item': 'Grüne Bohnen', 'amount': 400, 'unit': 'g'}, {'item': 'Olivenöl', 'amount': 4, 'unit': 'EL'}], 'steps': ['Kochen und anmachen.']},
  {'vegetable': 'Bohnen', 'title': 'Provenzalische Bohnen', 'description': 'Mit Tomaten.', 'prep_time_min': 15, 'cook_time_min': 25, 'servings': 4, 'difficulty': 'easy', 'category': 'side', 'tags': ['vegan', 'mediterran'], 'is_vegetarian': true, 'is_vegan': true, 'ingredients': [{'item': 'Grüne Bohnen', 'amount': 500, 'unit': 'g'}, {'item': 'Cherrytomaten', 'amount': 250, 'unit': 'g'}], 'steps': ['Blanchieren und schmoren.']},
  {'vegetable': 'Brokkoli', 'title': 'Gebratener Brokkoli', 'description': 'Asiatisch.', 'prep_time_min': 10, 'cook_time_min': 10, 'servings': 4, 'difficulty': 'easy', 'category': 'side', 'tags': ['schnell', 'vegan'], 'is_vegetarian': true, 'is_vegan': true, 'ingredients': [{'item': 'Brokkoli', 'amount': 500, 'unit': 'g'}, {'item': 'Sojasauce', 'amount': 2, 'unit': 'EL'}], 'steps': ['Im Wok braten.']},
  {'vegetable': 'Brokkoli', 'title': 'Brokkoli-Crèmesuppe', 'description': 'Samtweich.', 'prep_time_min': 15, 'cook_time_min': 20, 'servings': 4, 'difficulty': 'easy', 'category': 'soup', 'tags': ['comfort-food'], 'is_vegetarian': true, 'contains_lactose': true, 'ingredients': [{'item': 'Brokkoli', 'amount': 600, 'unit': 'g'}, {'item': 'Rahm', 'amount': 100, 'unit': 'ml'}], 'steps': ['Kochen und pürieren.']},
  {'vegetable': 'Brokkoli', 'title': 'Brokkoli-Nudelauflauf', 'description': 'Familiengericht.', 'prep_time_min': 20, 'cook_time_min': 25, 'servings': 4, 'difficulty': 'easy', 'category': 'main', 'tags': ['kinderfreundlich'], 'is_vegetarian': true, 'contains_gluten': true, 'contains_lactose': true, 'ingredients': [{'item': 'Fusilli', 'amount': 300, 'unit': 'g'}, {'item': 'Brokkoli', 'amount': 400, 'unit': 'g'}], 'steps': ['Kochen und überbacken.']},
  {'vegetable': 'Chinakohl', 'title': 'Asiatischer Chinakohlsalat', 'description': 'Knackig.', 'prep_time_min': 15, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'salad', 'tags': ['schnell', 'vegan'], 'is_vegetarian': true, 'is_vegan': true, 'ingredients': [{'item': 'Chinakohl', 'amount': 400, 'unit': 'g'}, {'item': 'Sesam', 'amount': 2, 'unit': 'EL'}], 'steps': ['Schneiden und anmachen.']},
  {'vegetable': 'Chinakohl', 'title': 'Chinakohl aus dem Wok', 'description': 'Schnell gebraten.', 'prep_time_min': 10, 'cook_time_min': 8, 'servings': 4, 'difficulty': 'easy', 'category': 'side', 'tags': ['schnell', 'vegan'], 'is_vegetarian': true, 'is_vegan': true, 'ingredients': [{'item': 'Chinakohl', 'amount': 500, 'unit': 'g'}, {'item': 'Sojasauce', 'amount': 2, 'unit': 'EL'}], 'steps': ['Im Wok braten.']},
  {'vegetable': 'Chinakohl', 'title': 'Chinakohlwickel', 'description': 'Low-Carb Wraps.', 'prep_time_min': 20, 'cook_time_min': 15, 'servings': 4, 'difficulty': 'medium', 'category': 'main', 'tags': ['low-carb'], 'ingredients': [{'item': 'Chinakohl', 'amount': 8, 'unit': 'Blätter'}, {'item': 'Hackfleisch', 'amount': 400, 'unit': 'g'}], 'steps': ['Blanchieren.', 'Füllen.', 'Dämpfen.']},
];

// Recipe Data Part 2: Erbsen to Kohlrabi

final recipesPartTwo = <Map<String, dynamic>>[
  // ═══════════════════════════════════════════════════════════════════════════
  // ERBSEN
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Erbsen',
    'title': 'Erbsen-Minz-Suppe',
    'description': 'Erfrischende Frühlingssuppe.',
    'prep_time_min': 10, 'cook_time_min': 15, 'servings': 4, 'difficulty': 'easy', 'category': 'soup',
    'tags': ['schnell', 'gesund'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [
      {'item': 'Erbsen (TK)', 'amount': 500, 'unit': 'g'},
      {'item': 'Gemüsebouillon', 'amount': 600, 'unit': 'ml'},
      {'item': 'Minze', 'amount': 1, 'unit': 'Bund'},
      {'item': 'Rahm', 'amount': 100, 'unit': 'ml'},
      {'item': 'Zwiebel', 'amount': 1, 'unit': 'Stück'},
    ],
    'steps': ['Zwiebel andünsten.', 'Erbsen und Bouillon zugeben.', '10 Min. köcheln.', 'Mit Minze pürieren.', 'Rahm unterziehen.'],
  },
  {
    'vegetable': 'Erbsen',
    'title': 'Erbsen-Risotto',
    'description': 'Cremig und frühlingsfrisch.',
    'prep_time_min': 10, 'cook_time_min': 25, 'servings': 4, 'difficulty': 'medium', 'category': 'main',
    'tags': ['comfort-food'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [
      {'item': 'Risottoreis', 'amount': 300, 'unit': 'g'},
      {'item': 'Erbsen', 'amount': 200, 'unit': 'g'},
      {'item': 'Weisswein', 'amount': 100, 'unit': 'ml'},
      {'item': 'Gemüsebouillon', 'amount': 800, 'unit': 'ml'},
      {'item': 'Parmesan', 'amount': 80, 'unit': 'g'},
      {'item': 'Butter', 'amount': 50, 'unit': 'g'},
    ],
    'steps': ['Reis in Butter anschwitzen.', 'Mit Wein ablöschen.', 'Bouillon schöpfweise zugeben.', 'Erbsen nach 15 Min. beigeben.', 'Mit Parmesan und Butter vollenden.'],
  },
  {
    'vegetable': 'Erbsen',
    'title': 'Erbsenpüree',
    'description': 'Elegante Beilage zu Fleisch und Fisch.',
    'prep_time_min': 5, 'cook_time_min': 10, 'servings': 4, 'difficulty': 'easy', 'category': 'side',
    'tags': ['schnell', 'gesund'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [
      {'item': 'Erbsen', 'amount': 400, 'unit': 'g'},
      {'item': 'Butter', 'amount': 30, 'unit': 'g'},
      {'item': 'Minze', 'amount': 2, 'unit': 'EL'},
      {'item': 'Zitronensaft', 'amount': 1, 'unit': 'EL'},
    ],
    'steps': ['Erbsen 5 Min. kochen.', 'Mit Butter pürieren.', 'Minze und Zitrone unterheben.', 'Mit Salz und Pfeffer abschmecken.'],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // GURKEN
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Gurken',
    'title': 'Tzatziki',
    'description': 'Griechischer Gurken-Joghurt-Dip.',
    'prep_time_min': 15, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'snack',
    'tags': ['schnell', 'party'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [
      {'item': 'Gurke', 'amount': 1, 'unit': 'Stück'},
      {'item': 'Griechischer Joghurt', 'amount': 400, 'unit': 'g'},
      {'item': 'Knoblauch', 'amount': 2, 'unit': 'Zehen'},
      {'item': 'Olivenöl', 'amount': 2, 'unit': 'EL'},
      {'item': 'Dill', 'amount': 2, 'unit': 'EL'},
    ],
    'steps': ['Gurke raffeln und ausdrücken.', 'Mit Joghurt mischen.', 'Knoblauch pressen und unterrühren.', 'Mit Dill, Öl, Salz abschmecken.', '30 Min. kühlen.'],
  },
  {
    'vegetable': 'Gurken',
    'title': 'Gurkensalat mit Dill',
    'description': 'Klassischer Sommersalat.',
    'prep_time_min': 10, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'salad',
    'tags': ['schnell', 'vegan', 'gesund'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [
      {'item': 'Gurken', 'amount': 2, 'unit': 'Stück'},
      {'item': 'Weissweinessig', 'amount': 3, 'unit': 'EL'},
      {'item': 'Rapsöl', 'amount': 2, 'unit': 'EL'},
      {'item': 'Dill', 'amount': 3, 'unit': 'EL'},
      {'item': 'Zucker', 'amount': 1, 'unit': 'TL'},
    ],
    'steps': ['Gurken in dünne Scheiben hobeln.', 'Leicht salzen und 10 Min. ziehen lassen.', 'Dressing aus Essig, Öl, Zucker anrühren.', 'Mit Gurken und Dill mischen.'],
  },
  {
    'vegetable': 'Gurken',
    'title': 'Kalte Gurkensuppe',
    'description': 'Erfrischend an heissen Sommertagen.',
    'prep_time_min': 15, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'soup',
    'tags': ['schnell', 'gesund'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [
      {'item': 'Gurken', 'amount': 2, 'unit': 'Stück'},
      {'item': 'Naturjoghurt', 'amount': 300, 'unit': 'g'},
      {'item': 'Knoblauch', 'amount': 1, 'unit': 'Zehe'},
      {'item': 'Minze', 'amount': 2, 'unit': 'EL'},
      {'item': 'Zitronensaft', 'amount': 2, 'unit': 'EL'},
    ],
    'steps': ['Gurken schälen und grob würfeln.', 'Mit Joghurt und Knoblauch pürieren.', 'Zitrone und Minze unterrühren.', 'Kalt stellen und servieren.'],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // KEFEN
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Kefen',
    'title': 'Kefen aus dem Wok',
    'description': 'Knackig mit Sesam.',
    'prep_time_min': 5, 'cook_time_min': 5, 'servings': 4, 'difficulty': 'easy', 'category': 'side',
    'tags': ['schnell', 'vegan', 'gesund'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [
      {'item': 'Kefen', 'amount': 300, 'unit': 'g'},
      {'item': 'Sesamöl', 'amount': 1, 'unit': 'EL'},
      {'item': 'Sojasauce', 'amount': 1, 'unit': 'EL'},
      {'item': 'Sesam', 'amount': 1, 'unit': 'EL'},
      {'item': 'Knoblauch', 'amount': 1, 'unit': 'Zehe'},
    ],
    'steps': ['Kefen waschen und Enden entfernen.', 'Öl im Wok erhitzen.', 'Kefen 2-3 Min. pfannenrühren.', 'Knoblauch und Sojasauce beigeben.', 'Mit Sesam bestreuen.'],
  },
  {
    'vegetable': 'Kefen',
    'title': 'Kefen-Karotten-Gemüse',
    'description': 'Bunte Beilage.',
    'prep_time_min': 10, 'cook_time_min': 8, 'servings': 4, 'difficulty': 'easy', 'category': 'side',
    'tags': ['schnell', 'gesund', 'vegan'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [
      {'item': 'Kefen', 'amount': 200, 'unit': 'g'},
      {'item': 'Karotten', 'amount': 2, 'unit': 'Stück'},
      {'item': 'Ingwer', 'amount': 1, 'unit': 'TL'},
      {'item': 'Rapsöl', 'amount': 2, 'unit': 'EL'},
      {'item': 'Honig', 'amount': 1, 'unit': 'TL'},
    ],
    'steps': ['Karotten in Stifte schneiden.', 'In Öl 3 Min. anbraten.', 'Kefen beigeben.', 'Mit Ingwer und Honig würzen.', 'Weitere 3 Min. garen.'],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // KNOLLENSELLERIE
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Knollensellerie',
    'title': 'Selleriepüree',
    'description': 'Cremige Low-Carb Alternative zu Kartoffelstock.',
    'prep_time_min': 10, 'cook_time_min': 20, 'servings': 4, 'difficulty': 'easy', 'category': 'side',
    'tags': ['low-carb', 'comfort-food'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [
      {'item': 'Knollensellerie', 'amount': 600, 'unit': 'g'},
      {'item': 'Butter', 'amount': 50, 'unit': 'g'},
      {'item': 'Rahm', 'amount': 100, 'unit': 'ml'},
      {'item': 'Muskatnuss', 'amount': 1, 'unit': 'Prise'},
    ],
    'steps': ['Sellerie schälen und würfeln.', 'In Salzwasser 15 Min. kochen.', 'Abgiessen und pürier.', 'Butter und Rahm unterrühren.', 'Mit Muskat würzen.'],
  },
  {
    'vegetable': 'Knollensellerie',
    'title': 'Sellerieschnitzel',
    'description': 'Vegetarische Alternative zum Wiener Schnitzel.',
    'prep_time_min': 15, 'cook_time_min': 15, 'servings': 4, 'difficulty': 'easy', 'category': 'main',
    'tags': ['comfort-food'], 'is_vegetarian': true, 'contains_gluten': true, 'contains_eggs': true,
    'ingredients': [
      {'item': 'Knollensellerie', 'amount': 1, 'unit': 'Stück', 'note': 'gross'},
      {'item': 'Mehl', 'amount': 50, 'unit': 'g'},
      {'item': 'Eier', 'amount': 2, 'unit': 'Stück'},
      {'item': 'Paniermehl', 'amount': 100, 'unit': 'g'},
      {'item': 'Butter', 'amount': 50, 'unit': 'g'},
    ],
    'steps': ['Sellerie in 1cm Scheiben schneiden.', 'In Salzwasser 10 Min. vorkochen.', 'Abtropfen lassen.', 'Mehl, Ei, Paniermehl panieren.', 'In Butter goldbraun braten.'],
  },
  {
    'vegetable': 'Knollensellerie',
    'title': 'Waldorfsalat',
    'description': 'Amerikanischer Klassiker.',
    'prep_time_min': 20, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'salad',
    'tags': ['party'], 'is_vegetarian': true, 'contains_lactose': true, 'contains_nuts': true,
    'ingredients': [
      {'item': 'Knollensellerie', 'amount': 200, 'unit': 'g'},
      {'item': 'Äpfel', 'amount': 2, 'unit': 'Stück'},
      {'item': 'Baumnüsse', 'amount': 50, 'unit': 'g'},
      {'item': 'Mayonnaise', 'amount': 4, 'unit': 'EL'},
      {'item': 'Joghurt', 'amount': 2, 'unit': 'EL'},
      {'item': 'Zitronensaft', 'amount': 1, 'unit': 'EL'},
    ],
    'steps': ['Sellerie und Äpfel in Julienne schneiden.', 'Mit Zitronensaft mischen.', 'Mayonnaise mit Joghurt verrühren.', 'Alles vermengen.', 'Baumnüsse darüberstreuen.'],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // KOHLRABI
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Kohlrabi',
    'title': 'Kohlrabi-Pommes',
    'description': 'Gesunde Alternative zu Pommes Frites.',
    'prep_time_min': 10, 'cook_time_min': 25, 'servings': 4, 'difficulty': 'easy', 'category': 'side',
    'tags': ['gesund', 'kinderfreundlich'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [
      {'item': 'Kohlrabi', 'amount': 2, 'unit': 'Stück'},
      {'item': 'Olivenöl', 'amount': 2, 'unit': 'EL'},
      {'item': 'Paprikapulver', 'amount': 1, 'unit': 'TL'},
      {'item': 'Salz', 'amount': 0.5, 'unit': 'TL'},
    ],
    'steps': ['Ofen auf 200°C vorheizen.', 'Kohlrabi schälen und in Stifte schneiden.', 'Mit Öl und Gewürzen mischen.', 'Auf Backblech verteilen.', '20-25 Min. knusprig backen.'],
  },
  {
    'vegetable': 'Kohlrabi',
    'title': 'Kohlrabi-Carpaccio',
    'description': 'Hauchzart mit Zitronen-Dressing.',
    'prep_time_min': 15, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'salad',
    'tags': ['gesund', 'vegan'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [
      {'item': 'Kohlrabi', 'amount': 2, 'unit': 'Stück'},
      {'item': 'Zitronensaft', 'amount': 2, 'unit': 'EL'},
      {'item': 'Olivenöl', 'amount': 3, 'unit': 'EL'},
      {'item': 'Kresse', 'amount': 1, 'unit': 'Schale'},
    ],
    'steps': ['Kohlrabi schälen.', 'Mit Mandoline hauchdünn hobeln.', 'Auf Tellern anrichten.', 'Mit Zitrone und Öl beträufeln.', 'Mit Kresse garnieren.'],
  },
  {
    'vegetable': 'Kohlrabi',
    'title': 'Kohlrabi-Auflauf',
    'description': 'Cremig überbacken.',
    'prep_time_min': 15, 'cook_time_min': 30, 'servings': 4, 'difficulty': 'easy', 'category': 'main',
    'tags': ['comfort-food'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [
      {'item': 'Kohlrabi', 'amount': 3, 'unit': 'Stück'},
      {'item': 'Rahm', 'amount': 200, 'unit': 'ml'},
      {'item': 'Gruyère', 'amount': 100, 'unit': 'g'},
      {'item': 'Muskatnuss', 'amount': 1, 'unit': 'Prise'},
    ],
    'steps': ['Kohlrabi schälen und in Scheiben schneiden.', '10 Min. blanchieren.', 'In Auflaufform schichten.', 'Mit Rahm übergiessen.', 'Mit Käse bestreuen.', '25 Min. bei 180°C backen.'],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // PAK-CHOI
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Pak-Choi',
    'title': 'Gebratener Pak-Choi',
    'description': 'Asiatisch mit Knoblauch und Ingwer.',
    'prep_time_min': 5, 'cook_time_min': 5, 'servings': 4, 'difficulty': 'easy', 'category': 'side',
    'tags': ['schnell', 'vegan', 'gesund'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [
      {'item': 'Pak-Choi', 'amount': 400, 'unit': 'g'},
      {'item': 'Knoblauch', 'amount': 3, 'unit': 'Zehen'},
      {'item': 'Ingwer', 'amount': 1, 'unit': 'EL'},
      {'item': 'Sesamöl', 'amount': 1, 'unit': 'EL'},
      {'item': 'Sojasauce', 'amount': 2, 'unit': 'EL'},
    ],
    'steps': ['Pak-Choi halbieren und waschen.', 'Öl im Wok erhitzen.', 'Pak-Choi 2 Min. anbraten.', 'Knoblauch und Ingwer beigeben.', 'Mit Sojasauce ablöschen.'],
  },
  {
    'vegetable': 'Pak-Choi',
    'title': 'Pak-Choi mit Shiitake',
    'description': 'Umami-reiches Gemüsegericht.',
    'prep_time_min': 10, 'cook_time_min': 10, 'servings': 4, 'difficulty': 'easy', 'category': 'side',
    'tags': ['vegan', 'gesund'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [
      {'item': 'Pak-Choi', 'amount': 300, 'unit': 'g'},
      {'item': 'Shiitake-Pilze', 'amount': 150, 'unit': 'g'},
      {'item': 'Knoblauch', 'amount': 2, 'unit': 'Zehen'},
      {'item': 'Austersauce', 'amount': 2, 'unit': 'EL'},
      {'item': 'Sesamöl', 'amount': 1, 'unit': 'EL'},
    ],
    'steps': ['Pilze in Scheiben schneiden.', 'Pak-Choi vierteln.', 'Pilze anbraten bis goldbraun.', 'Pak-Choi und Knoblauch beigeben.', 'Mit Austersauce würzen.'],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // PASTINAKE
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Pastinake',
    'title': 'Pastinaken-Püree',
    'description': 'Süsslich-nussig, perfekt zu Wild.',
    'prep_time_min': 10, 'cook_time_min': 20, 'servings': 4, 'difficulty': 'easy', 'category': 'side',
    'tags': ['comfort-food'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [
      {'item': 'Pastinaken', 'amount': 500, 'unit': 'g'},
      {'item': 'Butter', 'amount': 40, 'unit': 'g'},
      {'item': 'Rahm', 'amount': 100, 'unit': 'ml'},
      {'item': 'Muskatnuss', 'amount': 1, 'unit': 'Prise'},
    ],
    'steps': ['Pastinaken schälen und würfeln.', 'In Salzwasser weich kochen.', 'Abgiessen und pürieren.', 'Butter und Rahm unterheben.', 'Mit Muskat abschmecken.'],
  },
  {
    'vegetable': 'Pastinake',
    'title': 'Pastinaken-Chips',
    'description': 'Knuspriger Snack.',
    'prep_time_min': 10, 'cook_time_min': 20, 'servings': 4, 'difficulty': 'easy', 'category': 'snack',
    'tags': ['gesund', 'vegan'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [
      {'item': 'Pastinaken', 'amount': 400, 'unit': 'g'},
      {'item': 'Olivenöl', 'amount': 2, 'unit': 'EL'},
      {'item': 'Salz', 'amount': 0.5, 'unit': 'TL'},
      {'item': 'Rosmarin', 'amount': 1, 'unit': 'TL'},
    ],
    'steps': ['Ofen auf 180°C vorheizen.', 'Pastinaken dünn hobeln.', 'Mit Öl und Gewürzen mischen.', 'Auf Backblech ausbreiten.', '15-20 Min. knusprig backen.'],
  },
  {
    'vegetable': 'Pastinake',
    'title': 'Pastinaken-Suppe',
    'description': 'Wärmende Wintersuppe.',
    'prep_time_min': 10, 'cook_time_min': 25, 'servings': 4, 'difficulty': 'easy', 'category': 'soup',
    'tags': ['comfort-food', 'gesund'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [
      {'item': 'Pastinaken', 'amount': 500, 'unit': 'g'},
      {'item': 'Kartoffeln', 'amount': 200, 'unit': 'g'},
      {'item': 'Zwiebel', 'amount': 1, 'unit': 'Stück'},
      {'item': 'Gemüsebouillon', 'amount': 800, 'unit': 'ml'},
      {'item': 'Rahm', 'amount': 100, 'unit': 'ml'},
    ],
    'steps': ['Gemüse würfeln und andünsten.', 'Mit Bouillon ablöschen.', '20 Min. köcheln.', 'Fein pürieren.', 'Rahm unterziehen.'],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // PEPERONI
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Peperoni',
    'title': 'Gefüllte Peperoni',
    'description': 'Mediterran mit Reis und Kräutern.',
    'prep_time_min': 25, 'cook_time_min': 35, 'servings': 4, 'difficulty': 'medium', 'category': 'main',
    'tags': ['meal-prep'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [
      {'item': 'Peperoni', 'amount': 4, 'unit': 'Stück', 'note': 'gross'},
      {'item': 'Reis', 'amount': 150, 'unit': 'g'},
      {'item': 'Feta', 'amount': 100, 'unit': 'g'},
      {'item': 'Tomaten', 'amount': 2, 'unit': 'Stück'},
      {'item': 'Oregano', 'amount': 1, 'unit': 'TL'},
    ],
    'steps': ['Reis kochen.', 'Peperoni-Deckel abschneiden, entkernen.', 'Reis mit Feta und Tomaten mischen.', 'Peperoni füllen.', '30 Min. bei 180°C backen.'],
  },
  {
    'vegetable': 'Peperoni',
    'title': 'Peperonata',
    'description': 'Italienisches Schmorgericht.',
    'prep_time_min': 15, 'cook_time_min': 30, 'servings': 4, 'difficulty': 'easy', 'category': 'side',
    'tags': ['vegan', 'mediterran'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [
      {'item': 'Peperoni', 'amount': 4, 'unit': 'Stück', 'note': 'verschiedene Farben'},
      {'item': 'Zwiebeln', 'amount': 2, 'unit': 'Stück'},
      {'item': 'Knoblauch', 'amount': 3, 'unit': 'Zehen'},
      {'item': 'Tomaten', 'amount': 400, 'unit': 'g'},
      {'item': 'Olivenöl', 'amount': 4, 'unit': 'EL'},
    ],
    'steps': ['Peperoni in Streifen schneiden.', 'Zwiebeln und Knoblauch andünsten.', 'Peperoni beigeben und 10 Min. braten.', 'Tomaten zugeben.', '20 Min. schmoren.'],
  },
  {
    'vegetable': 'Peperoni',
    'title': 'Gegrillte Peperoni',
    'description': 'Rauchig und süss.',
    'prep_time_min': 5, 'cook_time_min': 15, 'servings': 4, 'difficulty': 'easy', 'category': 'side',
    'tags': ['vegan', 'party'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [
      {'item': 'Peperoni', 'amount': 4, 'unit': 'Stück'},
      {'item': 'Olivenöl', 'amount': 2, 'unit': 'EL'},
      {'item': 'Balsamico', 'amount': 1, 'unit': 'EL'},
      {'item': 'Basilikum', 'amount': 1, 'unit': 'Bund'},
    ],
    'steps': ['Peperoni ganz unter dem Grill rösten bis schwarz.', 'In Papiertüte 10 Min. schwitzen lassen.', 'Haut abziehen, entkernen.', 'In Streifen schneiden.', 'Mit Öl und Balsamico marinieren.'],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // RADIESCHEN
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Radieschen',
    'title': 'Radieschensalat',
    'description': 'Knackig und erfrischend.',
    'prep_time_min': 10, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'salad',
    'tags': ['schnell', 'gesund', 'vegan'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [
      {'item': 'Radieschen', 'amount': 2, 'unit': 'Bund'},
      {'item': 'Apfelessig', 'amount': 2, 'unit': 'EL'},
      {'item': 'Rapsöl', 'amount': 3, 'unit': 'EL'},
      {'item': 'Schnittlauch', 'amount': 2, 'unit': 'EL'},
    ],
    'steps': ['Radieschen in dünne Scheiben schneiden.', 'Dressing aus Essig und Öl anrühren.', 'Mit Radieschen mischen.', 'Mit Schnittlauch bestreuen.'],
  },
  {
    'vegetable': 'Radieschen',
    'title': 'Radieschen-Butter',
    'description': 'Perfekt auf frischem Brot.',
    'prep_time_min': 10, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'snack',
    'tags': ['schnell', 'party'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [
      {'item': 'Radieschen', 'amount': 1, 'unit': 'Bund'},
      {'item': 'Butter', 'amount': 100, 'unit': 'g', 'note': 'weich'},
      {'item': 'Schnittlauch', 'amount': 2, 'unit': 'EL'},
      {'item': 'Fleur de Sel', 'amount': 0.5, 'unit': 'TL'},
    ],
    'steps': ['Radieschen fein würfeln.', 'Mit weicher Butter mischen.', 'Schnittlauch unterheben.', 'Mit Salz abschmecken.', 'Kalt stellen.'],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // RETTICH
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Rettich',
    'title': 'Bayrischer Rettichsalat',
    'description': 'Würzig mit Essig-Öl-Dressing.',
    'prep_time_min': 15, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'salad',
    'tags': ['schnell'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [
      {'item': 'Rettich', 'amount': 1, 'unit': 'Stück', 'note': 'gross'},
      {'item': 'Weissweinessig', 'amount': 3, 'unit': 'EL'},
      {'item': 'Rapsöl', 'amount': 4, 'unit': 'EL'},
      {'item': 'Kümmel', 'amount': 0.5, 'unit': 'TL'},
      {'item': 'Schnittlauch', 'amount': 2, 'unit': 'EL'},
    ],
    'steps': ['Rettich schälen und in dünne Scheiben hobeln.', 'Salzen und 15 Min. ziehen lassen.', 'Flüssigkeit abgiessen.', 'Mit Essig, Öl und Kümmel anmachen.', 'Mit Schnittlauch servieren.'],
  },
  {
    'vegetable': 'Rettich',
    'title': 'Rettich-Suppe',
    'description': 'Leicht scharf und wärmend.',
    'prep_time_min': 10, 'cook_time_min': 20, 'servings': 4, 'difficulty': 'easy', 'category': 'soup',
    'tags': ['gesund'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [
      {'item': 'Rettich', 'amount': 400, 'unit': 'g'},
      {'item': 'Kartoffeln', 'amount': 200, 'unit': 'g'},
      {'item': 'Gemüsebouillon', 'amount': 800, 'unit': 'ml'},
      {'item': 'Rahm', 'amount': 100, 'unit': 'ml'},
    ],
    'steps': ['Rettich und Kartoffeln würfeln.', 'In Bouillon 15 Min. kochen.', 'Fein pürieren.', 'Rahm unterziehen.', 'Mit Salz und Pfeffer abschmecken.'],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // SCHWARZWURZEL
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Schwarzwurzel',
    'title': 'Schwarzwurzeln in Rahmsauce',
    'description': 'Klassische Zubereitung des Winterspargels.',
    'prep_time_min': 20, 'cook_time_min': 25, 'servings': 4, 'difficulty': 'medium', 'category': 'side',
    'tags': ['comfort-food'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [
      {'item': 'Schwarzwurzeln', 'amount': 600, 'unit': 'g'},
      {'item': 'Zitronensaft', 'amount': 2, 'unit': 'EL'},
      {'item': 'Rahm', 'amount': 200, 'unit': 'ml'},
      {'item': 'Butter', 'amount': 30, 'unit': 'g'},
      {'item': 'Petersilie', 'amount': 2, 'unit': 'EL'},
    ],
    'steps': ['Schwarzwurzeln unter Wasser schälen.', 'Sofort in Zitronenwasser legen.', 'In Salzwasser 15-20 Min. kochen.', 'Rahm mit Butter erwärmen.', 'Schwarzwurzeln damit übergiessen.'],
  },
  {
    'vegetable': 'Schwarzwurzel',
    'title': 'Gratinierte Schwarzwurzeln',
    'description': 'Mit würziger Käsekruste.',
    'prep_time_min': 25, 'cook_time_min': 25, 'servings': 4, 'difficulty': 'medium', 'category': 'side',
    'tags': ['comfort-food'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [
      {'item': 'Schwarzwurzeln', 'amount': 500, 'unit': 'g'},
      {'item': 'Gruyère', 'amount': 100, 'unit': 'g'},
      {'item': 'Rahm', 'amount': 150, 'unit': 'ml'},
      {'item': 'Muskatnuss', 'amount': 1, 'unit': 'Prise'},
    ],
    'steps': ['Schwarzwurzeln schälen und vorkochen.', 'In Auflaufform legen.', 'Mit Rahm übergiessen.', 'Käse darüberstreuen.', '20 Min. bei 200°C überbacken.'],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // STANGENSELLERIE
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Stangensellerie',
    'title': 'Sellerie-Sticks mit Dip',
    'description': 'Gesunder Snack.',
    'prep_time_min': 10, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'snack',
    'tags': ['schnell', 'gesund'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [
      {'item': 'Stangensellerie', 'amount': 1, 'unit': 'Bund'},
      {'item': 'Frischkäse', 'amount': 150, 'unit': 'g'},
      {'item': 'Schnittlauch', 'amount': 2, 'unit': 'EL'},
      {'item': 'Salz und Pfeffer', 'note': 'nach Geschmack'},
    ],
    'steps': ['Selleriestangen waschen und in Sticks schneiden.', 'Frischkäse mit Schnittlauch mischen.', 'Mit Salz und Pfeffer würzen.', 'Als Dip servieren.'],
  },
  {
    'vegetable': 'Stangensellerie',
    'title': 'Geschmorter Stangensellerie',
    'description': 'Zart und aromatisch.',
    'prep_time_min': 10, 'cook_time_min': 25, 'servings': 4, 'difficulty': 'easy', 'category': 'side',
    'tags': ['comfort-food'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [
      {'item': 'Stangensellerie', 'amount': 400, 'unit': 'g'},
      {'item': 'Butter', 'amount': 40, 'unit': 'g'},
      {'item': 'Gemüsebouillon', 'amount': 200, 'unit': 'ml'},
      {'item': 'Thymian', 'amount': 2, 'unit': 'Zweige'},
    ],
    'steps': ['Sellerie in 5cm Stücke schneiden.', 'In Butter andünsten.', 'Mit Bouillon ablöschen.', 'Thymian beigeben.', '20 Min. zugedeckt schmoren.'],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // SÜSSKARTOFFEL
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Süsskartoffel',
    'title': 'Süsskartoffel-Pommes',
    'description': 'Knusprig und süsslich.',
    'prep_time_min': 10, 'cook_time_min': 30, 'servings': 4, 'difficulty': 'easy', 'category': 'side',
    'tags': ['kinderfreundlich', 'vegan'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [
      {'item': 'Süsskartoffeln', 'amount': 600, 'unit': 'g'},
      {'item': 'Olivenöl', 'amount': 3, 'unit': 'EL'},
      {'item': 'Paprikapulver', 'amount': 1, 'unit': 'TL'},
      {'item': 'Salz', 'amount': 0.5, 'unit': 'TL'},
    ],
    'steps': ['Ofen auf 200°C vorheizen.', 'Süsskartoffeln in Stifte schneiden.', 'Mit Öl und Gewürzen mischen.', 'Auf Backblech verteilen.', '25-30 Min. knusprig backen.'],
  },
  {
    'vegetable': 'Süsskartoffel',
    'title': 'Gefüllte Süsskartoffel',
    'description': 'Mit schwarzen Bohnen und Avocado.',
    'prep_time_min': 10, 'cook_time_min': 45, 'servings': 4, 'difficulty': 'easy', 'category': 'main',
    'tags': ['vegan', 'gesund'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [
      {'item': 'Süsskartoffeln', 'amount': 4, 'unit': 'Stück', 'note': 'gross'},
      {'item': 'Schwarze Bohnen', 'amount': 200, 'unit': 'g'},
      {'item': 'Avocado', 'amount': 1, 'unit': 'Stück'},
      {'item': 'Limettensaft', 'amount': 2, 'unit': 'EL'},
      {'item': 'Koriander', 'amount': 2, 'unit': 'EL'},
    ],
    'steps': ['Süsskartoffeln bei 200°C 45 Min. backen.', 'Bohnen erwärmen und würzen.', 'Avocado zerdrücken mit Limette.', 'Süsskartoffeln aufschneiden.', 'Mit Bohnen und Avocado füllen.'],
  },
  {
    'vegetable': 'Süsskartoffel',
    'title': 'Süsskartoffel-Curry',
    'description': 'Cremig mit Kokosmilch.',
    'prep_time_min': 15, 'cook_time_min': 25, 'servings': 4, 'difficulty': 'easy', 'category': 'main',
    'tags': ['vegan', 'comfort-food'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [
      {'item': 'Süsskartoffeln', 'amount': 500, 'unit': 'g'},
      {'item': 'Kokosmilch', 'amount': 400, 'unit': 'ml'},
      {'item': 'Currypaste', 'amount': 2, 'unit': 'EL'},
      {'item': 'Spinat', 'amount': 100, 'unit': 'g'},
      {'item': 'Zwiebel', 'amount': 1, 'unit': 'Stück'},
    ],
    'steps': ['Süsskartoffeln würfeln.', 'Zwiebel mit Currypaste andünsten.', 'Süsskartoffeln beigeben.', 'Mit Kokosmilch ablöschen.', '20 Min. köcheln.', 'Spinat unterheben.'],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // ZUCKERMAIS
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Zuckermais',
    'title': 'Maiskolben mit Kräuterbutter',
    'description': 'Sommerlicher Klassiker vom Grill.',
    'prep_time_min': 10, 'cook_time_min': 15, 'servings': 4, 'difficulty': 'easy', 'category': 'side',
    'tags': ['party', 'kinderfreundlich'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [
      {'item': 'Maiskolben', 'amount': 4, 'unit': 'Stück'},
      {'item': 'Butter', 'amount': 100, 'unit': 'g'},
      {'item': 'Petersilie', 'amount': 2, 'unit': 'EL'},
      {'item': 'Knoblauch', 'amount': 1, 'unit': 'Zehe'},
      {'item': 'Fleur de Sel', 'note': 'zum Servieren'},
    ],
    'steps': ['Maiskolben 10 Min. kochen.', 'Butter mit Petersilie und Knoblauch mischen.', 'Mais vom Grill oder in Pfanne kurz anbraten.', 'Mit Kräuterbutter bestreichen.', 'Mit Salz servieren.'],
  },
  {
    'vegetable': 'Zuckermais',
    'title': 'Maissalat',
    'description': 'Bunter Sommersalat.',
    'prep_time_min': 15, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'salad',
    'tags': ['schnell', 'party'], 'is_vegetarian': true,
    'ingredients': [
      {'item': 'Maiskörner', 'amount': 300, 'unit': 'g'},
      {'item': 'Peperoni', 'amount': 1, 'unit': 'Stück'},
      {'item': 'Frühlingszwiebeln', 'amount': 3, 'unit': 'Stück'},
      {'item': 'Mayonnaise', 'amount': 3, 'unit': 'EL'},
      {'item': 'Limettensaft', 'amount': 2, 'unit': 'EL'},
    ],
    'steps': ['Mais abtropfen lassen.', 'Peperoni und Frühlingszwiebeln kleinschneiden.', 'Alles mit Mayonnaise und Limette mischen.', 'Mit Salz und Pfeffer abschmecken.'],
  },
  {
    'vegetable': 'Zuckermais',
    'title': 'Maissuppe',
    'description': 'Cremig und süsslich.',
    'prep_time_min': 10, 'cook_time_min': 20, 'servings': 4, 'difficulty': 'easy', 'category': 'soup',
    'tags': ['comfort-food'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [
      {'item': 'Maiskörner', 'amount': 400, 'unit': 'g'},
      {'item': 'Kartoffeln', 'amount': 200, 'unit': 'g'},
      {'item': 'Gemüsebouillon', 'amount': 600, 'unit': 'ml'},
      {'item': 'Rahm', 'amount': 100, 'unit': 'ml'},
      {'item': 'Zwiebel', 'amount': 1, 'unit': 'Stück'},
    ],
    'steps': ['Zwiebel andünsten.', 'Kartoffeln würfeln und beigeben.', 'Mit Bouillon ablöschen.', 'Mais beigeben und 15 Min. köcheln.', 'Teilweise pürieren.', 'Rahm unterrühren.'],
  },
];

// Recipe Data Part 3: Fruits (Aprikosen to Kirschen)

final recipesPartThree = <Map<String, dynamic>>[
  // APRIKOSEN
  {'vegetable': 'Aprikosen', 'title': 'Aprikosenwähe', 'description': 'Sommerliche Früchtewähe.', 'prep_time_min': 20, 'cook_time_min': 35, 'servings': 8, 'difficulty': 'medium', 'category': 'dessert', 'tags': ['party'], 'is_vegetarian': true, 'contains_gluten': true, 'contains_lactose': true, 'contains_eggs': true,
    'ingredients': [{'item': 'Kuchenteig', 'amount': 1, 'unit': 'Stück'}, {'item': 'Aprikosen', 'amount': 600, 'unit': 'g'}, {'item': 'Eier', 'amount': 2, 'unit': 'Stück'}, {'item': 'Rahm', 'amount': 150, 'unit': 'ml'}, {'item': 'Zucker', 'amount': 60, 'unit': 'g'}],
    'steps': ['Teig in Form legen.', 'Aprikosen halbieren und entsteinen.', 'Auf Teig verteilen.', 'Eier mit Rahm und Zucker verquirlen.', 'Darübergiessen.', '30-35 Min. bei 200°C backen.']},
  {'vegetable': 'Aprikosen', 'title': 'Aprikosen-Chutney', 'description': 'Würzig-süss zu Käse.', 'prep_time_min': 15, 'cook_time_min': 30, 'servings': 6, 'difficulty': 'easy', 'category': 'snack', 'tags': ['meal-prep', 'party'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Aprikosen', 'amount': 500, 'unit': 'g'}, {'item': 'Zwiebel', 'amount': 1, 'unit': 'Stück'}, {'item': 'Ingwer', 'amount': 20, 'unit': 'g'}, {'item': 'Apfelessig', 'amount': 100, 'unit': 'ml'}, {'item': 'Zucker', 'amount': 100, 'unit': 'g'}],
    'steps': ['Aprikosen und Zwiebel würfeln.', 'Mit allen Zutaten aufkochen.', '25 Min. einköcheln.', 'Heiss in Gläser füllen.']},
  {'vegetable': 'Aprikosen', 'title': 'Gegrillte Aprikosen', 'description': 'Mit Vanilleglace.', 'prep_time_min': 5, 'cook_time_min': 5, 'servings': 4, 'difficulty': 'easy', 'category': 'dessert', 'tags': ['schnell', 'party'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [{'item': 'Aprikosen', 'amount': 8, 'unit': 'Stück'}, {'item': 'Butter', 'amount': 20, 'unit': 'g'}, {'item': 'Honig', 'amount': 2, 'unit': 'EL'}, {'item': 'Vanilleglace', 'amount': 4, 'unit': 'Kugeln'}],
    'steps': ['Aprikosen halbieren.', 'Schnittfläche mit Butter bestreichen.', '3-4 Min. grillieren.', 'Mit Honig beträufeln.', 'Mit Glace servieren.']},

  // BIRNEN
  {'vegetable': 'Birnen Herbst', 'title': 'Birnenwähe', 'description': 'Herbstliche Früchtewähe.', 'prep_time_min': 20, 'cook_time_min': 35, 'servings': 8, 'difficulty': 'medium', 'category': 'dessert', 'tags': ['schweizer-klassiker'], 'is_vegetarian': true, 'contains_gluten': true, 'contains_lactose': true, 'contains_eggs': true,
    'ingredients': [{'item': 'Kuchenteig', 'amount': 1, 'unit': 'Stück'}, {'item': 'Birnen', 'amount': 4, 'unit': 'Stück'}, {'item': 'Eier', 'amount': 2, 'unit': 'Stück'}, {'item': 'Rahm', 'amount': 150, 'unit': 'ml'}, {'item': 'Zucker', 'amount': 60, 'unit': 'g'}],
    'steps': ['Teig in Form auslegen.', 'Birnen in Spalten schneiden.', 'Auf Teig anordnen.', 'Guss darübergiessen.', '35 Min. backen.']},
  {'vegetable': 'Birnen Herbst', 'title': 'Birnen-Roquefort-Salat', 'description': 'Elegante Vorspeise.', 'prep_time_min': 15, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'salad', 'tags': ['party'], 'is_vegetarian': true, 'contains_lactose': true, 'contains_nuts': true,
    'ingredients': [{'item': 'Birnen', 'amount': 2, 'unit': 'Stück'}, {'item': 'Roquefort', 'amount': 100, 'unit': 'g'}, {'item': 'Nüsslisalat', 'amount': 100, 'unit': 'g'}, {'item': 'Baumnüsse', 'amount': 50, 'unit': 'g'}, {'item': 'Balsamico', 'amount': 2, 'unit': 'EL'}],
    'steps': ['Birnen in Spalten schneiden.', 'Salat auf Tellern verteilen.', 'Mit Birnen und zerbröckeltem Käse belegen.', 'Nüsse darüberstreuen.', 'Mit Balsamico beträufeln.']},
  {'vegetable': 'Birnen Lager', 'title': 'Pochierte Birnen', 'description': 'In Rotwein gegart.', 'prep_time_min': 10, 'cook_time_min': 30, 'servings': 4, 'difficulty': 'easy', 'category': 'dessert', 'tags': ['comfort-food'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Birnen', 'amount': 4, 'unit': 'Stück'}, {'item': 'Rotwein', 'amount': 500, 'unit': 'ml'}, {'item': 'Zucker', 'amount': 100, 'unit': 'g'}, {'item': 'Zimtstange', 'amount': 1, 'unit': 'Stück'}, {'item': 'Orangenschale', 'amount': 1, 'unit': 'Stück'}],
    'steps': ['Birnen schälen, Stiel dran lassen.', 'Wein mit Zucker und Gewürzen aufkochen.', 'Birnen beigeben.', '25-30 Min. sanft köcheln.', 'In Sud abkühlen lassen.']},

  // BROMBEEREN
  {'vegetable': 'Brombeeren', 'title': 'Brombeer-Crumble', 'description': 'Heiss aus dem Ofen.', 'prep_time_min': 15, 'cook_time_min': 30, 'servings': 6, 'difficulty': 'easy', 'category': 'dessert', 'tags': ['comfort-food'], 'is_vegetarian': true, 'contains_gluten': true, 'contains_lactose': true,
    'ingredients': [{'item': 'Brombeeren', 'amount': 400, 'unit': 'g'}, {'item': 'Mehl', 'amount': 100, 'unit': 'g'}, {'item': 'Butter', 'amount': 80, 'unit': 'g'}, {'item': 'Zucker', 'amount': 80, 'unit': 'g'}, {'item': 'Haferflocken', 'amount': 50, 'unit': 'g'}],
    'steps': ['Brombeeren in Auflaufform geben.', 'Mehl, Butter, Zucker zu Streuseln verarbeiten.', 'Haferflocken unterheben.', 'Über Brombeeren verteilen.', '25-30 Min. bei 180°C backen.']},
  {'vegetable': 'Brombeeren', 'title': 'Brombeer-Smoothie', 'description': 'Erfrischend und vitaminreich.', 'prep_time_min': 5, 'cook_time_min': 0, 'servings': 2, 'difficulty': 'easy', 'category': 'breakfast', 'tags': ['schnell', 'gesund'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [{'item': 'Brombeeren', 'amount': 150, 'unit': 'g'}, {'item': 'Joghurt', 'amount': 200, 'unit': 'g'}, {'item': 'Banane', 'amount': 1, 'unit': 'Stück'}, {'item': 'Honig', 'amount': 1, 'unit': 'EL'}],
    'steps': ['Alle Zutaten in Mixer geben.', 'Fein pürieren.', 'Sofort geniessen.']},

  // HEIDELBEEREN
  {'vegetable': 'Heidelbeeren', 'title': 'Heidelbeer-Muffins', 'description': 'Saftig und fruchtig.', 'prep_time_min': 15, 'cook_time_min': 25, 'servings': 12, 'difficulty': 'easy', 'category': 'dessert', 'tags': ['kinderfreundlich'], 'is_vegetarian': true, 'contains_gluten': true, 'contains_lactose': true, 'contains_eggs': true,
    'ingredients': [{'item': 'Heidelbeeren', 'amount': 150, 'unit': 'g'}, {'item': 'Mehl', 'amount': 250, 'unit': 'g'}, {'item': 'Zucker', 'amount': 120, 'unit': 'g'}, {'item': 'Eier', 'amount': 2, 'unit': 'Stück'}, {'item': 'Butter', 'amount': 100, 'unit': 'g'}, {'item': 'Milch', 'amount': 120, 'unit': 'ml'}],
    'steps': ['Trockene Zutaten mischen.', 'Butter schmelzen, mit Eiern und Milch verrühren.', 'Zum Mehl geben.', 'Heidelbeeren unterheben.', 'In Förmchen füllen.', '22-25 Min. bei 180°C backen.']},
  {'vegetable': 'Heidelbeeren', 'title': 'Heidelbeer-Pancakes', 'description': 'Amerikanisches Frühstück.', 'prep_time_min': 10, 'cook_time_min': 15, 'servings': 4, 'difficulty': 'easy', 'category': 'breakfast', 'tags': ['kinderfreundlich'], 'is_vegetarian': true, 'contains_gluten': true, 'contains_lactose': true, 'contains_eggs': true,
    'ingredients': [{'item': 'Mehl', 'amount': 200, 'unit': 'g'}, {'item': 'Milch', 'amount': 250, 'unit': 'ml'}, {'item': 'Ei', 'amount': 1, 'unit': 'Stück'}, {'item': 'Heidelbeeren', 'amount': 100, 'unit': 'g'}, {'item': 'Ahornsirup', 'amount': 4, 'unit': 'EL'}],
    'steps': ['Teig aus Mehl, Milch, Ei rühren.', 'In Butter goldbraun braten.', 'Heidelbeeren auf die rohe Seite streuen.', 'Wenden und fertig braten.', 'Mit Ahornsirup servieren.']},
  {'vegetable': 'Heidelbeeren', 'title': 'Heidelbeer-Joghurt', 'description': 'Gesundes Frühstück.', 'prep_time_min': 5, 'cook_time_min': 0, 'servings': 2, 'difficulty': 'easy', 'category': 'breakfast', 'tags': ['schnell', 'gesund'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [{'item': 'Heidelbeeren', 'amount': 150, 'unit': 'g'}, {'item': 'Naturjoghurt', 'amount': 400, 'unit': 'g'}, {'item': 'Honig', 'amount': 2, 'unit': 'EL'}, {'item': 'Granola', 'amount': 4, 'unit': 'EL'}],
    'steps': ['Joghurt in Schalen verteilen.', 'Heidelbeeren daraufgeben.', 'Mit Honig beträufeln.', 'Mit Granola bestreuen.']},

  // JOHANNISBEEREN
  {'vegetable': 'Johannisbeeren', 'title': 'Johannisbeer-Baiser-Torte', 'description': 'Säuerlich-süsses Meisterwerk.', 'prep_time_min': 30, 'cook_time_min': 25, 'servings': 10, 'difficulty': 'hard', 'category': 'dessert', 'tags': ['party'], 'is_vegetarian': true, 'contains_gluten': true, 'contains_lactose': true, 'contains_eggs': true,
    'ingredients': [{'item': 'Johannisbeeren', 'amount': 300, 'unit': 'g'}, {'item': 'Kuchenteig', 'amount': 1, 'unit': 'Stück'}, {'item': 'Eiweiss', 'amount': 3, 'unit': 'Stück'}, {'item': 'Zucker', 'amount': 150, 'unit': 'g'}, {'item': 'Puderzucker', 'amount': 50, 'unit': 'g'}],
    'steps': ['Teig vorbacken.', 'Johannisbeeren darauf verteilen.', 'Eiweiss steif schlagen, Zucker einrieseln.', 'Auf Beeren streichen.', '20 Min. bei 150°C backen.']},
  {'vegetable': 'Johannisbeeren', 'title': 'Johannisbeer-Gelee', 'description': 'Klassischer Brotaufstrich.', 'prep_time_min': 20, 'cook_time_min': 15, 'servings': 8, 'difficulty': 'medium', 'category': 'snack', 'tags': ['meal-prep'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Johannisbeeren', 'amount': 1000, 'unit': 'g'}, {'item': 'Gelierzucker', 'amount': 500, 'unit': 'g'}],
    'steps': ['Beeren waschen und entstielen.', 'Mit wenig Wasser weich kochen.', 'Durch Sieb passieren.', 'Mit Gelierzucker aufkochen.', '4 Min. sprudelnd kochen.', 'Heiss in Gläser füllen.']},

  // KIWI
  {'vegetable': 'Kiwi', 'title': 'Kiwi-Smoothie-Bowl', 'description': 'Grüne Vitaminbombe.', 'prep_time_min': 10, 'cook_time_min': 0, 'servings': 2, 'difficulty': 'easy', 'category': 'breakfast', 'tags': ['gesund', 'vegan'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Kiwi', 'amount': 3, 'unit': 'Stück'}, {'item': 'Banane', 'amount': 1, 'unit': 'Stück', 'note': 'gefroren'}, {'item': 'Spinat', 'amount': 50, 'unit': 'g'}, {'item': 'Pflanzenmilch', 'amount': 100, 'unit': 'ml'}, {'item': 'Granola', 'amount': 4, 'unit': 'EL'}],
    'steps': ['Kiwi, Banane, Spinat und Milch pürieren.', 'In Schalen füllen.', 'Mit Granola und Kiwischeiben toppen.']},
  {'vegetable': 'Kiwi', 'title': 'Kiwi-Sorbet', 'description': 'Erfrischend im Sommer.', 'prep_time_min': 15, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'dessert', 'tags': ['vegan', 'gesund'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Kiwi', 'amount': 6, 'unit': 'Stück'}, {'item': 'Zucker', 'amount': 80, 'unit': 'g'}, {'item': 'Limettensaft', 'amount': 2, 'unit': 'EL'}],
    'steps': ['Kiwi schälen und pürieren.', 'Zucker und Limette unterrühren.', 'In Eismaschine geben.', 'Oder 4 Std. gefrieren, zwischendurch rühren.']},

  // NEKTARINEN & PFIRSICHE
  {'vegetable': 'Nektarinen', 'title': 'Nektarinen-Caprese', 'description': 'Süss-salzige Kombination.', 'prep_time_min': 10, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'salad', 'tags': ['schnell', 'party'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [{'item': 'Nektarinen', 'amount': 3, 'unit': 'Stück'}, {'item': 'Mozzarella', 'amount': 200, 'unit': 'g'}, {'item': 'Basilikum', 'amount': 1, 'unit': 'Bund'}, {'item': 'Olivenöl', 'amount': 3, 'unit': 'EL'}, {'item': 'Balsamico', 'amount': 1, 'unit': 'EL'}],
    'steps': ['Nektarinen in Spalten schneiden.', 'Mozzarella in Scheiben.', 'Abwechselnd anrichten.', 'Mit Basilikum garnieren.', 'Mit Öl und Balsamico beträufeln.']},
  {'vegetable': 'Pfirsiche', 'title': 'Gegrillte Pfirsiche', 'description': 'Mit Ziegenkäse und Honig.', 'prep_time_min': 10, 'cook_time_min': 10, 'servings': 4, 'difficulty': 'easy', 'category': 'dessert', 'tags': ['party'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [{'item': 'Pfirsiche', 'amount': 4, 'unit': 'Stück'}, {'item': 'Ziegenfrischkäse', 'amount': 100, 'unit': 'g'}, {'item': 'Honig', 'amount': 3, 'unit': 'EL'}, {'item': 'Thymian', 'amount': 1, 'unit': 'TL'}],
    'steps': ['Pfirsiche halbieren und entsteinen.', 'Schnittfläche 3-4 Min. grillen.', 'Mit Ziegenkäse füllen.', 'Mit Honig und Thymian servieren.']},
  {'vegetable': 'Pfirsiche', 'title': 'Pfirsich-Eistee', 'description': 'Selbstgemacht und erfrischend.', 'prep_time_min': 10, 'cook_time_min': 10, 'servings': 6, 'difficulty': 'easy', 'category': 'snack', 'tags': ['party', 'gesund'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Pfirsiche', 'amount': 3, 'unit': 'Stück'}, {'item': 'Schwarztee', 'amount': 4, 'unit': 'Beutel'}, {'item': 'Honig', 'amount': 3, 'unit': 'EL'}, {'item': 'Zitrone', 'amount': 1, 'unit': 'Stück'}, {'item': 'Wasser', 'amount': 1, 'unit': 'l'}],
    'steps': ['Tee aufbrühen und abkühlen.', 'Pfirsiche pürieren.', 'Mit Tee, Honig und Zitronensaft mischen.', 'Kalt servieren mit Eiswürfeln.']},

  // PFLAUMEN
  {'vegetable': 'Pflaumen', 'title': 'Pflaumenkuchen', 'description': 'Saftiger Blechkuchen.', 'prep_time_min': 25, 'cook_time_min': 40, 'servings': 12, 'difficulty': 'medium', 'category': 'dessert', 'tags': ['party'], 'is_vegetarian': true, 'contains_gluten': true, 'contains_lactose': true, 'contains_eggs': true,
    'ingredients': [{'item': 'Pflaumen', 'amount': 800, 'unit': 'g'}, {'item': 'Mehl', 'amount': 300, 'unit': 'g'}, {'item': 'Butter', 'amount': 150, 'unit': 'g'}, {'item': 'Zucker', 'amount': 150, 'unit': 'g'}, {'item': 'Eier', 'amount': 3, 'unit': 'Stück'}],
    'steps': ['Hefeteig oder Rührteig zubereiten.', 'Auf Blech ausrollen.', 'Pflaumen halbieren, entsteinen.', 'Dicht auf Teig setzen.', 'Mit Zucker bestreuen.', '35-40 Min. bei 180°C backen.']},
  {'vegetable': 'Pflaumen', 'title': 'Pflaumenkompott', 'description': 'Klassische Beilage.', 'prep_time_min': 10, 'cook_time_min': 15, 'servings': 6, 'difficulty': 'easy', 'category': 'dessert', 'tags': ['meal-prep', 'vegan'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Pflaumen', 'amount': 500, 'unit': 'g'}, {'item': 'Zucker', 'amount': 80, 'unit': 'g'}, {'item': 'Wasser', 'amount': 100, 'unit': 'ml'}, {'item': 'Zimtstange', 'amount': 1, 'unit': 'Stück'}],
    'steps': ['Pflaumen halbieren und entsteinen.', 'Mit Zucker, Wasser und Zimt aufkochen.', '10-15 Min. köcheln.', 'Warm oder kalt servieren.']},

  // MIRABELLEN
  {'vegetable': 'Mirabellen', 'title': 'Mirabellen-Clafoutis', 'description': 'Französischer Auflauf.', 'prep_time_min': 15, 'cook_time_min': 35, 'servings': 6, 'difficulty': 'easy', 'category': 'dessert', 'tags': ['comfort-food'], 'is_vegetarian': true, 'contains_gluten': true, 'contains_lactose': true, 'contains_eggs': true,
    'ingredients': [{'item': 'Mirabellen', 'amount': 400, 'unit': 'g'}, {'item': 'Eier', 'amount': 3, 'unit': 'Stück'}, {'item': 'Mehl', 'amount': 60, 'unit': 'g'}, {'item': 'Milch', 'amount': 250, 'unit': 'ml'}, {'item': 'Zucker', 'amount': 80, 'unit': 'g'}],
    'steps': ['Mirabellen waschen, Steine können drin bleiben.', 'In gefettete Form geben.', 'Eier, Mehl, Milch, Zucker verrühren.', 'Über Früchte giessen.', '30-35 Min. bei 180°C backen.']},
  {'vegetable': 'Mirabellen', 'title': 'Mirabellen-Tarte', 'description': 'Elegantes Dessert.', 'prep_time_min': 25, 'cook_time_min': 30, 'servings': 8, 'difficulty': 'medium', 'category': 'dessert', 'tags': ['party'], 'is_vegetarian': true, 'contains_gluten': true, 'contains_lactose': true, 'contains_eggs': true,
    'ingredients': [{'item': 'Blätterteig', 'amount': 1, 'unit': 'Stück'}, {'item': 'Mirabellen', 'amount': 500, 'unit': 'g'}, {'item': 'Mandelmehl', 'amount': 50, 'unit': 'g'}, {'item': 'Butter', 'amount': 30, 'unit': 'g'}, {'item': 'Zucker', 'amount': 50, 'unit': 'g'}],
    'steps': ['Teig in Tarteform legen.', 'Mit Mandelmehl bestreuen.', 'Mirabellen halbiert darauf verteilen.', 'Butterflocken und Zucker darüber.', '25-30 Min. bei 200°C backen.']},

  // QUITTEN
  {'vegetable': 'Quitten', 'title': 'Quittengelee', 'description': 'Goldener Brotaufstrich.', 'prep_time_min': 30, 'cook_time_min': 60, 'servings': 10, 'difficulty': 'medium', 'category': 'snack', 'tags': ['meal-prep'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Quitten', 'amount': 1500, 'unit': 'g'}, {'item': 'Gelierzucker', 'amount': 500, 'unit': 'g'}, {'item': 'Zitronensaft', 'amount': 2, 'unit': 'EL'}],
    'steps': ['Quitten abreiben und vierteln.', 'Mit Wasser bedeckt 45 Min. kochen.', 'Durch Tuch abseihen.', 'Saft mit Zucker aufkochen.', '4 Min. sprudelnd kochen.', 'In Gläser füllen.']},
  {'vegetable': 'Quitten', 'title': 'Quittenbrot', 'description': 'Spanische Süssigkeit.', 'prep_time_min': 30, 'cook_time_min': 90, 'servings': 20, 'difficulty': 'medium', 'category': 'dessert', 'tags': ['party'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Quitten', 'amount': 1000, 'unit': 'g'}, {'item': 'Zucker', 'amount': 800, 'unit': 'g'}, {'item': 'Zitronensaft', 'amount': 2, 'unit': 'EL'}],
    'steps': ['Quitten kochen und pürieren.', 'Mit Zucker unter Rühren einkochen.', 'Bis sich Masse vom Topf löst.', 'In Form giessen.', '2-3 Tage trocknen lassen.', 'In Stücke schneiden.']},

  // TRAUBEN
  {'vegetable': 'Trauben', 'title': 'Trauben-Focaccia', 'description': 'Italienisches Herbstgebäck.', 'prep_time_min': 30, 'cook_time_min': 25, 'servings': 8, 'difficulty': 'medium', 'category': 'snack', 'tags': ['party'], 'is_vegetarian': true, 'contains_gluten': true,
    'ingredients': [{'item': 'Trauben', 'amount': 300, 'unit': 'g'}, {'item': 'Focaccia-Teig', 'amount': 500, 'unit': 'g'}, {'item': 'Olivenöl', 'amount': 4, 'unit': 'EL'}, {'item': 'Rosmarin', 'amount': 2, 'unit': 'Zweige'}, {'item': 'Fleur de Sel', 'amount': 1, 'unit': 'TL'}],
    'steps': ['Teig auf Blech ausbreiten.', 'Trauben hineindrücken.', 'Mit Öl beträufeln.', 'Rosmarin und Salz darüber.', '20-25 Min. bei 220°C backen.']},
  {'vegetable': 'Trauben', 'title': 'Trauben-Käse-Spiesse', 'description': 'Schneller Apéro.', 'prep_time_min': 10, 'cook_time_min': 0, 'servings': 8, 'difficulty': 'easy', 'category': 'snack', 'tags': ['schnell', 'party'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [{'item': 'Trauben', 'amount': 200, 'unit': 'g'}, {'item': 'Gruyère', 'amount': 150, 'unit': 'g'}, {'item': 'Walnüsse', 'amount': 50, 'unit': 'g'}],
    'steps': ['Käse in Würfel schneiden.', 'Abwechselnd mit Trauben auf Spiesse stecken.', 'Mit Nuss garnieren.']},

  // STACHELBEEREN
  {'vegetable': 'Stachelbeeren', 'title': 'Stachelbeer-Crumble', 'description': 'Süss-säuerlich.', 'prep_time_min': 15, 'cook_time_min': 30, 'servings': 6, 'difficulty': 'easy', 'category': 'dessert', 'tags': ['comfort-food'], 'is_vegetarian': true, 'contains_gluten': true, 'contains_lactose': true,
    'ingredients': [{'item': 'Stachelbeeren', 'amount': 400, 'unit': 'g'}, {'item': 'Mehl', 'amount': 100, 'unit': 'g'}, {'item': 'Butter', 'amount': 80, 'unit': 'g'}, {'item': 'Zucker', 'amount': 100, 'unit': 'g'}],
    'steps': ['Stachelbeeren in Form geben.', 'Mit Hälfte Zucker mischen.', 'Streusel aus Mehl, Butter, restlichem Zucker.', 'Darüberverteilen.', '25-30 Min. bei 180°C backen.']},
  {'vegetable': 'Stachelbeeren', 'title': 'Stachelbeer-Kompott', 'description': 'Klassische Beilage.', 'prep_time_min': 5, 'cook_time_min': 10, 'servings': 4, 'difficulty': 'easy', 'category': 'dessert', 'tags': ['schnell', 'vegan'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Stachelbeeren', 'amount': 300, 'unit': 'g'}, {'item': 'Zucker', 'amount': 80, 'unit': 'g'}, {'item': 'Wasser', 'amount': 50, 'unit': 'ml'}],
    'steps': ['Beeren mit Zucker und Wasser aufkochen.', '8-10 Min. köcheln.', 'Abkühlen lassen.']},

  // HOLUNDER
  {'vegetable': 'Holunder', 'title': 'Holunderblütensirup', 'description': 'Duft des Sommers.', 'prep_time_min': 20, 'cook_time_min': 5, 'servings': 10, 'difficulty': 'easy', 'category': 'snack', 'tags': ['meal-prep'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Holunderblüten', 'amount': 20, 'unit': 'Dolden'}, {'item': 'Zucker', 'amount': 1000, 'unit': 'g'}, {'item': 'Wasser', 'amount': 1000, 'unit': 'ml'}, {'item': 'Zitrone', 'amount': 2, 'unit': 'Stück'}],
    'steps': ['Blüten mit Zitronenscheiben in Gefäss.', 'Zuckersirup kochen und darübergiessen.', '3 Tage ziehen lassen.', 'Abseihen und in Flaschen füllen.']},
  {'vegetable': 'Holunder', 'title': 'Holunderküchlein', 'description': 'Ausgebackene Holunderblüten.', 'prep_time_min': 15, 'cook_time_min': 15, 'servings': 4, 'difficulty': 'easy', 'category': 'dessert', 'tags': ['schweizer-klassiker'], 'is_vegetarian': true, 'contains_gluten': true, 'contains_eggs': true,
    'ingredients': [{'item': 'Holunderblüten', 'amount': 12, 'unit': 'Dolden'}, {'item': 'Mehl', 'amount': 100, 'unit': 'g'}, {'item': 'Ei', 'amount': 1, 'unit': 'Stück'}, {'item': 'Milch', 'amount': 150, 'unit': 'ml'}, {'item': 'Puderzucker', 'note': 'zum Bestäuben'}],
    'steps': ['Teig aus Mehl, Ei, Milch rühren.', 'Blüten durch Teig ziehen.', 'In heissem Öl ausbacken.', 'Auf Küchenpapier abtropfen.', 'Mit Puderzucker bestäuben.']},

  // CASSIS / PREISELBEEREN
  {'vegetable': 'Cassis', 'title': 'Cassis-Sauce', 'description': 'Zu Wild und Desserts.', 'prep_time_min': 5, 'cook_time_min': 10, 'servings': 6, 'difficulty': 'easy', 'category': 'side', 'tags': ['schnell', 'vegan'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Cassis', 'amount': 200, 'unit': 'g'}, {'item': 'Zucker', 'amount': 60, 'unit': 'g'}, {'item': 'Wasser', 'amount': 50, 'unit': 'ml'}],
    'steps': ['Cassis mit Zucker und Wasser aufkochen.', '8 Min. köcheln.', 'Leicht pürieren für glatte Sauce.']},
  {'vegetable': 'Preiselbeeren', 'title': 'Preiselbeer-Sauce', 'description': 'Klassiker zu Wild.', 'prep_time_min': 5, 'cook_time_min': 15, 'servings': 8, 'difficulty': 'easy', 'category': 'side', 'tags': ['meal-prep'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Preiselbeeren', 'amount': 300, 'unit': 'g'}, {'item': 'Zucker', 'amount': 150, 'unit': 'g'}, {'item': 'Wasser', 'amount': 100, 'unit': 'ml'}, {'item': 'Orangenschale', 'amount': 1, 'unit': 'Stück'}],
    'steps': ['Alle Zutaten aufkochen.', '10-15 Min. köcheln.', 'Abkühlen lassen.', 'Kühl aufbewahren.']},
];

// Recipe Data Part 4: Salads, Herbs, and Meat

final recipesPartFour = <Map<String, dynamic>>[
  // ═══════════════════════════════════════════════════════════════════════════
  // SALATE
  // ═══════════════════════════════════════════════════════════════════════════
  // KOPFSALAT
  {'vegetable': 'Kopfsalat', 'title': 'Klassischer grüner Salat', 'description': 'Einfach und frisch.', 'prep_time_min': 10, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'salad', 'tags': ['schnell', 'vegan'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Kopfsalat', 'amount': 1, 'unit': 'Stück'}, {'item': 'Weissweinessig', 'amount': 2, 'unit': 'EL'}, {'item': 'Rapsöl', 'amount': 4, 'unit': 'EL'}, {'item': 'Senf', 'amount': 1, 'unit': 'TL'}],
    'steps': ['Salat waschen und zerteilen.', 'Dressing aus Essig, Öl, Senf rühren.', 'Salat damit anmachen.', 'Sofort servieren.']},
  {'vegetable': 'Kopfsalat', 'title': 'Kopfsalat mit Kräuterdressing', 'description': 'Mit frischen Gartenkräutern.', 'prep_time_min': 15, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'salad', 'tags': ['schnell', 'gesund'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [{'item': 'Kopfsalat', 'amount': 1, 'unit': 'Stück'}, {'item': 'Joghurt', 'amount': 100, 'unit': 'g'}, {'item': 'Schnittlauch', 'amount': 2, 'unit': 'EL'}, {'item': 'Petersilie', 'amount': 2, 'unit': 'EL'}, {'item': 'Zitronensaft', 'amount': 1, 'unit': 'EL'}],
    'steps': ['Salat waschen.', 'Joghurt mit Kräutern mischen.', 'Zitronensaft unterrühren.', 'Salat anmachen.']},

  // EISBERGSALAT
  {'vegetable': 'Eisbergsalat', 'title': 'Cäsar Salat', 'description': 'Amerikanischer Klassiker.', 'prep_time_min': 20, 'cook_time_min': 10, 'servings': 4, 'difficulty': 'easy', 'category': 'salad', 'tags': ['party'], 'is_vegetarian': true, 'contains_lactose': true, 'contains_eggs': true, 'contains_fish': true,
    'ingredients': [{'item': 'Eisbergsalat', 'amount': 1, 'unit': 'Stück'}, {'item': 'Parmesan', 'amount': 80, 'unit': 'g'}, {'item': 'Croutons', 'amount': 100, 'unit': 'g'}, {'item': 'Cäsar-Dressing', 'amount': 100, 'unit': 'ml'}],
    'steps': ['Salat in mundgerechte Stücke reissen.', 'Mit Dressing vermengen.', 'Mit Parmesan und Croutons toppen.']},
  {'vegetable': 'Eisbergsalat', 'title': 'Eisberg-Wedges', 'description': 'Mit Blue-Cheese-Dressing.', 'prep_time_min': 10, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'salad', 'tags': ['party'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [{'item': 'Eisbergsalat', 'amount': 1, 'unit': 'Stück'}, {'item': 'Blue Cheese', 'amount': 100, 'unit': 'g'}, {'item': 'Sauerrahm', 'amount': 100, 'unit': 'g'}, {'item': 'Speckwürfeli', 'amount': 80, 'unit': 'g'}],
    'steps': ['Salat in Viertel schneiden.', 'Käse mit Sauerrahm mischen.', 'Speck knusprig braten.', 'Salat mit Dressing und Speck servieren.']},

  // BATAVIA / LOLLO
  {'vegetable': 'Batavia', 'title': 'Bunter Sommersalat', 'description': 'Mit Gemüse der Saison.', 'prep_time_min': 15, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'salad', 'tags': ['vegan', 'gesund'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Batavia', 'amount': 1, 'unit': 'Stück'}, {'item': 'Cherrytomaten', 'amount': 200, 'unit': 'g'}, {'item': 'Gurke', 'amount': 1, 'unit': 'Stück'}, {'item': 'Olivenöl', 'amount': 3, 'unit': 'EL'}, {'item': 'Balsamico', 'amount': 2, 'unit': 'EL'}],
    'steps': ['Salat waschen und zerteilen.', 'Tomaten halbieren, Gurke schneiden.', 'Alles mischen.', 'Mit Öl und Balsamico anmachen.']},
  {'vegetable': 'Lollo', 'title': 'Lollo rosso mit Birnen', 'description': 'Herbstliche Kombination.', 'prep_time_min': 15, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'salad', 'tags': ['party'], 'is_vegetarian': true, 'contains_lactose': true, 'contains_nuts': true,
    'ingredients': [{'item': 'Lollo rosso', 'amount': 1, 'unit': 'Stück'}, {'item': 'Birne', 'amount': 1, 'unit': 'Stück'}, {'item': 'Baumnüsse', 'amount': 50, 'unit': 'g'}, {'item': 'Gorgonzola', 'amount': 80, 'unit': 'g'}],
    'steps': ['Salat waschen und zerteilen.', 'Birne in Spalten schneiden.', 'Nüsse rösten.', 'Alles mit Käse anrichten.']},

  // RUCOLA
  {'vegetable': 'Rucola', 'title': 'Rucola-Parmesan-Salat', 'description': 'Italienischer Klassiker.', 'prep_time_min': 10, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'salad', 'tags': ['schnell', 'gesund'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [{'item': 'Rucola', 'amount': 150, 'unit': 'g'}, {'item': 'Parmesan', 'amount': 80, 'unit': 'g'}, {'item': 'Cherrytomaten', 'amount': 200, 'unit': 'g'}, {'item': 'Olivenöl', 'amount': 4, 'unit': 'EL'}, {'item': 'Balsamico', 'amount': 2, 'unit': 'EL'}],
    'steps': ['Rucola waschen.', 'Tomaten halbieren.', 'Parmesan hobeln.', 'Alles mit Öl und Balsamico anmachen.']},
  {'vegetable': 'Rucola', 'title': 'Rucola-Pesto', 'description': 'Würzige Pasta-Sauce.', 'prep_time_min': 10, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'side', 'tags': ['schnell'], 'is_vegetarian': true, 'contains_lactose': true, 'contains_nuts': true,
    'ingredients': [{'item': 'Rucola', 'amount': 100, 'unit': 'g'}, {'item': 'Pinienkerne', 'amount': 30, 'unit': 'g'}, {'item': 'Parmesan', 'amount': 50, 'unit': 'g'}, {'item': 'Knoblauch', 'amount': 1, 'unit': 'Zehe'}, {'item': 'Olivenöl', 'amount': 100, 'unit': 'ml'}],
    'steps': ['Pinienkerne rösten.', 'Alle Zutaten im Mixer pürieren.', 'Mit Salz abschmecken.', 'Zu Pasta servieren.']},

  // ENDIVIENSALAT / ZUCKERHUT
  {'vegetable': 'Endiviensalat', 'title': 'Endivien mit Speck', 'description': 'Leicht bitter, würzig.', 'prep_time_min': 15, 'cook_time_min': 5, 'servings': 4, 'difficulty': 'easy', 'category': 'salad', 'tags': ['schnell'],
    'ingredients': [{'item': 'Endiviensalat', 'amount': 1, 'unit': 'Stück'}, {'item': 'Speckwürfeli', 'amount': 100, 'unit': 'g'}, {'item': 'Weissweinessig', 'amount': 3, 'unit': 'EL'}, {'item': 'Rapsöl', 'amount': 4, 'unit': 'EL'}],
    'steps': ['Salat in Streifen schneiden.', 'Speck knusprig braten.', 'Dressing anrühren.', 'Salat mit warmem Speck servieren.']},
  {'vegetable': 'Zuckerhut', 'title': 'Zuckerhut-Salat', 'description': 'Winterlicher Salat.', 'prep_time_min': 15, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'salad', 'tags': ['gesund'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Zuckerhut', 'amount': 1, 'unit': 'Stück'}, {'item': 'Apfel', 'amount': 1, 'unit': 'Stück'}, {'item': 'Weissweinessig', 'amount': 2, 'unit': 'EL'}, {'item': 'Rapsöl', 'amount': 4, 'unit': 'EL'}, {'item': 'Honig', 'amount': 1, 'unit': 'TL'}],
    'steps': ['Zuckerhut in Streifen schneiden.', 'Apfel in Würfel schneiden.', 'Dressing mit Honig anrühren.', 'Alles mischen.']},

  // CICORINO ROSSO / PORTULAK
  {'vegetable': 'Cicorino rosso', 'title': 'Cicorino mit Orange', 'description': 'Bitter-süss Kombination.', 'prep_time_min': 15, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'salad', 'tags': ['gesund', 'vegan'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Cicorino rosso', 'amount': 200, 'unit': 'g'}, {'item': 'Orange', 'amount': 2, 'unit': 'Stück'}, {'item': 'Olivenöl', 'amount': 3, 'unit': 'EL'}, {'item': 'Balsamico', 'amount': 1, 'unit': 'EL'}],
    'steps': ['Cicorino in Blätter teilen.', 'Orangen filetieren.', 'Mit Dressing anmachen.']},
  {'vegetable': 'Portulak', 'title': 'Portulak-Salat', 'description': 'Nussig-frischer Salat.', 'prep_time_min': 10, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'salad', 'tags': ['schnell', 'vegan', 'gesund'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Portulak', 'amount': 150, 'unit': 'g'}, {'item': 'Tomate', 'amount': 2, 'unit': 'Stück'}, {'item': 'Zitronensaft', 'amount': 2, 'unit': 'EL'}, {'item': 'Olivenöl', 'amount': 3, 'unit': 'EL'}],
    'steps': ['Portulak waschen.', 'Tomaten würfeln.', 'Mit Dressing anmachen.']},

  // ═══════════════════════════════════════════════════════════════════════════
  // KRÄUTER
  // ═══════════════════════════════════════════════════════════════════════════
  {'vegetable': 'Basilikum', 'title': 'Pesto Genovese', 'description': 'Original italienisches Pesto.', 'prep_time_min': 10, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'side', 'tags': ['schnell'], 'is_vegetarian': true, 'contains_lactose': true, 'contains_nuts': true,
    'ingredients': [{'item': 'Basilikum', 'amount': 60, 'unit': 'g'}, {'item': 'Pinienkerne', 'amount': 30, 'unit': 'g'}, {'item': 'Parmesan', 'amount': 60, 'unit': 'g'}, {'item': 'Knoblauch', 'amount': 2, 'unit': 'Zehen'}, {'item': 'Olivenöl', 'amount': 120, 'unit': 'ml'}],
    'steps': ['Pinienkerne kurz rösten.', 'Alle Zutaten im Mörser oder Mixer verarbeiten.', 'Mit Pasta servieren.']},
  {'vegetable': 'Basilikum', 'title': 'Tomaten-Basilikum-Bruschetta', 'description': 'Italienische Vorspeise.', 'prep_time_min': 15, 'cook_time_min': 5, 'servings': 4, 'difficulty': 'easy', 'category': 'snack', 'tags': ['party', 'schnell'], 'is_vegetarian': true, 'contains_gluten': true,
    'ingredients': [{'item': 'Basilikum', 'amount': 1, 'unit': 'Bund'}, {'item': 'Tomaten', 'amount': 4, 'unit': 'Stück'}, {'item': 'Baguette', 'amount': 1, 'unit': 'Stück'}, {'item': 'Knoblauch', 'amount': 2, 'unit': 'Zehen'}, {'item': 'Olivenöl', 'amount': 4, 'unit': 'EL'}],
    'steps': ['Brot in Scheiben schneiden und toasten.', 'Mit Knoblauch einreiben.', 'Tomaten würfeln, mit Basilikum mischen.', 'Auf Brot verteilen.']},

  {'vegetable': 'Petersilie', 'title': 'Tabbouleh', 'description': 'Libanesischer Petersiliensalat.', 'prep_time_min': 20, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'salad', 'tags': ['vegan', 'gesund'], 'is_vegetarian': true, 'is_vegan': true, 'contains_gluten': true,
    'ingredients': [{'item': 'Petersilie', 'amount': 2, 'unit': 'Bund'}, {'item': 'Bulgur', 'amount': 50, 'unit': 'g'}, {'item': 'Tomaten', 'amount': 3, 'unit': 'Stück'}, {'item': 'Zitronensaft', 'amount': 3, 'unit': 'EL'}, {'item': 'Olivenöl', 'amount': 4, 'unit': 'EL'}],
    'steps': ['Bulgur einweichen und abtropfen.', 'Petersilie sehr fein hacken.', 'Tomaten würfeln.', 'Alles mit Dressing mischen.']},
  {'vegetable': 'Petersilie', 'title': 'Gremolata', 'description': 'Italienische Würzung.', 'prep_time_min': 5, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'side', 'tags': ['schnell', 'vegan'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Petersilie', 'amount': 1, 'unit': 'Bund'}, {'item': 'Knoblauch', 'amount': 2, 'unit': 'Zehen'}, {'item': 'Zitronenschale', 'amount': 1, 'unit': 'Stück'}],
    'steps': ['Petersilie fein hacken.', 'Knoblauch fein hacken.', 'Zitronenschale abreiben.', 'Alles mischen.', 'Über Ossobuco oder Fisch streuen.']},

  {'vegetable': 'Schnittlauch', 'title': 'Schnittlauch-Quark', 'description': 'Klassischer Brotaufstrich.', 'prep_time_min': 5, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'snack', 'tags': ['schnell'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [{'item': 'Schnittlauch', 'amount': 1, 'unit': 'Bund'}, {'item': 'Quark', 'amount': 250, 'unit': 'g'}, {'item': 'Salz', 'amount': 0.5, 'unit': 'TL'}],
    'steps': ['Schnittlauch fein schneiden.', 'Unter Quark mischen.', 'Mit Salz abschmecken.']},
  {'vegetable': 'Schnittlauch', 'title': 'Schnittlauch-Vinaigrette', 'description': 'Für Fischgerichte.', 'prep_time_min': 5, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'side', 'tags': ['schnell'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Schnittlauch', 'amount': 3, 'unit': 'EL'}, {'item': 'Weissweinessig', 'amount': 2, 'unit': 'EL'}, {'item': 'Olivenöl', 'amount': 6, 'unit': 'EL'}, {'item': 'Senf', 'amount': 1, 'unit': 'TL'}],
    'steps': ['Schnittlauch fein schneiden.', 'Mit restlichen Zutaten verrühren.', 'Über Fisch oder Salat geben.']},

  // ═══════════════════════════════════════════════════════════════════════════
  // ZWIEBEL / KNOBLAUCH / FRÜHLINGSZWIEBEL
  // ═══════════════════════════════════════════════════════════════════════════
  {'vegetable': 'Zwiebel', 'title': 'Zwiebelsuppe', 'description': 'Französische Klassik.', 'prep_time_min': 10, 'cook_time_min': 45, 'servings': 4, 'difficulty': 'easy', 'category': 'soup', 'tags': ['comfort-food'], 'is_vegetarian': true, 'contains_gluten': true, 'contains_lactose': true,
    'ingredients': [{'item': 'Zwiebeln', 'amount': 800, 'unit': 'g'}, {'item': 'Butter', 'amount': 50, 'unit': 'g'}, {'item': 'Rindbouillon', 'amount': 1000, 'unit': 'ml'}, {'item': 'Baguette', 'amount': 4, 'unit': 'Scheiben'}, {'item': 'Gruyère', 'amount': 150, 'unit': 'g'}],
    'steps': ['Zwiebeln in Ringe schneiden.', 'In Butter 30 Min. karamellisieren.', 'Mit Bouillon ablöschen und 15 Min. köcheln.', 'In Suppenschalen füllen.', 'Brot und Käse darauf, überbacken.']},
  {'vegetable': 'Zwiebel', 'title': 'Knusprige Zwiebelringe', 'description': 'Goldbraun gebacken.', 'prep_time_min': 15, 'cook_time_min': 15, 'servings': 4, 'difficulty': 'easy', 'category': 'snack', 'tags': ['party'], 'is_vegetarian': true, 'contains_gluten': true, 'contains_eggs': true,
    'ingredients': [{'item': 'Zwiebeln', 'amount': 3, 'unit': 'Stück', 'note': 'gross'}, {'item': 'Mehl', 'amount': 150, 'unit': 'g'}, {'item': 'Ei', 'amount': 1, 'unit': 'Stück'}, {'item': 'Bier', 'amount': 150, 'unit': 'ml'}, {'item': 'Rapsöl', 'note': 'zum Frittieren'}],
    'steps': ['Zwiebeln in dicke Ringe schneiden.', 'Teig aus Mehl, Ei, Bier rühren.', 'Ringe durch Teig ziehen.', 'In heissem Öl goldbraun frittieren.']},

  {'vegetable': 'Knoblauch', 'title': 'Aioli', 'description': 'Provenzalische Knoblauchmayonnaise.', 'prep_time_min': 15, 'cook_time_min': 0, 'servings': 6, 'difficulty': 'medium', 'category': 'side', 'tags': ['party'], 'is_vegetarian': true, 'contains_eggs': true,
    'ingredients': [{'item': 'Knoblauch', 'amount': 4, 'unit': 'Zehen'}, {'item': 'Eigelb', 'amount': 2, 'unit': 'Stück'}, {'item': 'Olivenöl', 'amount': 200, 'unit': 'ml'}, {'item': 'Zitronensaft', 'amount': 1, 'unit': 'EL'}],
    'steps': ['Knoblauch im Mörser zerreiben.', 'Eigelb unterrühren.', 'Öl tropfenweise einrühren.', 'Mit Zitrone und Salz abschmecken.']},
  {'vegetable': 'Knoblauch', 'title': 'Knoblauchbrot', 'description': 'Perfekt zum Grillieren.', 'prep_time_min': 10, 'cook_time_min': 10, 'servings': 6, 'difficulty': 'easy', 'category': 'side', 'tags': ['party', 'schnell'], 'is_vegetarian': true, 'contains_gluten': true, 'contains_lactose': true,
    'ingredients': [{'item': 'Knoblauch', 'amount': 4, 'unit': 'Zehen'}, {'item': 'Butter', 'amount': 100, 'unit': 'g'}, {'item': 'Baguette', 'amount': 1, 'unit': 'Stück'}, {'item': 'Petersilie', 'amount': 2, 'unit': 'EL'}],
    'steps': ['Butter weich werden lassen.', 'Knoblauch pressen und untermischen.', 'Petersilie unterrühren.', 'Brot einschneiden und bestreichen.', '10 Min. bei 200°C backen.']},

  {'vegetable': 'Frühlingszwiebel', 'title': 'Frühlingslauch-Quiche', 'description': 'Leichte Gemüsewähe.', 'prep_time_min': 20, 'cook_time_min': 35, 'servings': 6, 'difficulty': 'medium', 'category': 'main', 'tags': ['party'], 'is_vegetarian': true, 'contains_gluten': true, 'contains_lactose': true, 'contains_eggs': true,
    'ingredients': [{'item': 'Frühlingszwiebeln', 'amount': 3, 'unit': 'Bund'}, {'item': 'Kuchenteig', 'amount': 1, 'unit': 'Stück'}, {'item': 'Eier', 'amount': 3, 'unit': 'Stück'}, {'item': 'Rahm', 'amount': 200, 'unit': 'ml'}, {'item': 'Gruyère', 'amount': 100, 'unit': 'g'}],
    'steps': ['Teig in Form legen.', 'Frühlingszwiebeln in Ringe schneiden.', 'Andünsten und auf Teig verteilen.', 'Guss aus Eiern und Rahm darüber.', 'Mit Käse bestreuen.', '30-35 Min. bei 180°C backen.']},
  {'vegetable': 'Frühlingszwiebel', 'title': 'Asiatische Frühlingszwiebel-Öl', 'description': 'Zum Verfeinern.', 'prep_time_min': 5, 'cook_time_min': 5, 'servings': 4, 'difficulty': 'easy', 'category': 'side', 'tags': ['schnell', 'vegan'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Frühlingszwiebeln', 'amount': 6, 'unit': 'Stück'}, {'item': 'Rapsöl', 'amount': 100, 'unit': 'ml'}, {'item': 'Ingwer', 'amount': 20, 'unit': 'g'}, {'item': 'Sojasauce', 'amount': 1, 'unit': 'EL'}],
    'steps': ['Frühlingszwiebeln fein schneiden.', 'Ingwer reiben.', 'In einer Schüssel verteilen.', 'Heisses Öl darübergiessen.', 'Mit Sojasauce mischen.']},

  // ═══════════════════════════════════════════════════════════════════════════
  // FLEISCH
  // ═══════════════════════════════════════════════════════════════════════════
  {'vegetable': 'Poulet', 'title': 'Gebratenes Poulet', 'description': 'Knusprig aus dem Ofen.', 'prep_time_min': 15, 'cook_time_min': 60, 'servings': 6, 'difficulty': 'medium', 'category': 'main', 'tags': ['comfort-food'],
    'ingredients': [{'item': 'Poulet', 'amount': 1, 'unit': 'Stück', 'note': 'ca. 1.5kg'}, {'item': 'Butter', 'amount': 50, 'unit': 'g'}, {'item': 'Zitrone', 'amount': 1, 'unit': 'Stück'}, {'item': 'Thymian', 'amount': 4, 'unit': 'Zweige'}, {'item': 'Knoblauch', 'amount': 4, 'unit': 'Zehen'}],
    'steps': ['Ofen auf 200°C vorheizen.', 'Poulet innen und aussen würzen.', 'Mit Zitrone und Kräutern füllen.', 'Mit Butter bestreichen.', '50-60 Min. braten.', 'Ruhen lassen und tranchieren.']},
  {'vegetable': 'Poulet', 'title': 'Poulet-Geschnetzeltes', 'description': 'Schnelles Abendessen.', 'prep_time_min': 15, 'cook_time_min': 15, 'servings': 4, 'difficulty': 'easy', 'category': 'main', 'tags': ['schnell', 'kinderfreundlich'], 'contains_lactose': true,
    'ingredients': [{'item': 'Pouletbrust', 'amount': 500, 'unit': 'g'}, {'item': 'Rahm', 'amount': 200, 'unit': 'ml'}, {'item': 'Paprikapulver', 'amount': 1, 'unit': 'TL'}, {'item': 'Zwiebel', 'amount': 1, 'unit': 'Stück'}],
    'steps': ['Poulet in Streifen schneiden.', 'Scharf anbraten.', 'Zwiebel beigeben.', 'Mit Rahm ablöschen.', 'Mit Paprika würzen.', 'Mit Reis servieren.']},
  {'vegetable': 'Poulet', 'title': 'Poulet-Curry', 'description': 'Aromatisch mit Kokosmilch.', 'prep_time_min': 15, 'cook_time_min': 25, 'servings': 4, 'difficulty': 'easy', 'category': 'main', 'tags': ['comfort-food'],
    'ingredients': [{'item': 'Pouletbrust', 'amount': 500, 'unit': 'g'}, {'item': 'Kokosmilch', 'amount': 400, 'unit': 'ml'}, {'item': 'Currypaste', 'amount': 2, 'unit': 'EL'}, {'item': 'Zwiebel', 'amount': 1, 'unit': 'Stück'}, {'item': 'Koriander', 'amount': 2, 'unit': 'EL'}],
    'steps': ['Poulet würfeln und anbraten.', 'Zwiebel beigeben.', 'Currypaste einrühren.', 'Mit Kokosmilch ablöschen.', '15 Min. köcheln.', 'Mit Reis und Koriander servieren.']},

  {'vegetable': 'Rindfleisch', 'title': 'Rindsgeschnetzeltes', 'description': 'Zart und aromatisch.', 'prep_time_min': 15, 'cook_time_min': 15, 'servings': 4, 'difficulty': 'medium', 'category': 'main', 'tags': ['schnell'], 'contains_lactose': true,
    'ingredients': [{'item': 'Rindsgeschnetzeltes', 'amount': 500, 'unit': 'g'}, {'item': 'Champignons', 'amount': 200, 'unit': 'g'}, {'item': 'Rahm', 'amount': 200, 'unit': 'ml'}, {'item': 'Senf', 'amount': 1, 'unit': 'EL'}, {'item': 'Zwiebel', 'amount': 1, 'unit': 'Stück'}],
    'steps': ['Fleisch portionsweise scharf anbraten.', 'Herausnehmen.', 'Champignons und Zwiebel anbraten.', 'Rahm und Senf beigeben.', 'Fleisch zurückgeben.', 'Mit Salz und Pfeffer abschmecken.']},
  {'vegetable': 'Rindfleisch', 'title': 'Rindsgulasch', 'description': 'Ungarischer Klassiker.', 'prep_time_min': 20, 'cook_time_min': 120, 'servings': 6, 'difficulty': 'easy', 'category': 'main', 'tags': ['comfort-food', 'meal-prep'],
    'ingredients': [{'item': 'Rindsgulasch', 'amount': 800, 'unit': 'g'}, {'item': 'Zwiebeln', 'amount': 4, 'unit': 'Stück'}, {'item': 'Paprikapulver', 'amount': 3, 'unit': 'EL'}, {'item': 'Tomatenmark', 'amount': 2, 'unit': 'EL'}, {'item': 'Rindbouillon', 'amount': 500, 'unit': 'ml'}],
    'steps': ['Fleisch würfeln und anbraten.', 'Zwiebeln beigeben.', 'Paprika und Tomatenmark einrühren.', 'Mit Bouillon ablöschen.', '2 Stunden sanft schmoren.', 'Mit Nudeln servieren.']},
  {'vegetable': 'Rindfleisch', 'title': 'Rinds-Tatar', 'description': 'Rohes Feines.', 'prep_time_min': 20, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'medium', 'category': 'main', 'tags': ['party'], 'contains_eggs': true,
    'ingredients': [{'item': 'Rindsfilet', 'amount': 400, 'unit': 'g'}, {'item': 'Eigelb', 'amount': 2, 'unit': 'Stück'}, {'item': 'Kapern', 'amount': 2, 'unit': 'EL'}, {'item': 'Schalotten', 'amount': 2, 'unit': 'Stück'}, {'item': 'Worcestersauce', 'amount': 1, 'unit': 'TL'}],
    'steps': ['Fleisch sehr fein hacken.', 'Schalotten und Kapern fein hacken.', 'Mit Eigelb und Sauce vermengen.', 'Zu Nocken formen.', 'Mit Toast servieren.']},

  {'vegetable': 'Schweinefleisch', 'title': 'Schweinskoteletts', 'description': 'Saftig gebraten.', 'prep_time_min': 10, 'cook_time_min': 15, 'servings': 4, 'difficulty': 'easy', 'category': 'main', 'tags': ['schnell'],
    'ingredients': [{'item': 'Schweinskoteletts', 'amount': 4, 'unit': 'Stück'}, {'item': 'Butter', 'amount': 30, 'unit': 'g'}, {'item': 'Thymian', 'amount': 2, 'unit': 'Zweige'}, {'item': 'Knoblauch', 'amount': 2, 'unit': 'Zehen'}],
    'steps': ['Koteletts salzen und pfeffern.', 'In heisser Pfanne anbraten.', 'Mit Butter, Thymian, Knoblauch arrosieren.', '10-12 Min. bei mittlerer Hitze garen.', 'Ruhen lassen.']},
  {'vegetable': 'Schweinefleisch', 'title': 'Schweinsgeschnetzeltes', 'description': 'Mit Champignons.', 'prep_time_min': 15, 'cook_time_min': 20, 'servings': 4, 'difficulty': 'easy', 'category': 'main', 'tags': ['comfort-food'], 'contains_lactose': true,
    'ingredients': [{'item': 'Schweinsgeschnetzeltes', 'amount': 500, 'unit': 'g'}, {'item': 'Champignons', 'amount': 200, 'unit': 'g'}, {'item': 'Rahm', 'amount': 200, 'unit': 'ml'}, {'item': 'Zwiebel', 'amount': 1, 'unit': 'Stück'}],
    'steps': ['Fleisch portionsweise anbraten.', 'Pilze und Zwiebel andünsten.', 'Rahm beigeben.', 'Fleisch zurückgeben.', 'Mit Nudeln oder Reis servieren.']},
  {'vegetable': 'Schweinefleisch', 'title': 'Schweins-Cordon-bleu', 'description': 'Schweizer Restaurant-Klassiker.', 'prep_time_min': 20, 'cook_time_min': 15, 'servings': 4, 'difficulty': 'medium', 'category': 'main', 'tags': ['schweizer-klassiker'], 'contains_gluten': true, 'contains_eggs': true, 'contains_lactose': true,
    'ingredients': [{'item': 'Schweinsschnitzel', 'amount': 4, 'unit': 'Stück'}, {'item': 'Kochschinken', 'amount': 4, 'unit': 'Scheiben'}, {'item': 'Gruyère', 'amount': 4, 'unit': 'Scheiben'}, {'item': 'Paniermehl', 'amount': 100, 'unit': 'g'}, {'item': 'Ei', 'amount': 2, 'unit': 'Stück'}],
    'steps': ['Schnitzel aufschneiden.', 'Mit Schinken und Käse füllen.', 'Zuklappen und klopfen.', 'Panieren.', 'In Butter goldbraun braten.']},

  {'vegetable': 'Lammfleisch', 'title': 'Lammracks', 'description': 'Rosa gebraten mit Kräuterkruste.', 'prep_time_min': 20, 'cook_time_min': 25, 'servings': 4, 'difficulty': 'hard', 'category': 'main', 'tags': ['party'], 'contains_gluten': true,
    'ingredients': [{'item': 'Lammracks', 'amount': 2, 'unit': 'Stück'}, {'item': 'Paniermehl', 'amount': 50, 'unit': 'g'}, {'item': 'Petersilie', 'amount': 3, 'unit': 'EL'}, {'item': 'Senf', 'amount': 2, 'unit': 'EL'}, {'item': 'Knoblauch', 'amount': 2, 'unit': 'Zehen'}],
    'steps': ['Racks rundherum anbraten.', 'Mit Senf bestreichen.', 'Kräuterkruste daraufdrücken.', '15-20 Min. bei 200°C garen.', 'Rosa servieren.']},
  {'vegetable': 'Lammfleisch', 'title': 'Geschmorte Lammhaxe', 'description': 'Butterzart nach langem Schmoren.', 'prep_time_min': 20, 'cook_time_min': 180, 'servings': 4, 'difficulty': 'medium', 'category': 'main', 'tags': ['comfort-food'], 'contains_lactose': true,
    'ingredients': [{'item': 'Lammhaxen', 'amount': 4, 'unit': 'Stück'}, {'item': 'Rotwein', 'amount': 400, 'unit': 'ml'}, {'item': 'Karotten', 'amount': 2, 'unit': 'Stück'}, {'item': 'Zwiebeln', 'amount': 2, 'unit': 'Stück'}, {'item': 'Rosmarin', 'amount': 3, 'unit': 'Zweige'}],
    'steps': ['Haxen rundherum anbraten.', 'Gemüse beigeben.', 'Mit Rotwein ablöschen.', '3 Stunden bei 160°C im Ofen schmoren.', 'Sauce passieren.']},
  {'vegetable': 'Lammfleisch', 'title': 'Lamm-Curry', 'description': 'Indisch inspiriert.', 'prep_time_min': 20, 'cook_time_min': 90, 'servings': 4, 'difficulty': 'medium', 'category': 'main', 'tags': ['comfort-food'],
    'ingredients': [{'item': 'Lammschulter', 'amount': 600, 'unit': 'g'}, {'item': 'Kokosmilch', 'amount': 400, 'unit': 'ml'}, {'item': 'Currypaste', 'amount': 3, 'unit': 'EL'}, {'item': 'Zwiebeln', 'amount': 2, 'unit': 'Stück'}, {'item': 'Tomaten', 'amount': 400, 'unit': 'g'}],
    'steps': ['Lamm würfeln und anbraten.', 'Zwiebeln andünsten.', 'Currypaste einrühren.', 'Tomaten und Kokosmilch beigeben.', '1.5 Stunden sanft schmoren.', 'Mit Reis servieren.']},

  {'vegetable': 'Gitzi', 'title': 'Oster-Gitzi', 'description': 'Traditionelles Schweizer Ostergericht.', 'prep_time_min': 20, 'cook_time_min': 90, 'servings': 6, 'difficulty': 'medium', 'category': 'main', 'tags': ['schweizer-klassiker'],
    'ingredients': [{'item': 'Gitzi', 'amount': 1, 'unit': 'Stück', 'note': 'ca. 2kg'}, {'item': 'Weisswein', 'amount': 300, 'unit': 'ml'}, {'item': 'Knoblauch', 'amount': 6, 'unit': 'Zehen'}, {'item': 'Rosmarin', 'amount': 4, 'unit': 'Zweige'}, {'item': 'Butter', 'amount': 50, 'unit': 'g'}],
    'steps': ['Gitzi zerteilen und würzen.', 'In Butter anbraten.', 'Mit Knoblauch und Rosmarin in Ofen.', 'Mit Wein ablöschen.', '1.5 Stunden bei 160°C schmoren.']},
  {'vegetable': 'Gitzi', 'title': 'Gitzi-Ragout', 'description': 'Sanft geschmort.', 'prep_time_min': 25, 'cook_time_min': 120, 'servings': 6, 'difficulty': 'medium', 'category': 'main', 'tags': ['comfort-food'], 'contains_lactose': true,
    'ingredients': [{'item': 'Gitzi', 'amount': 1, 'unit': 'kg'}, {'item': 'Weisswein', 'amount': 200, 'unit': 'ml'}, {'item': 'Rahm', 'amount': 200, 'unit': 'ml'}, {'item': 'Zwiebeln', 'amount': 2, 'unit': 'Stück'}, {'item': 'Thymian', 'amount': 3, 'unit': 'Zweige'}],
    'steps': ['Fleisch würfeln und anbraten.', 'Zwiebeln beigeben.', 'Mit Wein ablöschen.', '1.5 Stunden schmoren.', 'Rahm unterziehen.', 'Mit Nudeln servieren.']},
];
