import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_dto.freezed.dart';
part 'recipe_dto.g.dart';

@freezed
class RecipeDto with _$RecipeDto {
  const factory RecipeDto({
    required String id,
    @JsonKey(name: 'vegetable_id') String? vegetableId, // Nullable for user recipes
    required String title,
    @Default('') String image,
    @JsonKey(name: 'time_min') @Default(0) int timeMin,
    @Default(4) int servings,
    @Default([]) List<dynamic> ingredients, // JSON array of objects
    @Default([]) List<String> steps, // JSON array of strings
    // Phase 11: User Recipes
    @Default('curated') String source, // 'curated' | 'user'
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'is_public') @Default(false) bool isPublic,
    String? difficulty, // 'easy' | 'medium' | 'hard'
  }) = _RecipeDto;

  factory RecipeDto.fromJson(Map<String, dynamic> json) => _$RecipeDtoFromJson(json);
}
