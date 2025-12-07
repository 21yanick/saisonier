import 'package:pocketbase/pocketbase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:saisonier/core/network/pocketbase_provider.dart';
import 'package:saisonier/features/profile/data/dtos/user_profile_dto.dart';
import 'package:saisonier/features/profile/domain/enums/profile_enums.dart';
import 'package:saisonier/features/profile/domain/models/user_profile.dart';

part 'user_profile_repository.g.dart';

@riverpod
UserProfileRepository userProfileRepository(Ref ref) {
  return UserProfileRepository(ref.watch(pocketbaseProvider));
}

class UserProfileRepository {
  final PocketBase _pb;

  UserProfileRepository(this._pb);

  Future<UserProfile?> getProfile(String userId) async {
    try {
      // Find profile where user_id = userId
      final records = await _pb.collection('user_profiles').getList(
            filter: 'user_id = "$userId"',
            perPage: 1,
          );

      if (records.items.isEmpty) return null;

      final dto = UserProfileDto.fromRecord(records.items.first);
      return _mapToDomain(dto);
    } catch (e) {
      return null;
    }
  }


  Future<void> createOrUpdateProfile(UserProfile profile) async {
    // Check if exists
    final existing = await getProfile(profile.userId);

    // Map domain to JSON for PB
    final body = {
      'user_id': profile.userId,
      'household_size': profile.householdSize,
      'children_count': profile.childrenCount,
      'children_ages': profile.childrenAges,
      'allergens': profile.allergens.map((e) => e.name).toList(), // storing enum names
      'diet': profile.diet.name,
      'dislikes': profile.dislikes,
      'skill': profile.skill.name,
      'max_cooking_time_min': profile.maxCookingTimeMin,
      'bring_email': profile.bringEmail,
      'bring_list_uuid': profile.bringListUuid,
    };

    if (existing == null) {
      // Create
      await _pb.collection('user_profiles').create(body: body);
    } else {
      // Update - need the record ID of the profile, not user ID
      // We need to fetch the ID again or change getProfile to return DTO/ID.
      // Let's simplified: fetch record primarily.
      final records = await _pb.collection('user_profiles').getList(
            filter: 'user_id = "${profile.userId}"',
            perPage: 1,
          );
      
      if (records.items.isNotEmpty) {
        final id = records.items.first.id;
        await _pb.collection('user_profiles').update(id, body: body);
      }
    }
  }

  UserProfile _mapToDomain(UserProfileDto dto) {
    return UserProfile(
      userId: dto.userId,
      householdSize: dto.householdSize,
      childrenCount: dto.childrenCount,
      childrenAges: dto.childrenAges,
      allergens: dto.allergens
              ?.map((e) => Allergen.values.firstWhere(
                  (a) => a.name == e,
                  orElse: () => Allergen.gluten // Fallback? Or filter nulls
                  ))
              .toList() ??
          [],
      diet: DietType.values.firstWhere(
        (e) => e.name == dto.diet,
        orElse: () => DietType.omnivore,
      ),
      dislikes: dto.dislikes ?? [],
      skill: CookingSkill.values.firstWhere(
        (e) => e.name == dto.skill,
        orElse: () => CookingSkill.beginner,
      ),
      maxCookingTimeMin: dto.maxCookingTimeMin,
      bringEmail: dto.bringEmail,
      bringListUuid: dto.bringListUuid,
    );
  }
}
