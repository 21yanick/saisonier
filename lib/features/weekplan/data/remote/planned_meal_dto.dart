import 'package:freezed_annotation/freezed_annotation.dart';

part 'planned_meal_dto.freezed.dart';
part 'planned_meal_dto.g.dart';

@freezed
class PlannedMealDto with _$PlannedMealDto {
  const factory PlannedMealDto({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required DateTime date,
    required String slot, // 'breakfast', 'lunch', 'dinner'
    @JsonKey(name: 'recipe_id') String? recipeId,
    @JsonKey(name: 'custom_title') String? customTitle,
    @Default(2) int servings,
  }) = _PlannedMealDto;

  factory PlannedMealDto.fromJson(Map<String, dynamic> json) =>
      _$PlannedMealDtoFromJson(json);
}
