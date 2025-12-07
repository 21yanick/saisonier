import 'package:freezed_annotation/freezed_annotation.dart';

part 'vegetable_dto.freezed.dart';
part 'vegetable_dto.g.dart';

@freezed
class VegetableDto with _$VegetableDto {
  const factory VegetableDto({
    required String id,
    required String name,
    required String type,
    @Default('') String description,
    required String image,
    @JsonKey(name: 'hex_color') required String hexColor,
    required List<dynamic> months, // Pocketbase stores this as JSON array
    required int tier,
  }) = _VegetableDto;

  factory VegetableDto.fromJson(Map<String, dynamic> json) =>
      _$VegetableDtoFromJson(json);
}
