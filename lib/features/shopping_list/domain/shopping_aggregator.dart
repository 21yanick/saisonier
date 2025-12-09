import 'dart:convert';
import '../../../core/database/app_database.dart';

/// Represents an aggregated ingredient from multiple recipes
class AggregatedIngredient {
  final String item;
  final double? totalAmount;
  final String? unit;
  final String? note;
  final List<String> sourceRecipeIds;

  AggregatedIngredient({
    required this.item,
    this.totalAmount,
    this.unit,
    this.note,
    required this.sourceRecipeIds,
  });
}

/// Aggregates ingredients from multiple recipes
class ShoppingAggregator {
  /// Aggregates ingredients from planned meals with their recipes
  ///
  /// Input: List of (Recipe, plannedServings) tuples
  /// Optional: existingItems to merge with (for "Ergänzen" mode)
  /// Output: List of aggregated ingredients
  List<AggregatedIngredient> aggregateFromMeals(
    List<(Recipe recipe, int plannedServings)> meals, {
    List<ShoppingItem>? existingItems,
  }) {
    // Map: normalized item name -> AggregatedIngredient builder
    final Map<String, _IngredientBuilder> builders = {};

    // First, add existing items (for "Ergänzen" mode)
    if (existingItems != null) {
      for (final item in existingItems) {
        // Skip checked items - they're "done"
        if (item.isChecked) continue;

        final normalizedName = _normalizeItemName(item.item);
        if (builders.containsKey(normalizedName)) {
          builders[normalizedName]!.addExisting(
            amount: item.amount,
            unit: item.unit,
            note: item.note,
          );
        } else {
          builders[normalizedName] = _IngredientBuilder.fromExisting(
            originalName: item.item,
            amount: item.amount,
            unit: item.unit,
            note: item.note,
          );
        }
      }
    }

    // Then add recipe ingredients
    for (final (recipe, plannedServings) in meals) {
      // Parse ingredients JSON
      List<dynamic> ingredients = [];
      try {
        ingredients = jsonDecode(recipe.ingredients) as List<dynamic>;
      } catch (_) {
        continue;
      }

      // Scale factor: plannedServings / recipeServings
      final scaleFactor = plannedServings / recipe.servings;

      for (final ing in ingredients) {
        final i = ing as Map<String, dynamic>;
        final itemName = (i['item'] ?? i['name']) as String?;
        if (itemName == null || itemName.isEmpty) continue;

        final rawAmount = _parseAmount(i['amount']);
        final unit = i['unit'] as String?;
        final note = i['note'] as String?;

        // Treat 0 as "no amount" (nach Geschmack)
        final amount = (rawAmount != null && rawAmount > 0) ? rawAmount : null;

        // Scale amount if present
        final scaledAmount = amount != null ? amount * scaleFactor : null;

        // Normalize item name for grouping (lowercase, trim)
        final normalizedName = _normalizeItemName(itemName);

        if (builders.containsKey(normalizedName)) {
          builders[normalizedName]!.add(
            amount: scaledAmount,
            unit: unit,
            note: note,
            recipeId: recipe.id,
          );
        } else {
          builders[normalizedName] = _IngredientBuilder(
            originalName: itemName,
            initialAmount: scaledAmount,
            initialUnit: unit,
            initialNote: note,
            initialRecipeId: recipe.id,
          );
        }
      }
    }

    // Build final list
    return builders.values.map((b) => b.build()).toList();
  }

  String _normalizeItemName(String name) {
    return name.toLowerCase().trim();
  }

  /// Parse amount from JSON which may be num or String
  double? _parseAmount(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

/// Helper class to build aggregated ingredients
class _IngredientBuilder {
  final String originalName;
  final List<String> recipeIds = [];

  // Track amounts by unit
  final Map<String?, double> amountsByUnit = {};
  String? primaryNote;

  _IngredientBuilder({
    required this.originalName,
    double? initialAmount,
    String? initialUnit,
    String? initialNote,
    required String initialRecipeId,
  }) {
    recipeIds.add(initialRecipeId);
    primaryNote = initialNote;

    if (initialAmount != null) {
      final normalizedUnit = _normalizeUnit(initialUnit);
      amountsByUnit[normalizedUnit] = initialAmount;
    }
  }

  /// Factory for existing shopping items (no recipe ID)
  _IngredientBuilder.fromExisting({
    required this.originalName,
    double? amount,
    String? unit,
    String? note,
  }) {
    primaryNote = note;
    if (amount != null) {
      final normalizedUnit = _normalizeUnit(unit);
      amountsByUnit[normalizedUnit] = amount;
    }
  }

  void add({
    double? amount,
    String? unit,
    String? note,
    required String recipeId,
  }) {
    if (!recipeIds.contains(recipeId)) {
      recipeIds.add(recipeId);
    }

    // Keep first note
    primaryNote ??= note;

    _addAmount(amount, unit);
  }

  /// Add amount from existing item (no recipe ID tracking)
  void addExisting({
    double? amount,
    String? unit,
    String? note,
  }) {
    primaryNote ??= note;
    _addAmount(amount, unit);
  }

  void _addAmount(double? amount, String? unit) {
    if (amount != null) {
      final normalizedUnit = _normalizeUnit(unit);

      // Try to convert compatible units
      final (convertedAmount, targetUnit) = _tryConvert(amount, normalizedUnit);

      if (amountsByUnit.containsKey(targetUnit)) {
        amountsByUnit[targetUnit] = amountsByUnit[targetUnit]! + convertedAmount;
      } else {
        amountsByUnit[targetUnit] = convertedAmount;
      }
    }
  }

  AggregatedIngredient build() {
    // Find the primary (largest) amount/unit combination
    if (amountsByUnit.isEmpty) {
      return AggregatedIngredient(
        item: originalName,
        totalAmount: null,
        unit: null,
        note: primaryNote,
        sourceRecipeIds: recipeIds,
      );
    }

    // Get the entry with the largest amount
    final sorted = amountsByUnit.entries.toList()
      ..sort((a, b) => (b.value).compareTo(a.value));

    final primaryEntry = sorted.first;
    final roundedAmount = _roundAmount(primaryEntry.value, primaryEntry.key);

    return AggregatedIngredient(
      item: originalName,
      totalAmount: roundedAmount,
      unit: primaryEntry.key,
      note: primaryNote,
      sourceRecipeIds: recipeIds,
    );
  }

  String? _normalizeUnit(String? unit) {
    if (unit == null) return null;
    return unit.trim();
  }

  /// Try to convert amount to a compatible unit
  /// Returns (convertedAmount, targetUnit)
  (double, String?) _tryConvert(double amount, String? unit) {
    // Check if we can convert to an existing unit
    for (final existingUnit in amountsByUnit.keys) {
      final converted = _convertBetweenUnits(amount, unit, existingUnit);
      if (converted != null) {
        return (converted, existingUnit);
      }
    }
    return (amount, unit);
  }

  /// Convert between compatible units
  double? _convertBetweenUnits(double amount, String? fromUnit, String? toUnit) {
    if (fromUnit == toUnit) return amount;

    // g <-> kg
    if (fromUnit == 'g' && toUnit == 'kg') return amount / 1000;
    if (fromUnit == 'kg' && toUnit == 'g') return amount * 1000;

    // ml <-> l
    if (fromUnit == 'ml' && toUnit == 'l') return amount / 1000;
    if (fromUnit == 'l' && toUnit == 'ml') return amount * 1000;

    return null; // Incompatible units
  }

  /// Round amounts to sensible values
  double _roundAmount(double value, String? unit) {
    // g, ml: round to 5
    if (unit == 'g' || unit == 'ml') {
      return (value / 5).round() * 5.0;
    }
    // kg, l: round to 0.1
    if (unit == 'kg' || unit == 'l') {
      return double.parse(value.toStringAsFixed(1));
    }
    // EL, TL: round to 0.5
    if (unit == 'EL' || unit == 'TL') {
      return (value * 2).round() / 2;
    }
    // Stück, Scheibe: round to whole
    if (unit == 'Stück' || unit == 'Scheibe') {
      return value.ceil().toDouble();
    }
    // Default: one decimal
    return double.parse(value.toStringAsFixed(1));
  }
}
