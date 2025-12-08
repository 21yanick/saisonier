import 'package:freezed_annotation/freezed_annotation.dart';

part 'shopping_item_dto.freezed.dart';
part 'shopping_item_dto.g.dart';

@freezed
class ShoppingItemDto with _$ShoppingItemDto {
  const factory ShoppingItemDto({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String item,
    double? amount,
    String? unit,
    String? note,
    @JsonKey(name: 'is_checked') @Default(false) bool isChecked,
    @JsonKey(name: 'source_recipe_id') String? sourceRecipeId,
    @JsonKey(name: 'created', fromJson: _parseCreated) required DateTime createdAt,
  }) = _ShoppingItemDto;

  factory ShoppingItemDto.fromJson(Map<String, dynamic> json) =>
      _$ShoppingItemDtoFromJson(json);
}

/// Parse created field with fallback for null/missing values
DateTime _parseCreated(dynamic value) {
  if (value == null) return DateTime.now();
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
  return DateTime.now();
}
