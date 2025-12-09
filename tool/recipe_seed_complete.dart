// ignore_for_file: avoid_print, depend_on_referenced_packages
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// Import recipe data parts
part 'recipes_part2.dart';
part 'recipes_part3.dart';
part 'recipes_part4.dart';

/// Comprehensive Recipe Seeder for Saisonier
/// Generates 260+ recipes covering all 87 vegetables
///
/// Usage:
///   cd tool && dart run recipe_seed_complete.dart

Future<void> main() async {
  final baseUrl = Platform.environment['PB_URL'] ?? 'https://saisonier-api.21home.ch';
  final adminEmail = Platform.environment['PB_EMAIL'] ?? 'admin@saisonier.ch';
  final adminPass = Platform.environment['PB_PASS'] ?? 'saisonier123';

  print('🍳 Saisonier Recipe Seeder - Complete Edition');
  print('   Server: $baseUrl');
  print('   Total recipes: ${recipes.length}');
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
  print('🥗 Seeding ${recipes.length} recipes...');

  int created = 0, skipped = 0, failed = 0;

  for (final recipe in recipes) {
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

// ═══════════════════════════════════════════════════════════════════════════
// RECIPE DATA - All recipes combined
// ═══════════════════════════════════════════════════════════════════════════

final recipes = <Map<String, dynamic>>[
  // Part 1: Vegetables A-C (inline)
  // ARTISCHOCKE
  {'vegetable': 'Artischocke', 'title': 'Gegrillte Artischocken', 'description': 'Mediterran mit Zitrone.', 'prep_time_min': 20, 'cook_time_min': 25, 'servings': 4, 'difficulty': 'medium', 'category': 'side', 'tags': ['mediterran'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Artischocken', 'amount': 4, 'unit': 'Stück'}, {'item': 'Zitrone', 'amount': 2, 'unit': 'Stück'}, {'item': 'Olivenöl', 'amount': 4, 'unit': 'EL'}, {'item': 'Knoblauch', 'amount': 3, 'unit': 'Zehen'}],
    'steps': ['Artischocken putzen und halbieren.', 'In Zitronenwasser legen.', '15 Min. vorkochen.', 'Mit Öl bestreichen und grillen.']},
  {'vegetable': 'Artischocke', 'title': 'Artischocken-Pasta', 'description': 'Cremig mit Parmesan.', 'prep_time_min': 15, 'cook_time_min': 20, 'servings': 4, 'difficulty': 'easy', 'category': 'main', 'tags': ['schnell'], 'is_vegetarian': true, 'contains_gluten': true, 'contains_lactose': true,
    'ingredients': [{'item': 'Penne', 'amount': 400, 'unit': 'g'}, {'item': 'Artischockenherzen', 'amount': 400, 'unit': 'g'}, {'item': 'Rahm', 'amount': 200, 'unit': 'ml'}, {'item': 'Parmesan', 'amount': 80, 'unit': 'g'}],
    'steps': ['Pasta kochen.', 'Artischocken anbraten.', 'Rahm beigeben.', 'Mit Pasta und Parmesan mischen.']},
  {'vegetable': 'Artischocke', 'title': 'Artischocken-Dip', 'description': 'Cremig für Apéro.', 'prep_time_min': 10, 'cook_time_min': 20, 'servings': 6, 'difficulty': 'easy', 'category': 'snack', 'tags': ['party'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [{'item': 'Artischockenherzen', 'amount': 400, 'unit': 'g'}, {'item': 'Frischkäse', 'amount': 200, 'unit': 'g'}, {'item': 'Parmesan', 'amount': 50, 'unit': 'g'}, {'item': 'Knoblauch', 'amount': 2, 'unit': 'Zehen'}],
    'steps': ['Artischocken hacken.', 'Mit Käse mischen.', '20 Min. überbacken.']},

  // AUBERGINE
  {'vegetable': 'Aubergine', 'title': 'Baba Ganoush', 'description': 'Orientalischer Dip.', 'prep_time_min': 15, 'cook_time_min': 40, 'servings': 6, 'difficulty': 'easy', 'category': 'snack', 'tags': ['vegan', 'party'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Auberginen', 'amount': 2, 'unit': 'Stück'}, {'item': 'Tahini', 'amount': 3, 'unit': 'EL'}, {'item': 'Zitronensaft', 'amount': 2, 'unit': 'EL'}, {'item': 'Knoblauch', 'amount': 2, 'unit': 'Zehen'}],
    'steps': ['Auberginen im Ofen rösten.', 'Fruchtfleisch auskratzen.', 'Mit Tahini pürieren.']},
  {'vegetable': 'Aubergine', 'title': 'Auberginen-Parmigiana', 'description': 'Italienischer Auflauf.', 'prep_time_min': 30, 'cook_time_min': 45, 'servings': 6, 'difficulty': 'medium', 'category': 'main', 'tags': ['comfort-food'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [{'item': 'Auberginen', 'amount': 3, 'unit': 'Stück'}, {'item': 'Passata', 'amount': 500, 'unit': 'ml'}, {'item': 'Mozzarella', 'amount': 250, 'unit': 'g'}, {'item': 'Parmesan', 'amount': 100, 'unit': 'g'}],
    'steps': ['Auberginen in Scheiben schneiden und braten.', 'Mit Passata und Käse schichten.', '40 Min. backen.']},
  {'vegetable': 'Aubergine', 'title': 'Gefüllte Auberginen', 'description': 'Mit Hackfleisch.', 'prep_time_min': 25, 'cook_time_min': 35, 'servings': 4, 'difficulty': 'medium', 'category': 'main', 'tags': ['meal-prep'],
    'ingredients': [{'item': 'Auberginen', 'amount': 4, 'unit': 'Stück'}, {'item': 'Hackfleisch', 'amount': 300, 'unit': 'g'}, {'item': 'Zwiebel', 'amount': 1, 'unit': 'Stück'}, {'item': 'Tomaten', 'amount': 2, 'unit': 'Stück'}],
    'steps': ['Auberginen halbieren und aushöhlen.', 'Hackfleisch mit Gemüse anbraten.', 'Füllen und backen.']},

  // BLUMENKOHL
  {'vegetable': 'Blumenkohl', 'title': 'Blumenkohl-Käse-Gratin', 'description': 'Cremig überbacken.', 'prep_time_min': 15, 'cook_time_min': 30, 'servings': 4, 'difficulty': 'easy', 'category': 'main', 'tags': ['comfort-food'], 'is_vegetarian': true, 'contains_lactose': true, 'contains_gluten': true,
    'ingredients': [{'item': 'Blumenkohl', 'amount': 1, 'unit': 'Stück'}, {'item': 'Gruyère', 'amount': 150, 'unit': 'g'}, {'item': 'Milch', 'amount': 500, 'unit': 'ml'}, {'item': 'Butter', 'amount': 40, 'unit': 'g'}],
    'steps': ['Blumenkohl blanchieren.', 'Béchamel zubereiten.', 'Mit Käse überbacken.']},
  {'vegetable': 'Blumenkohl', 'title': 'Blumenkohl-Wings', 'description': 'Vegane Alternative.', 'prep_time_min': 20, 'cook_time_min': 35, 'servings': 4, 'difficulty': 'easy', 'category': 'snack', 'tags': ['vegan', 'party'], 'is_vegetarian': true, 'is_vegan': true, 'contains_gluten': true,
    'ingredients': [{'item': 'Blumenkohl', 'amount': 1, 'unit': 'Stück'}, {'item': 'Mehl', 'amount': 100, 'unit': 'g'}, {'item': 'Hot Sauce', 'amount': 4, 'unit': 'EL'}, {'item': 'Paprika', 'amount': 2, 'unit': 'TL'}],
    'steps': ['Blumenkohl in Röschen teilen.', 'Panieren und backen.', 'Mit Hot Sauce schwenken.']},
  {'vegetable': 'Blumenkohl', 'title': 'Blumenkohl-Reis', 'description': 'Low-Carb Beilage.', 'prep_time_min': 10, 'cook_time_min': 10, 'servings': 4, 'difficulty': 'easy', 'category': 'side', 'tags': ['low-carb', 'vegan'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Blumenkohl', 'amount': 1, 'unit': 'Stück'}, {'item': 'Olivenöl', 'amount': 2, 'unit': 'EL'}, {'item': 'Knoblauch', 'amount': 2, 'unit': 'Zehen'}],
    'steps': ['Blumenkohl im Mixer zerkleinern.', 'In Öl anbraten.', 'Mit Knoblauch würzen.']},

  // BOHNEN
  {'vegetable': 'Bohnen', 'title': 'Bohnen mit Speck', 'description': 'Klassische Beilage.', 'prep_time_min': 10, 'cook_time_min': 20, 'servings': 4, 'difficulty': 'easy', 'category': 'side', 'tags': ['comfort-food'],
    'ingredients': [{'item': 'Grüne Bohnen', 'amount': 500, 'unit': 'g'}, {'item': 'Speckwürfeli', 'amount': 100, 'unit': 'g'}, {'item': 'Zwiebel', 'amount': 1, 'unit': 'Stück'}, {'item': 'Butter', 'amount': 20, 'unit': 'g'}],
    'steps': ['Bohnen kochen.', 'Speck anbraten.', 'Alles in Butter schwenken.']},
  {'vegetable': 'Bohnen', 'title': 'Bohnensalat', 'description': 'Mit Vinaigrette.', 'prep_time_min': 15, 'cook_time_min': 10, 'servings': 4, 'difficulty': 'easy', 'category': 'salad', 'tags': ['vegan', 'meal-prep'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Grüne Bohnen', 'amount': 400, 'unit': 'g'}, {'item': 'Schalotten', 'amount': 2, 'unit': 'Stück'}, {'item': 'Olivenöl', 'amount': 4, 'unit': 'EL'}, {'item': 'Essig', 'amount': 2, 'unit': 'EL'}],
    'steps': ['Bohnen bissfest kochen.', 'Mit Dressing anmachen.', 'Schalotten unterheben.']},
  {'vegetable': 'Bohnen', 'title': 'Provenzalische Bohnen', 'description': 'Mit Tomaten und Oliven.', 'prep_time_min': 15, 'cook_time_min': 25, 'servings': 4, 'difficulty': 'easy', 'category': 'side', 'tags': ['vegan', 'mediterran'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Grüne Bohnen', 'amount': 500, 'unit': 'g'}, {'item': 'Cherrytomaten', 'amount': 250, 'unit': 'g'}, {'item': 'Oliven', 'amount': 80, 'unit': 'g'}, {'item': 'Olivenöl', 'amount': 4, 'unit': 'EL'}],
    'steps': ['Bohnen blanchieren.', 'Mit Tomaten und Oliven schmoren.']},

  // BROKKOLI
  {'vegetable': 'Brokkoli', 'title': 'Gebratener Brokkoli', 'description': 'Asiatisch mit Knoblauch.', 'prep_time_min': 10, 'cook_time_min': 10, 'servings': 4, 'difficulty': 'easy', 'category': 'side', 'tags': ['schnell', 'vegan'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Brokkoli', 'amount': 500, 'unit': 'g'}, {'item': 'Knoblauch', 'amount': 4, 'unit': 'Zehen'}, {'item': 'Sesamöl', 'amount': 2, 'unit': 'EL'}, {'item': 'Sojasauce', 'amount': 2, 'unit': 'EL'}],
    'steps': ['Brokkoli im Wok anbraten.', 'Knoblauch beigeben.', 'Mit Sojasauce ablöschen.']},
  {'vegetable': 'Brokkoli', 'title': 'Brokkoli-Crèmesuppe', 'description': 'Samtweich und gesund.', 'prep_time_min': 15, 'cook_time_min': 20, 'servings': 4, 'difficulty': 'easy', 'category': 'soup', 'tags': ['comfort-food'], 'is_vegetarian': true, 'contains_lactose': true,
    'ingredients': [{'item': 'Brokkoli', 'amount': 600, 'unit': 'g'}, {'item': 'Kartoffeln', 'amount': 200, 'unit': 'g'}, {'item': 'Bouillon', 'amount': 800, 'unit': 'ml'}, {'item': 'Rahm', 'amount': 100, 'unit': 'ml'}],
    'steps': ['Gemüse in Bouillon kochen.', 'Pürieren.', 'Rahm unterziehen.']},
  {'vegetable': 'Brokkoli', 'title': 'Brokkoli-Nudelauflauf', 'description': 'Familiengericht.', 'prep_time_min': 20, 'cook_time_min': 25, 'servings': 4, 'difficulty': 'easy', 'category': 'main', 'tags': ['kinderfreundlich'], 'is_vegetarian': true, 'contains_gluten': true, 'contains_lactose': true, 'contains_eggs': true,
    'ingredients': [{'item': 'Fusilli', 'amount': 300, 'unit': 'g'}, {'item': 'Brokkoli', 'amount': 400, 'unit': 'g'}, {'item': 'Rahm', 'amount': 250, 'unit': 'ml'}, {'item': 'Emmentaler', 'amount': 150, 'unit': 'g'}],
    'steps': ['Pasta und Brokkoli kochen.', 'Mit Rahm und Käse überbacken.']},

  // CHINAKOHL
  {'vegetable': 'Chinakohl', 'title': 'Asiatischer Chinakohlsalat', 'description': 'Knackig mit Sesam.', 'prep_time_min': 15, 'cook_time_min': 0, 'servings': 4, 'difficulty': 'easy', 'category': 'salad', 'tags': ['schnell', 'vegan'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Chinakohl', 'amount': 400, 'unit': 'g'}, {'item': 'Karotten', 'amount': 2, 'unit': 'Stück'}, {'item': 'Sesamöl', 'amount': 2, 'unit': 'EL'}, {'item': 'Sesam', 'amount': 2, 'unit': 'EL'}],
    'steps': ['Chinakohl in Streifen schneiden.', 'Mit Dressing anmachen.', 'Mit Sesam bestreuen.']},
  {'vegetable': 'Chinakohl', 'title': 'Chinakohl aus dem Wok', 'description': 'Schnell gebraten.', 'prep_time_min': 10, 'cook_time_min': 8, 'servings': 4, 'difficulty': 'easy', 'category': 'side', 'tags': ['schnell', 'vegan'], 'is_vegetarian': true, 'is_vegan': true,
    'ingredients': [{'item': 'Chinakohl', 'amount': 500, 'unit': 'g'}, {'item': 'Ingwer', 'amount': 20, 'unit': 'g'}, {'item': 'Sojasauce', 'amount': 2, 'unit': 'EL'}, {'item': 'Rapsöl', 'amount': 2, 'unit': 'EL'}],
    'steps': ['Chinakohl in Stücke schneiden.', 'Im Wok mit Ingwer anbraten.', 'Mit Sojasauce würzen.']},
  {'vegetable': 'Chinakohl', 'title': 'Chinakohlwickel', 'description': 'Low-Carb Wraps.', 'prep_time_min': 20, 'cook_time_min': 15, 'servings': 4, 'difficulty': 'medium', 'category': 'main', 'tags': ['low-carb'],
    'ingredients': [{'item': 'Chinakohl', 'amount': 8, 'unit': 'Blätter'}, {'item': 'Hackfleisch', 'amount': 400, 'unit': 'g'}, {'item': 'Karotten', 'amount': 1, 'unit': 'Stück'}, {'item': 'Sojasauce', 'amount': 3, 'unit': 'EL'}],
    'steps': ['Blätter blanchieren.', 'Hackfleisch mit Gemüse braten.', 'In Blätter einrollen und dämpfen.']},

  // Add all recipes from other parts
  ...recipesPartTwo,
  ...recipesPartThree,
  ...recipesPartFour,
];
