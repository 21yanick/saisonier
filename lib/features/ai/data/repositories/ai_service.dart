import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:saisonier/core/config/app_config.dart';
import 'package:saisonier/core/network/pocketbase_provider.dart';
import 'package:saisonier/features/ai/domain/enums/ai_enums.dart';
import 'package:saisonier/features/ai/domain/models/generated_recipe.dart';
import 'package:saisonier/features/ai/domain/models/smart_weekplan_response.dart';
import 'package:saisonier/features/ai/domain/models/refine_meal_response.dart';

part 'ai_service.g.dart';

@riverpod
AIService aiService(Ref ref) {
  return AIService(ref.watch(pocketbaseProvider));
}

/// Service for AI-powered features via AI Service proxy to Gemini API.
class AIService {
  final PocketBase _pb;
  final String _baseUrl = AppConfig.aiServiceUrl;

  AIService(this._pb);

  /// Get auth headers from PocketBase
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_pb.authStore.token}',
      };

  /// Make a POST request to the AI service
  Future<Map<String, dynamic>> _post(
      String path, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw AIServiceException(
        error['error'] ?? 'AI request failed',
        error['message'] ?? '',
      );
    }

    return jsonDecode(response.body);
  }

  /// Make a GET request to the AI service
  Future<Map<String, dynamic>> _get(String path) async {
    final response = await http.get(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw AIServiceException(
        error['error'] ?? 'AI request failed',
        error['message'] ?? '',
      );
    }

    return jsonDecode(response.body);
  }

  /// Generate a recipe based on user context and preferences.
  ///
  /// Parameters:
  /// - [seasonalVegetables]: Selected seasonal vegetables (optional, AI picks if empty)
  /// - [style]: Recipe style (comfort, quick, healthy, festive, onePot, budget)
  /// - [category]: Recipe category (main, side, soup, salad, dessert, snack)
  /// - [freeFormRequest]: Free-form text describing desired dish
  /// - [additionalIngredients]: Extra ingredients user wants to use
  /// - [inspiration]: Quick inspiration chip selection
  /// - [forceVegetarian]: Override to force vegetarian recipe
  /// - [forceVegan]: Override to force vegan recipe
  /// - [forceQuick]: Override to force max 30 min cooking time
  /// - [cuisineOverride]: Override cuisine preference for this recipe
  /// - [proteinOverride]: Override protein preference for this recipe
  /// - [nutritionOverride]: Override nutrition focus for this recipe
  Future<GeneratedRecipe> generateRecipe({
    required List<String> seasonalVegetables,
    required RecipeStyle style,
    RecipeCategory category = RecipeCategory.main,
    String? freeFormRequest,
    String? additionalIngredients,
    RecipeInspiration? inspiration,
    bool forceVegetarian = false,
    bool forceVegan = false,
    bool forceQuick = false,
    Cuisine? cuisineOverride,
    Protein? proteinOverride,
    NutritionFocus? nutritionOverride,
  }) async {
    final response = await _post('/api/ai/generate-recipe', {
      'seasonal_vegetables': seasonalVegetables,
      'style': style.name,
      'category': category.name,
      'free_form_request': freeFormRequest ?? '',
      'additional_ingredients': additionalIngredients ?? '',
      'inspiration': inspiration?.name,
      'force_vegetarian': forceVegetarian,
      'force_vegan': forceVegan,
      'force_quick': forceQuick,
      'cuisine_override': cuisineOverride?.name,
      'protein_override': proteinOverride?.name,
      'nutrition_override': nutritionOverride?.name,
    });

    final recipeJson = response['recipe'] as Map<String, dynamic>;
    return GeneratedRecipe.fromJson(recipeJson);
  }

  /// Generate a weekly meal plan (legacy - generates recipes).
  Future<GeneratedWeekplan> generateWeekplan({
    required List<int> selectedDays,
    required List<String> selectedSlots,
    String? specialRequest,
  }) async {
    final response = await _post('/api/ai/generate-weekplan', {
      'selected_days': selectedDays,
      'selected_slots': selectedSlots,
      'special_request': specialRequest ?? '',
    });

    return GeneratedWeekplan.fromJson(response);
  }

  /// Generate a smart weekly meal plan with context analysis (DB-based).
  Future<SmartWeekplanResponse> generateSmartWeekplan({
    required List<DateTime> selectedDates,
    required List<String> selectedSlots,
    String? weekContext,
    WeekplanInspiration? inspiration,
    bool boostFavorites = false,
    bool boostOwnRecipes = false,
    bool forceVegetarian = false,
    bool forceVegan = false,
    bool forceQuick = false,
    List<Map<String, String>>? existingMeals,
    List<Map<String, dynamic>>? fixedRecipes,
  }) async {
    // Convert DateTimes to ISO date strings
    final dateStrings = selectedDates
        .map((d) =>
            '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}')
        .toList();

    final response = await _post('/api/ai/generate-smart-weekplan', {
      'selected_dates': dateStrings,
      'selected_slots': selectedSlots,
      'week_context': weekContext ?? '',
      'inspiration': inspiration?.name,
      'boost_favorites': boostFavorites,
      'boost_own_recipes': boostOwnRecipes,
      'force_vegetarian': forceVegetarian,
      'force_vegan': forceVegan,
      'force_quick': forceQuick,
      'existing_meals': existingMeals ?? [],
      'fixed_recipes': fixedRecipes ?? [],
    });

    return SmartWeekplanResponse.fromJson(response);
  }

  /// Refine a single meal through conversation.
  Future<RefineMealResponse> refineMeal({
    required List<PlannedDay> currentPlan,
    required String day,
    required String slot,
    required String userMessage,
    String? dayContext,
  }) async {
    final response = await _post('/api/ai/refine-meal', {
      'current_plan': currentPlan.map((d) => d.toJson()).toList(),
      'day': day,
      'slot': slot,
      'user_message': userMessage,
      'day_context': dayContext,
    });

    return RefineMealResponse.fromJson(response);
  }

  /// Get count of eligible recipes for given filters.
  Future<int> getEligibleRecipeCount({
    bool forceVegetarian = false,
    bool forceVegan = false,
    bool forceQuick = false,
  }) async {
    final response = await _post('/api/ai/eligible-recipe-count', {
      'force_vegetarian': forceVegetarian,
      'force_vegan': forceVegan,
      'force_quick': forceQuick,
    });

    return response['count'] as int? ?? 0;
  }

  /// Generate images for a recipe.
  /// Returns a list of image URLs (4 variations).
  Future<ImageGenerationResult> generateRecipeImages({
    required String recipeTitle,
    required String recipeDescription,
    required List<String> mainIngredients,
  }) async {
    final response = await _post('/api/ai/generate-image', {
      'recipe_title': recipeTitle,
      'recipe_description': recipeDescription,
      'main_ingredients': mainIngredients,
    });

    return ImageGenerationResult(
      images: List<String>.from(response['images'] ?? []),
      remaining: response['remaining'] as int? ?? 0,
    );
  }

  /// Save a selected AI-generated image to a recipe.
  Future<String> saveRecipeImage({
    required String recipeId,
    required String imageData,
  }) async {
    final response = await _post('/api/ai/save-image', {
      'recipe_id': recipeId,
      'image_data': imageData,
    });

    return response['url'] as String;
  }

  /// Get the current quota status for the user.
  Future<QuotaStatus> getQuotaStatus() async {
    final response = await _get('/api/ai/quota');
    return QuotaStatus.fromJson(response);
  }
}

/// Exception thrown by AI service operations.
class AIServiceException implements Exception {
  final String error;
  final String message;

  AIServiceException(this.error, this.message);

  @override
  String toString() => '$error: $message';
}

/// Result of a weekplan generation.
class GeneratedWeekplan {
  final List<GeneratedDay> weekplan;
  final List<String> mealPrepTips;
  final ShoppingListSummary? shoppingListSummary;

  GeneratedWeekplan({
    required this.weekplan,
    this.mealPrepTips = const [],
    this.shoppingListSummary,
  });

  factory GeneratedWeekplan.fromJson(Map<String, dynamic> json) {
    return GeneratedWeekplan(
      weekplan: (json['weekplan'] as List?)
              ?.map((d) => GeneratedDay.fromJson(d as Map<String, dynamic>))
              .toList() ??
          [],
      mealPrepTips: List<String>.from(json['mealPrepTips'] ?? []),
      shoppingListSummary: json['shoppingListSummary'] != null
          ? ShoppingListSummary.fromJson(
              json['shoppingListSummary'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// A single day in a generated weekplan.
class GeneratedDay {
  final String date;
  final String dayName;
  final Map<String, GeneratedRecipe> meals;

  GeneratedDay({
    required this.date,
    required this.dayName,
    required this.meals,
  });

  factory GeneratedDay.fromJson(Map<String, dynamic> json) {
    final mealsJson = json['meals'] as Map<String, dynamic>? ?? {};
    return GeneratedDay(
      date: json['date'] as String,
      dayName: json['dayName'] as String,
      meals: mealsJson.map(
        (key, value) =>
            MapEntry(key, GeneratedRecipe.fromJson(value as Map<String, dynamic>)),
      ),
    );
  }
}

/// Shopping list summary from AI weekplan generation.
class ShoppingListSummary {
  final List<String> vegetables;
  final List<String> staples;
  final List<String> dairy;
  final List<String> other;

  ShoppingListSummary({
    this.vegetables = const [],
    this.staples = const [],
    this.dairy = const [],
    this.other = const [],
  });

  factory ShoppingListSummary.fromJson(Map<String, dynamic> json) {
    return ShoppingListSummary(
      vegetables: List<String>.from(json['vegetables'] ?? []),
      staples: List<String>.from(json['staples'] ?? []),
      dairy: List<String>.from(json['dairy'] ?? []),
      other: List<String>.from(json['other'] ?? []),
    );
  }
}

/// Result of an image generation request.
class ImageGenerationResult {
  final List<String> images;
  final int remaining;

  ImageGenerationResult({
    required this.images,
    required this.remaining,
  });
}

/// Current quota status for the user.
class QuotaStatus {
  final bool allowed;
  final int remaining;
  final int used;
  final int limit;

  QuotaStatus({
    required this.allowed,
    required this.remaining,
    required this.used,
    required this.limit,
  });

  factory QuotaStatus.fromJson(Map<String, dynamic> json) {
    return QuotaStatus(
      allowed: json['allowed'] as bool? ?? false,
      remaining: json['remaining'] as int? ?? 0,
      used: json['used'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
    );
  }
}
