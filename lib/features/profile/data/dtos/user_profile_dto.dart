import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'user_profile_dto.freezed.dart';

part 'user_profile_dto.g.dart';

@freezed
class UserProfileDto with _$UserProfileDto {
  const UserProfileDto._();

  const factory UserProfileDto({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'household_size') required int householdSize,
    @JsonKey(name: 'children_count') required int childrenCount,
    @JsonKey(name: 'children_ages') List<int>? childrenAges,
    @JsonKey(name: 'allergens') List<String>? allergens,
    @JsonKey(name: 'diet') required String diet,
    @JsonKey(name: 'dislikes') List<String>? dislikes,
    @JsonKey(name: 'skill') required String skill,
    @JsonKey(name: 'max_cooking_time_min') required int maxCookingTimeMin,
    @JsonKey(name: 'bring_email') String? bringEmail,
    @JsonKey(name: 'bring_list_uuid') String? bringListUuid,
  }) = _UserProfileDto;

  factory UserProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UserProfileDtoFromJson(json);

  // Conversion methods to/from Domain
  // Note: We'll implement domain mapping extensions/methods in a mapper or here
  // For now simple fromRecord
  
  factory UserProfileDto.fromRecord(RecordModel record) {
    return UserProfileDto.fromJson(record.toJson());
  }

  // To Domain mapping will be handled in the repository to keep DTO pure data
}
