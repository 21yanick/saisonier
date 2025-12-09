import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/network/pocketbase_helpers.dart';

part 'recipe_dto.freezed.dart';
part 'recipe_dto.g.dart';

@freezed
class RecipeDto with _$RecipeDto {
  const factory RecipeDto({
    required String id,
    required String title,
    @Default('') String description,
    @Default('') String image,

    // === Zeiten (getrennt) ===
    @JsonKey(name: 'prep_time_min') @Default(0) int prepTimeMin,
    @JsonKey(name: 'cook_time_min') @Default(0) int cookTimeMin,

    // === Portionen & Schwierigkeit ===
    @Default(4) int servings,
    String? difficulty, // 'easy' | 'medium' | 'hard'
    String? category, // 'main' | 'side' | 'dessert' | 'snack' | 'breakfast' | 'soup' | 'salad'

    // === Inhalte (JSON) ===
    @Default([]) List<dynamic> ingredients, // JSON array: [{item, amount, unit, note}]
    @Default([]) List<dynamic> steps, // JSON array of strings

    // === Tags ===
    @Default([]) List<dynamic> tags, // Array: ["schnell", "günstig"]

    // === Beziehungen ===
    @JsonKey(name: 'vegetable_id', fromJson: emptyToNull) String? vegetableId,

    // === Ownership ===
    @Default('curated') String source, // 'curated' | 'user'
    @JsonKey(name: 'user_id', fromJson: emptyToNull) String? userId,
    @JsonKey(name: 'is_public') @Default(false) bool isPublic,

    // === Ernährung ===
    @JsonKey(name: 'is_vegetarian') @Default(false) bool isVegetarian,
    @JsonKey(name: 'is_vegan') @Default(false) bool isVegan,

    // === Allergene (contains = true wenn enthalten) ===
    @JsonKey(name: 'contains_gluten') @Default(false) bool containsGluten,
    @JsonKey(name: 'contains_lactose') @Default(false) bool containsLactose,
    @JsonKey(name: 'contains_nuts') @Default(false) bool containsNuts,
    @JsonKey(name: 'contains_eggs') @Default(false) bool containsEggs,
    @JsonKey(name: 'contains_soy') @Default(false) bool containsSoy,
    @JsonKey(name: 'contains_fish') @Default(false) bool containsFish,
    @JsonKey(name: 'contains_shellfish') @Default(false) bool containsShellfish,
  }) = _RecipeDto;

  factory RecipeDto.fromJson(Map<String, dynamic> json) => _$RecipeDtoFromJson(json);
}
