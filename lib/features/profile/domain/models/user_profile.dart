import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saisonier/features/profile/domain/enums/profile_enums.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String userId,

    // Household
    @Default(1) int householdSize,
    @Default(0) int childrenCount,
    List<int>? childrenAges,

    // Nutrition
    @Default([]) List<Allergen> allergens,
    @Default(DietType.omnivore) DietType diet,
    @Default([]) List<String> dislikes,

    // Cooking
    @Default(CookingSkill.beginner) CookingSkill skill,
    @Default(30) int maxCookingTimeMin,

    // External Services
    String? bringEmail,
    String? bringListUuid,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
