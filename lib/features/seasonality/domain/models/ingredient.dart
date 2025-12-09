import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient.freezed.dart';
part 'ingredient.g.dart';

@freezed
class Ingredient with _$Ingredient {
  const factory Ingredient({
    required String item,
    double? amount, // null = "nach Geschmack"
    String? unit,
    String? note,
  }) = _Ingredient;

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);
}

/// Verfügbare Einheiten für Zutaten
const availableUnits = [
  // Gewicht
  'g',
  'kg',
  // Volumen
  'ml',
  'dl',
  'l',
  'Liter',
  'Deziliter',
  // Löffel
  'EL',
  'TL',
  // Stückzahl
  'Stück',
  'Scheibe',
  'Zehe',
  'Prise',
  'Bund',
  'Dose',
  'Packung',
  'Becher',
  'Glas',
  'Tasse',
];

/// Skaliert Zutaten basierend auf Portionen
List<Ingredient> scaleIngredients(
  List<Ingredient> ingredients,
  int baseServings,
  int targetServings,
) {
  if (baseServings == targetServings) return ingredients;
  final factor = targetServings / baseServings;

  return ingredients.map((ing) {
    if (ing.amount == null) return ing;

    final scaled = ing.amount! * factor;
    final rounded = _roundAmount(scaled, ing.unit);

    return ing.copyWith(amount: rounded);
  }).toList();
}

/// Rundet Mengen auf sinnvolle Werte je nach Einheit
double _roundAmount(double value, String? unit) {
  // g, ml: auf 5er runden
  if (unit == 'g' || unit == 'ml') {
    return (value / 5).round() * 5.0;
  }
  // kg, l: auf 0.1 runden
  if (unit == 'kg' || unit == 'l') {
    return double.parse(value.toStringAsFixed(1));
  }
  // EL, TL: auf 0.5 runden
  if (unit == 'EL' || unit == 'TL') {
    return (value * 2).round() / 2;
  }
  // Stück, Scheibe: auf ganze Zahlen
  if (unit == 'Stück' || unit == 'Scheibe') {
    return value.round().toDouble();
  }
  // Default: eine Nachkommastelle
  return double.parse(value.toStringAsFixed(1));
}

/// Formatiert eine Zutat für die Anzeige
String formatIngredient(Ingredient ing) {
  final parts = <String>[];

  if (ing.amount != null) {
    // Formatiere Zahl schön (ohne .0 wenn ganze Zahl)
    final amountStr = ing.amount! == ing.amount!.roundToDouble()
        ? ing.amount!.toInt().toString()
        : ing.amount!.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '');
    parts.add(amountStr);
  }

  if (ing.unit != null) {
    parts.add(ing.unit!);
  }

  parts.add(ing.item);

  if (ing.note != null && ing.note!.isNotEmpty) {
    parts.add('(${ing.note})');
  }

  return parts.join(' ');
}
