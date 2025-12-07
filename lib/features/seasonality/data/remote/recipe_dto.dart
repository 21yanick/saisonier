import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_dto.freezed.dart';
part 'recipe_dto.g.dart';

@freezed
class RecipeDto with _$RecipeDto {
  const factory RecipeDto({
    required String id,
    @JsonKey(name: 'vegetable_id') required String vegetableId, // Pocketbase Relation ID
    required String title,
    required String image,
    @JsonKey(name: 'time_min') @Default(0) int timeMin,
    @Default([]) List<dynamic> ingredients, // JSON array of objects
    @Default([]) List<String> steps, // JSON array of strings
  }) = _RecipeDto;

  factory RecipeDto.fromJson(Map<String, dynamic> json) => _$RecipeDtoFromJson(json);
}
