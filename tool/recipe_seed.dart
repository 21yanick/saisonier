// ignore_for_file: avoid_print, depend_on_referenced_packages
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Seed-Script für Rezepte mit dem neuen Schema (Phase 12b)
///
/// Verwendung:
///   cd tool && dart run recipe_seed.dart
///
/// Voraussetzungen:
///   - PocketBase läuft (lokal oder remote)
///   - Admin-Account existiert
///   - Vegetables wurden bereits geseeded (seed_data.dart)

Future<void> main() async {
  // === Konfiguration ===
  final baseUrl = Platform.environment['PB_URL'] ?? 'https://saisonier-api.21home.ch';
  final adminEmail = Platform.environment['PB_EMAIL'] ?? 'admin@saisonier.ch';
  final adminPass = Platform.environment['PB_PASS'] ?? 'saisonier123';

  print('🍳 Recipe Seeder für Saisonier');
  print('   Server: $baseUrl');
  print('');

  // === 1. Authentifizierung ===
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

  // === 2. Vegetable-IDs laden ===
  print('📦 Lade Vegetables...');
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
    print('   ${vegIdMap.length} Vegetables geladen');
  } else {
    print('❌ Konnte Vegetables nicht laden');
    exit(1);
  }

  // === 3. Rezepte seeden ===
  print('');
  print('🥗 Seede Rezepte...');

  int created = 0;
  int skipped = 0;
  int failed = 0;

  for (final recipe in recipes) {
    final title = recipe['title'] as String;
    final vegName = recipe['vegetable'] as String?;
    final vegId = vegName != null ? vegIdMap[vegName] : null;

    if (vegName != null && vegId == null) {
      print('   ⚠️  $title: Vegetable "$vegName" nicht gefunden, überspringe');
      skipped++;
      continue;
    }

    // Prüfe ob Rezept existiert
    final existsRes = await http.get(
      Uri.parse('$baseUrl/api/collections/recipes/records?filter=title="$title"'),
      headers: headers,
    );

    if (existsRes.statusCode == 200 &&
        (jsonDecode(existsRes.body)['totalItems'] ?? 0) > 0) {
      print('   ⏭️  $title existiert bereits');
      skipped++;
      continue;
    }

    // Rezept erstellen
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
  print('   ⏭️  Übersprungen: $skipped');
  print('   ❌ Fehlgeschlagen: $failed');
  print('═══════════════════════════════════════');
}

// ═══════════════════════════════════════════════════════════════════════════
// REZEPT-DATEN
// ═══════════════════════════════════════════════════════════════════════════

final recipes = [
  // ═══════════════════════════════════════════════════════════════════════════
  // KARTOFFELN
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Kartoffeln festkochend',
    'title': 'Klassische Berner Rösti',
    'description': 'Die original Schweizer Rösti aus dem Berner Oberland - goldbraun und knusprig.',
    'prep_time_min': 30,
    'cook_time_min': 20,
    'servings': 4,
    'difficulty': 'easy',
    'category': 'side',
    'tags': ['schweizer-klassiker', 'comfort-food'],
    'is_vegetarian': true,
    'contains_lactose': true,
    'ingredients': [
      {'item': 'Festkochende Kartoffeln', 'amount': 1000, 'unit': 'g', 'note': 'vom Vortag gekocht'},
      {'item': 'Butter', 'amount': 40, 'unit': 'g'},
      {'item': 'Salz', 'amount': 1, 'unit': 'TL'},
      {'item': 'Pfeffer', 'note': 'nach Geschmack'},
    ],
    'steps': [
      'Kartoffeln am Vortag in der Schale weich kochen, abkühlen lassen und über Nacht kühl stellen.',
      'Kartoffeln schälen und an der Röstiraffel grob reiben.',
      'Butter in einer grossen Bratpfanne erhitzen.',
      'Kartoffeln beigeben, salzen und unter gelegentlichem Wenden 5 Minuten anbraten.',
      'Mit einem Pfannenwender zu einem flachen Kuchen formen.',
      'Bei mittlerer Hitze 10 Minuten braten, bis die Unterseite goldbraun ist.',
      'Rösti auf einen Teller stürzen, zurückgleiten lassen und weitere 10 Minuten fertig braten.',
    ],
  },
  {
    'vegetable': 'Kartoffeln mehligkochend',
    'title': 'Cremiges Kartoffelstock',
    'description': 'Samtiger Kartoffelstock wie bei Grossmutter - das perfekte Comfort Food.',
    'prep_time_min': 15,
    'cook_time_min': 25,
    'servings': 4,
    'difficulty': 'easy',
    'category': 'side',
    'tags': ['comfort-food', 'kinderfreundlich'],
    'is_vegetarian': true,
    'contains_lactose': true,
    'ingredients': [
      {'item': 'Mehligkochende Kartoffeln', 'amount': 800, 'unit': 'g'},
      {'item': 'Butter', 'amount': 60, 'unit': 'g'},
      {'item': 'Vollmilch', 'amount': 200, 'unit': 'ml', 'note': 'warm'},
      {'item': 'Muskatnuss', 'amount': 1, 'unit': 'Prise', 'note': 'frisch gerieben'},
      {'item': 'Salz', 'note': 'nach Geschmack'},
    ],
    'steps': [
      'Kartoffeln schälen und in gleichmässige Stücke schneiden.',
      'In reichlich Salzwasser ca. 20 Minuten weich kochen.',
      'Abgiessen und kurz ausdampfen lassen.',
      'Milch mit Butter in einem kleinen Topf erwärmen.',
      'Kartoffeln durch eine Kartoffelpresse drücken oder mit dem Stampfer zerdrücken.',
      'Warme Milch-Butter nach und nach unterrühren bis die gewünschte Konsistenz erreicht ist.',
      'Mit Muskatnuss und Salz abschmecken.',
    ],
  },
  {
    'vegetable': 'Frühkartoffeln',
    'title': 'Gschwellti mit Alpkäse',
    'description': 'Einfaches Schweizer Traditionsgericht - Pellkartoffeln mit würzigem Alpkäse.',
    'prep_time_min': 5,
    'cook_time_min': 25,
    'servings': 4,
    'difficulty': 'easy',
    'category': 'main',
    'tags': ['schweizer-klassiker', 'schnell'],
    'is_vegetarian': true,
    'contains_lactose': true,
    'ingredients': [
      {'item': 'Frühkartoffeln', 'amount': 1000, 'unit': 'g', 'note': 'kleine'},
      {'item': 'Gruyère AOP', 'amount': 200, 'unit': 'g'},
      {'item': 'Butter', 'amount': 30, 'unit': 'g'},
      {'item': 'Schnittlauch', 'amount': 1, 'unit': 'Bund'},
      {'item': 'Fleur de Sel', 'note': 'zum Servieren'},
    ],
    'steps': [
      'Frühkartoffeln gründlich waschen, Schale dran lassen.',
      'In Salzwasser ca. 20-25 Minuten weich kochen.',
      'Abgiessen und kurz ausdampfen lassen.',
      'Mit Butter schwenken.',
      'Käse in Scheiben oder Würfel schneiden.',
      'Schnittlauch fein schneiden.',
      'Kartoffeln mit Käse, Schnittlauch und etwas Fleur de Sel servieren.',
    ],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // KAROTTEN
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Karotten',
    'title': 'Aargauer Rüeblisuppe',
    'description': 'Samtige Karottensuppe mit einem Hauch Ingwer - wärmt von innen.',
    'prep_time_min': 15,
    'cook_time_min': 25,
    'servings': 4,
    'difficulty': 'easy',
    'category': 'soup',
    'tags': ['gesund', 'meal-prep'],
    'is_vegetarian': true,
    'is_vegan': false,
    'contains_lactose': true,
    'ingredients': [
      {'item': 'Karotten', 'amount': 600, 'unit': 'g'},
      {'item': 'Zwiebel', 'amount': 1, 'unit': 'Stück'},
      {'item': 'Ingwer', 'amount': 20, 'unit': 'g', 'note': 'frisch'},
      {'item': 'Gemüsebouillon', 'amount': 800, 'unit': 'ml'},
      {'item': 'Rahm', 'amount': 100, 'unit': 'ml'},
      {'item': 'Butter', 'amount': 20, 'unit': 'g'},
      {'item': 'Salz und Pfeffer', 'note': 'nach Geschmack'},
    ],
    'steps': [
      'Karotten schälen und in Scheiben schneiden.',
      'Zwiebel und Ingwer fein hacken.',
      'Butter in einem Topf erhitzen, Zwiebel und Ingwer darin andünsten.',
      'Karotten beigeben und kurz mitdünsten.',
      'Mit Bouillon ablöschen und 20 Minuten köcheln lassen.',
      'Mit dem Stabmixer fein pürieren.',
      'Rahm unterrühren und mit Salz und Pfeffer abschmecken.',
    ],
  },
  {
    'vegetable': 'Karotten',
    'title': 'Glasierte Honig-Rüebli',
    'description': 'Süss-würzige Karotten als elegante Beilage.',
    'prep_time_min': 10,
    'cook_time_min': 15,
    'servings': 4,
    'difficulty': 'easy',
    'category': 'side',
    'tags': ['schnell', 'gesund'],
    'is_vegetarian': true,
    'contains_lactose': true,
    'ingredients': [
      {'item': 'Karotten', 'amount': 500, 'unit': 'g', 'note': 'junge'},
      {'item': 'Butter', 'amount': 30, 'unit': 'g'},
      {'item': 'Honig', 'amount': 2, 'unit': 'EL'},
      {'item': 'Thymian', 'amount': 3, 'unit': 'Stück', 'note': 'Zweige'},
      {'item': 'Salz', 'amount': 0.5, 'unit': 'TL'},
    ],
    'steps': [
      'Karotten schälen und schräg in Scheiben schneiden.',
      'In wenig Salzwasser ca. 8 Minuten bissfest kochen.',
      'Abgiessen und gut abtropfen lassen.',
      'Butter in einer Pfanne schmelzen.',
      'Honig einrühren und Karotten beigeben.',
      'Thymian dazugeben und unter Schwenken glasieren bis leicht karamellisiert.',
    ],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // KÜRBIS
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Kürbis',
    'title': 'Kürbissuppe mit Kokosmilch',
    'description': 'Cremige Herbstsuppe mit exotischer Note.',
    'prep_time_min': 15,
    'cook_time_min': 25,
    'servings': 4,
    'difficulty': 'easy',
    'category': 'soup',
    'tags': ['vegan', 'gesund', 'meal-prep'],
    'is_vegetarian': true,
    'is_vegan': true,
    'ingredients': [
      {'item': 'Kürbis (Butternut)', 'amount': 800, 'unit': 'g'},
      {'item': 'Zwiebel', 'amount': 1, 'unit': 'Stück'},
      {'item': 'Knoblauch', 'amount': 2, 'unit': 'Stück', 'note': 'Zehen'},
      {'item': 'Ingwer', 'amount': 30, 'unit': 'g'},
      {'item': 'Kokosmilch', 'amount': 400, 'unit': 'ml'},
      {'item': 'Gemüsebouillon', 'amount': 400, 'unit': 'ml'},
      {'item': 'Olivenöl', 'amount': 2, 'unit': 'EL'},
      {'item': 'Kürbiskerne', 'amount': 30, 'unit': 'g', 'note': 'zum Garnieren'},
    ],
    'steps': [
      'Kürbis schälen, entkernen und würfeln.',
      'Zwiebel, Knoblauch und Ingwer fein hacken.',
      'Öl erhitzen und Zwiebel, Knoblauch, Ingwer andünsten.',
      'Kürbiswürfel beigeben und kurz mitrösten.',
      'Mit Bouillon ablöschen und 20 Minuten köcheln.',
      'Kokosmilch beigeben und fein pürieren.',
      'Mit gerösteten Kürbiskernen servieren.',
    ],
  },
  {
    'vegetable': 'Kürbis',
    'title': 'Ofenkürbis mit Feta und Thymian',
    'description': 'Einfaches Ofengericht - aussen karamellisiert, innen butterzart.',
    'prep_time_min': 10,
    'cook_time_min': 35,
    'servings': 4,
    'difficulty': 'easy',
    'category': 'main',
    'tags': ['one-pot', 'gesund'],
    'is_vegetarian': true,
    'contains_lactose': true,
    'ingredients': [
      {'item': 'Hokkaido-Kürbis', 'amount': 1000, 'unit': 'g'},
      {'item': 'Feta', 'amount': 150, 'unit': 'g'},
      {'item': 'Olivenöl', 'amount': 4, 'unit': 'EL'},
      {'item': 'Thymian', 'amount': 1, 'unit': 'Bund'},
      {'item': 'Honig', 'amount': 2, 'unit': 'EL'},
      {'item': 'Kürbiskerne', 'amount': 40, 'unit': 'g'},
      {'item': 'Salz und Pfeffer', 'note': 'nach Geschmack'},
    ],
    'steps': [
      'Ofen auf 200°C vorheizen.',
      'Kürbis halbieren, entkernen und in Spalten schneiden (Schale dran lassen bei Hokkaido).',
      'Spalten auf ein Backblech legen und mit Olivenöl beträufeln.',
      'Mit Salz, Pfeffer und Thymianblättchen würzen.',
      '25 Minuten rösten bis der Kürbis weich ist.',
      'Feta darüberbröckeln, Kürbiskerne verteilen.',
      'Weitere 10 Minuten backen.',
      'Mit Honig beträufeln und servieren.',
    ],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // LAUCH
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Lauch',
    'title': 'Klassische Lauchwähe',
    'description': 'Schweizer Gemüsewähe mit cremiger Füllung.',
    'prep_time_min': 20,
    'cook_time_min': 35,
    'servings': 6,
    'difficulty': 'medium',
    'category': 'main',
    'tags': ['schweizer-klassiker'],
    'is_vegetarian': true,
    'contains_gluten': true,
    'contains_lactose': true,
    'contains_eggs': true,
    'ingredients': [
      {'item': 'Kuchenteig (rund)', 'amount': 1, 'unit': 'Stück'},
      {'item': 'Lauch', 'amount': 600, 'unit': 'g'},
      {'item': 'Speckwürfeli', 'amount': 100, 'unit': 'g'},
      {'item': 'Eier', 'amount': 3, 'unit': 'Stück'},
      {'item': 'Rahm', 'amount': 200, 'unit': 'ml'},
      {'item': 'Gruyère', 'amount': 100, 'unit': 'g', 'note': 'gerieben'},
      {'item': 'Muskatnuss', 'amount': 1, 'unit': 'Prise'},
    ],
    'steps': [
      'Ofen auf 200°C vorheizen.',
      'Teig in eine Wähenform legen und mit einer Gabel einstechen.',
      'Lauch in Ringe schneiden und gründlich waschen.',
      'Speck in einer Pfanne anbraten, Lauch beigeben und 5 Minuten dünsten.',
      'Eier mit Rahm und Muskatnuss verquirlen, würzen.',
      'Lauch-Speck-Mischung auf dem Teig verteilen.',
      'Guss darübergiessen und mit Käse bestreuen.',
      'Ca. 30-35 Minuten goldbraun backen.',
    ],
  },
  {
    'vegetable': 'Lauch',
    'title': 'Lauch-Kartoffel-Suppe',
    'description': 'Cremige Wintersuppe - einfach und wärmend.',
    'prep_time_min': 15,
    'cook_time_min': 25,
    'servings': 4,
    'difficulty': 'easy',
    'category': 'soup',
    'tags': ['comfort-food', 'günstig'],
    'is_vegetarian': true,
    'contains_lactose': true,
    'ingredients': [
      {'item': 'Lauch', 'amount': 400, 'unit': 'g'},
      {'item': 'Kartoffeln', 'amount': 300, 'unit': 'g'},
      {'item': 'Gemüsebouillon', 'amount': 1000, 'unit': 'ml'},
      {'item': 'Rahm', 'amount': 100, 'unit': 'ml'},
      {'item': 'Butter', 'amount': 30, 'unit': 'g'},
      {'item': 'Schnittlauch', 'amount': 2, 'unit': 'EL', 'note': 'zum Garnieren'},
    ],
    'steps': [
      'Lauch putzen, längs halbieren, waschen und in Ringe schneiden.',
      'Kartoffeln schälen und würfeln.',
      'Butter schmelzen und Lauch 5 Minuten andünsten.',
      'Kartoffeln beigeben, mit Bouillon ablöschen.',
      '20 Minuten köcheln bis Kartoffeln weich sind.',
      'Pürieren, Rahm unterziehen.',
      'Mit Schnittlauch garniert servieren.',
    ],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // SPINAT
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Spinat',
    'title': 'Spinatwähe',
    'description': 'Knusprige Wähe mit cremiger Spinatfüllung.',
    'prep_time_min': 20,
    'cook_time_min': 35,
    'servings': 6,
    'difficulty': 'medium',
    'category': 'main',
    'tags': ['schweizer-klassiker'],
    'is_vegetarian': true,
    'contains_gluten': true,
    'contains_lactose': true,
    'contains_eggs': true,
    'ingredients': [
      {'item': 'Kuchenteig', 'amount': 1, 'unit': 'Stück'},
      {'item': 'Blattspinat', 'amount': 500, 'unit': 'g'},
      {'item': 'Zwiebel', 'amount': 1, 'unit': 'Stück'},
      {'item': 'Knoblauch', 'amount': 1, 'unit': 'Stück', 'note': 'Zehe'},
      {'item': 'Eier', 'amount': 3, 'unit': 'Stück'},
      {'item': 'Rahm', 'amount': 200, 'unit': 'ml'},
      {'item': 'Sbrinz', 'amount': 50, 'unit': 'g', 'note': 'gerieben'},
      {'item': 'Muskatnuss', 'amount': 1, 'unit': 'Prise'},
    ],
    'steps': [
      'Ofen auf 200°C vorheizen.',
      'Teig in Form legen und einstechen.',
      'Spinat waschen, blanchieren, abschrecken und gut ausdrücken.',
      'Spinat grob hacken.',
      'Zwiebel und Knoblauch fein hacken und andünsten.',
      'Spinat beigeben und kurz mitdünsten.',
      'Eier mit Rahm und Muskatnuss verquirlen.',
      'Spinat auf Teig verteilen, Guss darüber, Käse bestreuen.',
      'Ca. 30-35 Minuten backen.',
    ],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // SPARGEL
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Spargel',
    'title': 'Spargeln mit Sauce Hollandaise',
    'description': 'Klassiker der Frühlingssaison - weisse Spargeln mit samtiger Buttersauce.',
    'prep_time_min': 20,
    'cook_time_min': 20,
    'servings': 4,
    'difficulty': 'medium',
    'category': 'main',
    'tags': ['schweizer-klassiker'],
    'is_vegetarian': true,
    'contains_lactose': true,
    'contains_eggs': true,
    'ingredients': [
      {'item': 'Weisse Spargeln', 'amount': 1000, 'unit': 'g'},
      {'item': 'Butter', 'amount': 150, 'unit': 'g'},
      {'item': 'Eigelb', 'amount': 3, 'unit': 'Stück'},
      {'item': 'Zitronensaft', 'amount': 1, 'unit': 'EL'},
      {'item': 'Zucker', 'amount': 1, 'unit': 'TL'},
      {'item': 'Salz', 'note': 'nach Geschmack'},
    ],
    'steps': [
      'Spargeln vom Kopf her schälen, holzige Enden abschneiden.',
      'In Salzwasser mit Zucker ca. 15 Minuten kochen bis bissfest.',
      'Für die Sauce: Butter schmelzen und leicht abkühlen lassen.',
      'Eigelb mit 2 EL Wasser über dem Wasserbad schaumig schlagen.',
      'Flüssige Butter langsam in dünnem Strahl einrühren.',
      'Mit Zitronensaft und Salz abschmecken.',
      'Spargeln mit Sauce servieren, dazu passen Gschwellti.',
    ],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // TOMATEN
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Tomaten',
    'title': 'Caprese Salat',
    'description': 'Italienischer Klassiker - reife Tomaten mit cremigem Mozzarella.',
    'prep_time_min': 10,
    'cook_time_min': 0,
    'servings': 4,
    'difficulty': 'easy',
    'category': 'salad',
    'tags': ['schnell', 'gesund', 'party'],
    'is_vegetarian': true,
    'contains_lactose': true,
    'ingredients': [
      {'item': 'Tomaten', 'amount': 4, 'unit': 'Stück', 'note': 'grosse, reife'},
      {'item': 'Mozzarella di Bufala', 'amount': 250, 'unit': 'g'},
      {'item': 'Basilikum', 'amount': 1, 'unit': 'Bund'},
      {'item': 'Olivenöl extra vergine', 'amount': 4, 'unit': 'EL'},
      {'item': 'Balsamico', 'amount': 1, 'unit': 'EL', 'note': 'optional'},
      {'item': 'Fleur de Sel', 'note': 'nach Geschmack'},
      {'item': 'Pfeffer', 'note': 'frisch gemahlen'},
    ],
    'steps': [
      'Tomaten in Scheiben schneiden.',
      'Mozzarella abtropfen lassen und in Scheiben schneiden.',
      'Tomaten und Mozzarella abwechselnd auf einem Teller anrichten.',
      'Basilikumblätter darauf verteilen.',
      'Mit Olivenöl beträufeln.',
      'Mit Fleur de Sel und Pfeffer würzen.',
      'Optional mit etwas Balsamico verfeinern.',
    ],
  },
  {
    'vegetable': 'Tomaten',
    'title': 'Gefüllte Tomaten mit Reis',
    'description': 'Mediterrane gefüllte Tomaten - herzhaft und aromatisch.',
    'prep_time_min': 25,
    'cook_time_min': 30,
    'servings': 4,
    'difficulty': 'medium',
    'category': 'main',
    'tags': ['meal-prep'],
    'is_vegetarian': true,
    'contains_lactose': true,
    'ingredients': [
      {'item': 'Fleischtomaten', 'amount': 8, 'unit': 'Stück', 'note': 'grosse'},
      {'item': 'Reis', 'amount': 150, 'unit': 'g'},
      {'item': 'Feta', 'amount': 100, 'unit': 'g'},
      {'item': 'Oliven', 'amount': 50, 'unit': 'g', 'note': 'schwarz, entsteint'},
      {'item': 'Petersilie', 'amount': 3, 'unit': 'EL', 'note': 'gehackt'},
      {'item': 'Olivenöl', 'amount': 3, 'unit': 'EL'},
    ],
    'steps': [
      'Ofen auf 180°C vorheizen.',
      'Reis nach Packungsanleitung kochen und abkühlen lassen.',
      'Tomatendeckel abschneiden und Tomaten vorsichtig aushöhlen.',
      'Fruchtfleisch grob hacken.',
      'Reis mit zerbröckeltem Feta, gehackten Oliven, Petersilie und Tomatenfruchtfleisch mischen.',
      'Mit Salz und Pfeffer würzen.',
      'Tomaten füllen und Deckel aufsetzen.',
      'Mit Olivenöl beträufeln und ca. 25-30 Minuten backen.',
    ],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // ZUCCHETTI
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Zucchetti',
    'title': 'Zucchetti-Puffer mit Kräuterquark',
    'description': 'Knusprige Gemüsepuffer - perfekt als Vorspeise oder leichtes Hauptgericht.',
    'prep_time_min': 20,
    'cook_time_min': 15,
    'servings': 4,
    'difficulty': 'easy',
    'category': 'main',
    'tags': ['schnell', 'kinderfreundlich'],
    'is_vegetarian': true,
    'contains_gluten': true,
    'contains_lactose': true,
    'contains_eggs': true,
    'ingredients': [
      {'item': 'Zucchetti', 'amount': 500, 'unit': 'g'},
      {'item': 'Eier', 'amount': 2, 'unit': 'Stück'},
      {'item': 'Mehl', 'amount': 50, 'unit': 'g'},
      {'item': 'Parmesan', 'amount': 50, 'unit': 'g', 'note': 'gerieben'},
      {'item': 'Quark', 'amount': 200, 'unit': 'g'},
      {'item': 'Schnittlauch', 'amount': 2, 'unit': 'EL'},
      {'item': 'Rapsöl', 'amount': 4, 'unit': 'EL'},
      {'item': 'Salz', 'amount': 1, 'unit': 'TL'},
    ],
    'steps': [
      'Zucchetti grob raffeln, salzen und 10 Minuten ziehen lassen.',
      'Gut ausdrücken um überschüssige Flüssigkeit zu entfernen.',
      'Mit Eiern, Mehl und Parmesan mischen.',
      'Mit Pfeffer würzen.',
      'Öl in einer Pfanne erhitzen.',
      'Kleine Puffer formen und beidseitig ca. 3-4 Minuten goldbraun braten.',
      'Quark mit Schnittlauch und Salz mischen.',
      'Puffer mit Kräuterquark servieren.',
    ],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // ERDBEEREN
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Erdbeeren',
    'title': 'Erdbeeren mit Schlagrahm',
    'description': 'Einfach und himmlisch - frische Erdbeeren mit hausgemachtem Schlagrahm.',
    'prep_time_min': 10,
    'cook_time_min': 0,
    'servings': 4,
    'difficulty': 'easy',
    'category': 'dessert',
    'tags': ['schnell', 'party'],
    'is_vegetarian': true,
    'contains_lactose': true,
    'ingredients': [
      {'item': 'Erdbeeren', 'amount': 500, 'unit': 'g'},
      {'item': 'Vollrahm', 'amount': 300, 'unit': 'ml'},
      {'item': 'Puderzucker', 'amount': 2, 'unit': 'EL'},
      {'item': 'Vanillezucker', 'amount': 1, 'unit': 'Stück', 'note': 'Päckchen'},
    ],
    'steps': [
      'Erdbeeren waschen und rüsten.',
      'Je nach Grösse halbieren oder vierteln.',
      'Rahm mit Puderzucker und Vanillezucker steif schlagen.',
      'Erdbeeren auf Schälchen verteilen.',
      'Grosszügig Schlagrahm darübergeben.',
      'Sofort servieren.',
    ],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // ÄPFEL
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Äpfel Herbst',
    'title': 'Grossmutters Apfelwähe',
    'description': 'Traditionelle Schweizer Apfelwähe mit Rahmguss.',
    'prep_time_min': 25,
    'cook_time_min': 40,
    'servings': 8,
    'difficulty': 'medium',
    'category': 'dessert',
    'tags': ['schweizer-klassiker', 'party'],
    'is_vegetarian': true,
    'contains_gluten': true,
    'contains_lactose': true,
    'contains_eggs': true,
    'ingredients': [
      {'item': 'Kuchenteig', 'amount': 1, 'unit': 'Stück', 'note': 'rund'},
      {'item': 'Äpfel', 'amount': 4, 'unit': 'Stück', 'note': 'säuerliche Sorte'},
      {'item': 'Eier', 'amount': 2, 'unit': 'Stück'},
      {'item': 'Rahm', 'amount': 200, 'unit': 'ml'},
      {'item': 'Zucker', 'amount': 80, 'unit': 'g'},
      {'item': 'Zimt', 'amount': 1, 'unit': 'TL'},
    ],
    'steps': [
      'Ofen auf 200°C vorheizen.',
      'Teig in eine gefettete Form legen und mit einer Gabel einstechen.',
      'Äpfel schälen, vierteln, entkernen und in Spalten schneiden.',
      'Apfelspalten dachziegelartig auf dem Teig anordnen.',
      'Eier mit Rahm und Zucker verquirlen.',
      'Guss über die Äpfel giessen.',
      'Mit Zimt bestreuen.',
      'Ca. 35-40 Minuten goldbraun backen.',
    ],
  },
  {
    'vegetable': 'Äpfel Lager',
    'title': 'Öpfelchüechli',
    'description': 'Traditionelle Schweizer Apfelküchlein - knusprig und süss.',
    'prep_time_min': 25,
    'cook_time_min': 20,
    'servings': 4,
    'difficulty': 'medium',
    'category': 'dessert',
    'tags': ['schweizer-klassiker', 'kinderfreundlich'],
    'is_vegetarian': true,
    'contains_gluten': true,
    'contains_lactose': true,
    'contains_eggs': true,
    'ingredients': [
      {'item': 'Äpfel', 'amount': 4, 'unit': 'Stück', 'note': 'säuerlich'},
      {'item': 'Mehl', 'amount': 150, 'unit': 'g'},
      {'item': 'Ei', 'amount': 1, 'unit': 'Stück'},
      {'item': 'Milch', 'amount': 200, 'unit': 'ml'},
      {'item': 'Zucker', 'amount': 2, 'unit': 'EL'},
      {'item': 'Zimt', 'amount': 2, 'unit': 'TL'},
      {'item': 'Rapsöl', 'note': 'zum Ausbacken'},
    ],
    'steps': [
      'Mehl, Ei, Milch und 1 EL Zucker zu einem glatten Teig verrühren.',
      'Teig 15 Minuten ruhen lassen.',
      'Äpfel schälen, Kerngehäuse ausstechen, in ca. 1 cm dicke Ringe schneiden.',
      'Öl in einem Topf auf ca. 175°C erhitzen.',
      'Apfelringe durch den Teig ziehen.',
      'Im heissen Öl goldbraun ausbacken.',
      'Auf Küchenpapier abtropfen lassen.',
      'Mit Zimtzucker bestreuen und warm servieren.',
    ],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // RHABARBER
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Rhabarber',
    'title': 'Rhabarberkompott',
    'description': 'Süss-saures Kompott - perfekt zu Vanilleglace oder Joghurt.',
    'prep_time_min': 10,
    'cook_time_min': 10,
    'servings': 4,
    'difficulty': 'easy',
    'category': 'dessert',
    'tags': ['schnell', 'meal-prep'],
    'is_vegetarian': true,
    'is_vegan': true,
    'ingredients': [
      {'item': 'Rhabarber', 'amount': 500, 'unit': 'g'},
      {'item': 'Zucker', 'amount': 100, 'unit': 'g'},
      {'item': 'Wasser', 'amount': 100, 'unit': 'ml'},
      {'item': 'Vanilleschote', 'amount': 0.5, 'unit': 'Stück'},
    ],
    'steps': [
      'Rhabarber waschen und in ca. 2 cm Stücke schneiden.',
      'Zucker mit Wasser in einem Topf aufkochen.',
      'Vanillemark auskratzen und beigeben.',
      'Rhabarber in den Sirup geben.',
      'Bei kleiner Hitze 5-8 Minuten köcheln.',
      'Nicht zu stark rühren, damit die Stücke erhalten bleiben.',
      'Warm oder kalt servieren.',
    ],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // FEDERKOHL / KALE
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Federkohl',
    'title': 'Knusprige Federkohl-Chips',
    'description': 'Gesunder Snack aus dem Ofen - würzig und knusprig.',
    'prep_time_min': 10,
    'cook_time_min': 20,
    'servings': 4,
    'difficulty': 'easy',
    'category': 'snack',
    'tags': ['gesund', 'vegan'],
    'is_vegetarian': true,
    'is_vegan': true,
    'ingredients': [
      {'item': 'Federkohl', 'amount': 200, 'unit': 'g'},
      {'item': 'Olivenöl', 'amount': 2, 'unit': 'EL'},
      {'item': 'Salz', 'amount': 0.5, 'unit': 'TL'},
      {'item': 'Paprikapulver', 'amount': 0.5, 'unit': 'TL', 'note': 'optional'},
    ],
    'steps': [
      'Ofen auf 150°C vorheizen.',
      'Federkohl waschen und sehr gut trocknen.',
      'Blätter von den Stielen zupfen und in mundgerechte Stücke reissen.',
      'Mit Olivenöl und Gewürzen in einer Schüssel massieren.',
      'Auf einem Backblech verteilen ohne Überlappen.',
      'Ca. 15-20 Minuten backen bis knusprig.',
      'Sofort servieren - werden schnell weich!',
    ],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // WIRZ / WIRSING
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Wirz',
    'title': 'Wirzrouladen',
    'description': 'Deftige Kohlrouladen mit Hackfleischfüllung.',
    'prep_time_min': 30,
    'cook_time_min': 50,
    'servings': 4,
    'difficulty': 'medium',
    'category': 'main',
    'tags': ['comfort-food'],
    'contains_gluten': true,
    'contains_eggs': true,
    'ingredients': [
      {'item': 'Wirzblätter', 'amount': 8, 'unit': 'Stück', 'note': 'grosse'},
      {'item': 'Hackfleisch gemischt', 'amount': 400, 'unit': 'g'},
      {'item': 'Zwiebel', 'amount': 1, 'unit': 'Stück'},
      {'item': 'Ei', 'amount': 1, 'unit': 'Stück'},
      {'item': 'Paniermehl', 'amount': 2, 'unit': 'EL'},
      {'item': 'Tomatensauce', 'amount': 400, 'unit': 'ml'},
      {'item': 'Rindbouillon', 'amount': 200, 'unit': 'ml'},
    ],
    'steps': [
      'Wirzblätter 3 Minuten in Salzwasser blanchieren, abschrecken.',
      'Dicke Mittelrippe flach schneiden.',
      'Zwiebel fein hacken.',
      'Hackfleisch mit Zwiebel, Ei, Paniermehl, Salz und Pfeffer mischen.',
      'Füllung auf Blätter verteilen und einrollen.',
      'Rouladen in einer Bratpfanne von allen Seiten anbraten.',
      'Tomatensauce und Bouillon beigeben.',
      '40-50 Minuten bei kleiner Hitze schmoren.',
    ],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // NÜSSLISALAT
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Nüsslisalat',
    'title': 'Nüsslisalat mit Speck und Ei',
    'description': 'Klassischer Wintersalat mit wachsweichem Ei.',
    'prep_time_min': 15,
    'cook_time_min': 10,
    'servings': 4,
    'difficulty': 'easy',
    'category': 'salad',
    'tags': ['schnell'],
    'contains_eggs': true,
    'ingredients': [
      {'item': 'Nüsslisalat', 'amount': 200, 'unit': 'g'},
      {'item': 'Speckwürfeli', 'amount': 100, 'unit': 'g'},
      {'item': 'Eier', 'amount': 4, 'unit': 'Stück'},
      {'item': 'Weissweinessig', 'amount': 2, 'unit': 'EL'},
      {'item': 'Rapsöl', 'amount': 4, 'unit': 'EL'},
      {'item': 'Senf', 'amount': 1, 'unit': 'TL'},
    ],
    'steps': [
      'Nüsslisalat waschen und gut trocknen.',
      'Speck in einer Pfanne knusprig braten.',
      'Eier 6 Minuten wachsweich kochen, abschrecken.',
      'Für die Sauce: Essig mit Senf und etwas Salz verrühren.',
      'Öl langsam einrühren.',
      'Salat mit Sauce mischen und auf Tellern anrichten.',
      'Mit Speck und halbierten Eiern garnieren.',
    ],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // ROSENKOHL
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Rosenkohl',
    'title': 'Gebratener Rosenkohl mit Speck',
    'description': 'So lieben alle Rosenkohl - knusprig angebraten mit würzigem Speck.',
    'prep_time_min': 10,
    'cook_time_min': 15,
    'servings': 4,
    'difficulty': 'easy',
    'category': 'side',
    'tags': ['schnell'],
    'contains_lactose': true,
    'ingredients': [
      {'item': 'Rosenkohl', 'amount': 500, 'unit': 'g'},
      {'item': 'Speckwürfeli', 'amount': 100, 'unit': 'g'},
      {'item': 'Butter', 'amount': 30, 'unit': 'g'},
      {'item': 'Muskatnuss', 'amount': 1, 'unit': 'Prise'},
    ],
    'steps': [
      'Rosenkohl putzen und halbieren.',
      'In Salzwasser 5 Minuten blanchieren, abschrecken.',
      'Speck in einer grossen Pfanne knusprig braten.',
      'Butter beigeben und Rosenkohl bei hoher Hitze anbraten.',
      'Wenden bis er leicht karamellisiert ist.',
      'Mit Muskatnuss, Salz und Pfeffer würzen.',
    ],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // FENCHEL
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Fenchel',
    'title': 'Fenchel-Orangen-Salat',
    'description': 'Erfrischender Salat mit Zitrusnote.',
    'prep_time_min': 15,
    'cook_time_min': 0,
    'servings': 4,
    'difficulty': 'easy',
    'category': 'salad',
    'tags': ['gesund', 'vegan'],
    'is_vegetarian': true,
    'is_vegan': true,
    'ingredients': [
      {'item': 'Fenchel', 'amount': 2, 'unit': 'Stück', 'note': 'Knollen'},
      {'item': 'Orangen', 'amount': 2, 'unit': 'Stück'},
      {'item': 'Olivenöl', 'amount': 3, 'unit': 'EL'},
      {'item': 'Zitronensaft', 'amount': 1, 'unit': 'EL'},
      {'item': 'Schwarze Oliven', 'amount': 50, 'unit': 'g'},
    ],
    'steps': [
      'Fenchel in hauchdünne Scheiben hobeln, Grün aufbewahren.',
      'Orangen so schälen, dass keine weisse Haut bleibt.',
      'Orangenfilets herausschneiden, Saft auffangen.',
      'Fenchel und Orangenfilets auf Tellern anrichten.',
      'Olivenöl mit Zitronen- und Orangensaft mischen.',
      'Dressing über Salat träufeln.',
      'Mit Oliven und Fenchelgrün garnieren.',
    ],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // RANDEN / ROTE BETE
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Randen',
    'title': 'Randensalat mit Meerrettich',
    'description': 'Würziger Salat mit scharfer Note.',
    'prep_time_min': 15,
    'cook_time_min': 60,
    'servings': 4,
    'difficulty': 'easy',
    'category': 'salad',
    'tags': ['meal-prep', 'gesund'],
    'is_vegetarian': true,
    'is_vegan': true,
    'ingredients': [
      {'item': 'Randen', 'amount': 500, 'unit': 'g', 'note': 'roh'},
      {'item': 'Meerrettich', 'amount': 2, 'unit': 'EL', 'note': 'frisch gerieben'},
      {'item': 'Apfelessig', 'amount': 3, 'unit': 'EL'},
      {'item': 'Rapsöl', 'amount': 4, 'unit': 'EL'},
      {'item': 'Kümmel', 'amount': 0.5, 'unit': 'TL'},
    ],
    'steps': [
      'Ofen auf 200°C vorheizen.',
      'Randen in Alufolie wickeln und ca. 60 Minuten garen.',
      'Abkühlen lassen und schälen.',
      'In feine Scheiben schneiden.',
      'Meerrettich mit Essig, Öl und Kümmel mischen.',
      'Dressing über Randen geben.',
      'Mindestens 1 Stunde ziehen lassen.',
    ],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // CHICORÉE
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Chicorée',
    'title': 'Überbackener Chicorée mit Schinken',
    'description': 'Belgischer Klassiker - leicht bitter, herzhaft und cremig.',
    'prep_time_min': 15,
    'cook_time_min': 30,
    'servings': 4,
    'difficulty': 'easy',
    'category': 'main',
    'tags': ['comfort-food'],
    'contains_gluten': true,
    'contains_lactose': true,
    'ingredients': [
      {'item': 'Chicorée', 'amount': 4, 'unit': 'Stück'},
      {'item': 'Kochschinken', 'amount': 4, 'unit': 'Scheibe'},
      {'item': 'Butter', 'amount': 30, 'unit': 'g'},
      {'item': 'Mehl', 'amount': 30, 'unit': 'g'},
      {'item': 'Milch', 'amount': 400, 'unit': 'ml'},
      {'item': 'Gruyère', 'amount': 100, 'unit': 'g', 'note': 'gerieben'},
      {'item': 'Muskatnuss', 'amount': 1, 'unit': 'Prise'},
    ],
    'steps': [
      'Ofen auf 200°C vorheizen.',
      'Chicorée halbieren und 10 Minuten in Salzwasser kochen.',
      'Gut abtropfen lassen.',
      'Für die Béchamel: Butter schmelzen, Mehl einrühren.',
      'Milch nach und nach zugeben und rühren bis die Sauce eindickt.',
      'Mit Muskatnuss, Salz und Pfeffer würzen.',
      'Chicorée-Hälften mit Schinken umwickeln.',
      'In eine Gratinform legen, mit Sauce übergiessen.',
      'Käse darüberstreuen und 20 Minuten überbacken.',
    ],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // FLEISCH
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Kalbfleisch',
    'title': 'Zürcher Geschnetzeltes',
    'description': 'Der Schweizer Klassiker schlechthin - cremig und zart.',
    'prep_time_min': 15,
    'cook_time_min': 20,
    'servings': 4,
    'difficulty': 'medium',
    'category': 'main',
    'tags': ['schweizer-klassiker'],
    'contains_lactose': true,
    'ingredients': [
      {'item': 'Kalbfleisch', 'amount': 600, 'unit': 'g', 'note': 'Schulter oder Nuss'},
      {'item': 'Champignons', 'amount': 200, 'unit': 'g'},
      {'item': 'Zwiebel', 'amount': 1, 'unit': 'Stück'},
      {'item': 'Weisswein', 'amount': 100, 'unit': 'ml'},
      {'item': 'Rahm', 'amount': 200, 'unit': 'ml'},
      {'item': 'Butter', 'amount': 40, 'unit': 'g'},
    ],
    'steps': [
      'Fleisch in feine Streifen schneiden.',
      'Champignons in Scheiben, Zwiebel fein hacken.',
      'Butter in einer grossen Pfanne erhitzen.',
      'Fleisch portionenweise bei starker Hitze scharf anbraten.',
      'Herausnehmen und warm stellen.',
      'Zwiebeln und Champignons in derselben Pfanne andünsten.',
      'Mit Weisswein ablöschen.',
      'Rahm beigeben und etwas einkochen lassen.',
      'Fleisch zurück in die Sauce geben, kurz erwärmen.',
      'Mit Salz und Pfeffer abschmecken.',
      'Sofort mit Rösti servieren.',
    ],
  },
  {
    'vegetable': 'Hirsch',
    'title': 'Hirschpfeffer',
    'description': 'Klassisches Wildgericht für die Herbst- und Wintersaison.',
    'prep_time_min': 30,
    'cook_time_min': 120,
    'servings': 6,
    'difficulty': 'hard',
    'category': 'main',
    'tags': ['comfort-food'],
    'contains_lactose': true,
    'ingredients': [
      {'item': 'Hirschragout', 'amount': 1000, 'unit': 'g'},
      {'item': 'Rotwein', 'amount': 500, 'unit': 'ml'},
      {'item': 'Zwiebeln', 'amount': 3, 'unit': 'Stück'},
      {'item': 'Karotten', 'amount': 2, 'unit': 'Stück'},
      {'item': 'Sellerie', 'amount': 100, 'unit': 'g'},
      {'item': 'Wacholderbeeren', 'amount': 8, 'unit': 'Stück'},
      {'item': 'Lorbeerblätter', 'amount': 2, 'unit': 'Stück'},
      {'item': 'Rahm', 'amount': 200, 'unit': 'ml'},
      {'item': 'Preiselbeeren', 'amount': 100, 'unit': 'g', 'note': 'zum Servieren'},
    ],
    'steps': [
      'Fleisch in grosse Würfel schneiden.',
      'Gemüse grob würfeln.',
      'Fleisch portionenweise scharf anbraten, herausnehmen.',
      'Zwiebeln im Bratfett goldbraun rösten.',
      'Karotten und Sellerie beigeben.',
      'Mit Rotwein ablöschen.',
      'Fleisch zurückgeben, Gewürze beifügen.',
      'Zugedeckt 2 Stunden bei kleiner Hitze schmoren.',
      'Sauce evtl. binden, Rahm unterziehen.',
      'Mit Spätzli und Rotkohl servieren, Preiselbeeren dazu reichen.',
    ],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // FRÜHSTÜCK
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Äpfel Lager',
    'title': 'Birchermüesli',
    'description': 'Das originale Schweizer Frühstück nach Dr. Bircher-Benner.',
    'prep_time_min': 15,
    'cook_time_min': 0,
    'servings': 4,
    'difficulty': 'easy',
    'category': 'breakfast',
    'tags': ['gesund', 'meal-prep'],
    'is_vegetarian': true,
    'contains_lactose': true,
    'contains_nuts': true,
    'ingredients': [
      {'item': 'Haferflocken', 'amount': 200, 'unit': 'g'},
      {'item': 'Joghurt nature', 'amount': 400, 'unit': 'g'},
      {'item': 'Milch', 'amount': 100, 'unit': 'ml'},
      {'item': 'Äpfel', 'amount': 2, 'unit': 'Stück'},
      {'item': 'Zitronensaft', 'amount': 1, 'unit': 'EL'},
      {'item': 'Honig', 'amount': 2, 'unit': 'EL'},
      {'item': 'Haselnüsse', 'amount': 40, 'unit': 'g', 'note': 'gehackt'},
      {'item': 'Beeren', 'amount': 150, 'unit': 'g', 'note': 'frisch oder gefroren'},
    ],
    'steps': [
      'Haferflocken mit Milch mischen und über Nacht einweichen.',
      'Am Morgen Joghurt unterrühren.',
      'Äpfel mit Schale raffeln und sofort mit Zitronensaft mischen.',
      'Unter das Müesli heben.',
      'Mit Honig süssen.',
      'Nüsse und Beeren darübergeben.',
      'Sofort servieren.',
    ],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // KIRSCHEN
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Kirschen',
    'title': 'Chriesiauflauf',
    'description': 'Luftiger Auflauf mit saftigen Kirschen.',
    'prep_time_min': 20,
    'cook_time_min': 35,
    'servings': 6,
    'difficulty': 'medium',
    'category': 'dessert',
    'tags': ['schweizer-klassiker'],
    'is_vegetarian': true,
    'contains_gluten': true,
    'contains_lactose': true,
    'contains_eggs': true,
    'ingredients': [
      {'item': 'Kirschen', 'amount': 500, 'unit': 'g', 'note': 'entsteint'},
      {'item': 'Butter', 'amount': 50, 'unit': 'g', 'note': 'weich'},
      {'item': 'Zucker', 'amount': 80, 'unit': 'g'},
      {'item': 'Eier', 'amount': 3, 'unit': 'Stück'},
      {'item': 'Mehl', 'amount': 100, 'unit': 'g'},
      {'item': 'Milch', 'amount': 150, 'unit': 'ml'},
      {'item': 'Puderzucker', 'note': 'zum Bestäuben'},
    ],
    'steps': [
      'Ofen auf 180°C vorheizen.',
      'Auflaufform mit Butter einfetten.',
      'Butter mit Zucker schaumig rühren.',
      'Eier einzeln unterrühren.',
      'Mehl und Milch abwechselnd unterheben.',
      'Kirschen in die Form geben.',
      'Teig darübergiessen.',
      'Ca. 35 Minuten goldbraun backen.',
      'Lauwarm mit Puderzucker bestäubt servieren.',
    ],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // ZWETSCHGEN
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Zwetschgen',
    'title': 'Zwetschgenwähe',
    'description': 'Traditionelle Spätsommerwähe mit saftigen Zwetschgen.',
    'prep_time_min': 20,
    'cook_time_min': 40,
    'servings': 8,
    'difficulty': 'medium',
    'category': 'dessert',
    'tags': ['schweizer-klassiker', 'party'],
    'is_vegetarian': true,
    'contains_gluten': true,
    'contains_lactose': true,
    'contains_eggs': true,
    'ingredients': [
      {'item': 'Kuchenteig', 'amount': 1, 'unit': 'Stück'},
      {'item': 'Zwetschgen', 'amount': 800, 'unit': 'g'},
      {'item': 'Zucker', 'amount': 60, 'unit': 'g'},
      {'item': 'Zimt', 'amount': 1, 'unit': 'TL'},
      {'item': 'Eier', 'amount': 2, 'unit': 'Stück'},
      {'item': 'Rahm', 'amount': 150, 'unit': 'ml'},
    ],
    'steps': [
      'Ofen auf 200°C vorheizen.',
      'Teig in Form legen und mit Gabel einstechen.',
      'Zwetschgen halbieren und entsteinen.',
      'Dachziegelartig auf Teig legen.',
      'Zucker mit Zimt mischen und über Früchte streuen.',
      'Eier mit Rahm verquirlen und darübergiessen.',
      'Ca. 35-40 Minuten backen.',
    ],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // HIMBEEREN
  // ═══════════════════════════════════════════════════════════════════════════
  {
    'vegetable': 'Himbeeren',
    'title': 'Himbeer-Joghurt-Mousse',
    'description': 'Leichtes Sommerdessert - fruchtig und cremig.',
    'prep_time_min': 20,
    'cook_time_min': 0,
    'servings': 4,
    'difficulty': 'easy',
    'category': 'dessert',
    'tags': ['schnell', 'gesund'],
    'is_vegetarian': true,
    'contains_lactose': true,
    'ingredients': [
      {'item': 'Himbeeren', 'amount': 300, 'unit': 'g'},
      {'item': 'Griechischer Joghurt', 'amount': 400, 'unit': 'g'},
      {'item': 'Honig', 'amount': 3, 'unit': 'EL'},
      {'item': 'Vanillezucker', 'amount': 1, 'unit': 'Stück', 'note': 'Päckchen'},
    ],
    'steps': [
      'Die Hälfte der Himbeeren pürieren.',
      'Joghurt mit Honig und Vanillezucker verrühren.',
      'Himbeerpüree unterheben - nicht ganz vermischen für Marmor-Effekt.',
      'In Gläser füllen.',
      'Mit restlichen Himbeeren garnieren.',
      'Mindestens 30 Minuten kühl stellen.',
    ],
  },
];
