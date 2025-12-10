// Recipe Data Part 2: Erbsen to Kohlrabi

part of 'recipe_seed_complete.dart';

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
