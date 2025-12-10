// Recipe Data Part 4: Salads, Herbs, and Meat

part of 'recipe_seed_complete.dart';

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
