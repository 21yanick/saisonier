import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:saisonier/core/network/pocketbase_provider.dart';
import 'package:saisonier/features/ai/data/dtos/ai_profile_dto.dart';
import 'package:saisonier/features/ai/domain/enums/ai_enums.dart';
import 'package:saisonier/features/ai/domain/models/ai_profile.dart';
import 'package:saisonier/features/ai/domain/models/ai_learning_context.dart';

part 'ai_profile_repository.g.dart';

@riverpod
AIProfileRepository aiProfileRepository(Ref ref) {
  return AIProfileRepository(ref.watch(pocketbaseProvider));
}

class AIProfileRepository {
  final PocketBase _pb;

  AIProfileRepository(this._pb);

  /// Get the AI profile for a user. Returns null if not found (not Premium).
  Future<AIProfile?> getProfile(String userId) async {
    try {
      final records = await _pb.collection('ai_profiles').getList(
            filter: 'user_id = "$userId"',
            perPage: 1,
          );

      if (records.items.isEmpty) return null;

      final dto = AIProfileDto.fromRecord(records.items.first);
      return _mapToDomain(dto);
    } catch (e) {
      return null;
    }
  }

  /// Check if user has an AI profile (= is Premium).
  Future<bool> hasProfile(String userId) async {
    final profile = await getProfile(userId);
    return profile != null;
  }

  /// Create a new AI profile (called when user subscribes to Premium).
  Future<AIProfile> createProfile(String userId, AIProfile profile) async {
    final body = _mapToBody(profile);
    body['user_id'] = userId;

    debugPrint('AIProfileRepository.createProfile: $body');
    try {
      final record = await _pb.collection('ai_profiles').create(body: body);
      debugPrint('AIProfileRepository.createProfile: success, id=${record.id}');
      final dto = AIProfileDto.fromRecord(record);
      return _mapToDomain(dto);
    } catch (e) {
      debugPrint('AIProfileRepository.createProfile ERROR: $e');
      rethrow;
    }
  }

  /// Update an existing AI profile.
  Future<AIProfile> updateProfile(AIProfile profile) async {
    // Find the record ID
    final records = await _pb.collection('ai_profiles').getList(
          filter: 'user_id = "${profile.userId}"',
          perPage: 1,
        );

    if (records.items.isEmpty) {
      throw Exception('AI Profile not found for user ${profile.userId}');
    }

    final recordId = records.items.first.id;
    final body = _mapToBody(profile);

    debugPrint('AIProfileRepository.updateProfile: id=$recordId, body=$body');
    try {
      final record =
          await _pb.collection('ai_profiles').update(recordId, body: body);
      debugPrint('AIProfileRepository.updateProfile: success');
      final dto = AIProfileDto.fromRecord(record);
      return _mapToDomain(dto);
    } catch (e) {
      debugPrint('AIProfileRepository.updateProfile ERROR: $e');
      rethrow;
    }
  }

  /// Create or update AI profile.
  Future<AIProfile> createOrUpdateProfile(
      String userId, AIProfile profile) async {
    final existing = await getProfile(userId);
    if (existing == null) {
      return createProfile(userId, profile);
    } else {
      return updateProfile(profile.copyWith(id: existing.id, userId: userId));
    }
  }

  /// Update only the learning context (called after AI interactions).
  Future<void> updateLearningContext(
    String userId,
    AILearningContext context,
  ) async {
    final records = await _pb.collection('ai_profiles').getList(
          filter: 'user_id = "$userId"',
          perPage: 1,
        );

    if (records.items.isEmpty) return;

    final recordId = records.items.first.id;
    await _pb.collection('ai_profiles').update(recordId, body: {
      'learning_context': context.toJson(),
    });
  }

  /// Add an accepted suggestion to the learning context.
  Future<void> addAcceptedSuggestion(String userId, String suggestion) async {
    final profile = await getProfile(userId);
    if (profile == null) return;

    final newContext = profile.learningContext.copyWith(
      acceptedSuggestions: [
        ...profile.learningContext.acceptedSuggestions,
        suggestion,
      ],
      totalAIRequests: profile.learningContext.totalAIRequests + 1,
      lastAIInteraction: DateTime.now(),
    );

    await updateLearningContext(userId, newContext);
  }

  /// Add a rejected suggestion to the learning context.
  Future<void> addRejectedSuggestion(String userId, String suggestion) async {
    final profile = await getProfile(userId);
    if (profile == null) return;

    final newContext = profile.learningContext.copyWith(
      rejectedSuggestions: [
        ...profile.learningContext.rejectedSuggestions,
        suggestion,
      ],
      totalAIRequests: profile.learningContext.totalAIRequests + 1,
      lastAIInteraction: DateTime.now(),
    );

    await updateLearningContext(userId, newContext);
  }

  /// Mark onboarding as completed.
  Future<void> completeOnboarding(String userId) async {
    final records = await _pb.collection('ai_profiles').getList(
          filter: 'user_id = "$userId"',
          perPage: 1,
        );

    if (records.items.isEmpty) return;

    final recordId = records.items.first.id;
    await _pb.collection('ai_profiles').update(recordId, body: {
      'onboarding_completed': true,
    });
  }

  // === Private mapping methods ===

  Map<String, dynamic> _mapToBody(AIProfile profile) {
    return {
      'cuisine_preferences':
          profile.cuisinePreferences.map((e) => e.name).toList(),
      'flavor_profile': profile.flavorProfile.map((e) => e.name).toList(),
      'likes': profile.likes,
      'protein_preferences':
          profile.proteinPreferences.map((e) => e.name).toList(),
      'budget_level': profile.budgetLevel.name,
      'meal_prep_style': profile.mealPrepStyle.name,
      'cooking_days_per_week': profile.cookingDaysPerWeek,
      'health_goals': profile.healthGoals.map((e) => e.name).toList(),
      'nutrition_focus': profile.nutritionFocus.name,
      'equipment': profile.equipment.map((e) => e.name).toList(),
      'learning_context': profile.learningContext.toJson(),
      'onboarding_completed': profile.onboardingCompleted,
    };
  }

  AIProfile _mapToDomain(AIProfileDto dto) {
    return AIProfile(
      id: dto.id,
      userId: dto.userId,
      cuisinePreferences: _parseEnumList(
        dto.cuisinePreferences,
        Cuisine.values,
      ),
      flavorProfile: _parseEnumList(
        dto.flavorProfile,
        FlavorProfile.values,
      ),
      likes: dto.likes ?? [],
      proteinPreferences: _parseEnumList(
        dto.proteinPreferences,
        Protein.values,
      ),
      budgetLevel: _parseEnum(
        dto.budgetLevel,
        BudgetLevel.values,
        BudgetLevel.normal,
      ),
      mealPrepStyle: _parseEnum(
        dto.mealPrepStyle,
        MealPrepStyle.values,
        MealPrepStyle.mixed,
      ),
      cookingDaysPerWeek: dto.cookingDaysPerWeek ?? 4,
      healthGoals: _parseEnumList(
        dto.healthGoals,
        HealthGoal.values,
      ),
      nutritionFocus: _parseEnum(
        dto.nutritionFocus,
        NutritionFocus.values,
        NutritionFocus.balanced,
      ),
      equipment: _parseEnumList(
        dto.equipment,
        KitchenEquipment.values,
      ),
      learningContext: dto.learningContext != null
          ? AILearningContext.fromJson(dto.learningContext!)
          : const AILearningContext(),
      onboardingCompleted: dto.onboardingCompleted ?? false,
      createdAt: dto.created != null ? DateTime.tryParse(dto.created!) : null,
      updatedAt: dto.updated != null ? DateTime.tryParse(dto.updated!) : null,
    );
  }

  /// Parse a single enum value from string.
  T _parseEnum<T extends Enum>(String? value, List<T> values, T defaultValue) {
    if (value == null) return defaultValue;
    return values.firstWhere(
      (e) => e.name == value,
      orElse: () => defaultValue,
    );
  }

  /// Parse a list of enum values from string list.
  List<T> _parseEnumList<T extends Enum>(List<String>? values, List<T> enums) {
    if (values == null) return [];
    return values
        .map((v) => enums.firstWhere(
              (e) => e.name == v,
              orElse: () => enums.first,
            ))
        .where((e) => enums.contains(e))
        .toList();
  }
}
