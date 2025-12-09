import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saisonier/features/auth/presentation/controllers/auth_controller.dart';
import 'package:saisonier/features/ai/data/repositories/ai_profile_repository.dart';
import 'package:saisonier/features/ai/domain/models/ai_profile.dart';

part 'ai_profile_controller.g.dart';

/// Controller for AI Profile state management.
/// Watches the current user and loads their AI profile if they are Premium.
@riverpod
class AIProfileController extends _$AIProfileController {
  @override
  FutureOr<AIProfile?> build() async {
    final userState = ref.watch(currentUserProvider);
    final user = userState.value;

    if (user == null) {
      return null;
    }

    // Fetch AI profile (returns null if user is not Premium)
    return ref.watch(aiProfileRepositoryProvider).getProfile(user.id);
  }

  /// Check if the current user has an AI profile (is Premium).
  bool get isPremium => state.valueOrNull != null;

  /// Check if the user has completed the onboarding flow.
  bool get hasCompletedOnboarding =>
      state.valueOrNull?.onboardingCompleted ?? false;

  /// Create a new AI profile for the user (when they subscribe to Premium).
  Future<void> createProfile(AIProfile profile) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await ref
          .read(aiProfileRepositoryProvider)
          .createOrUpdateProfile(user.id, profile);
    });
  }

  /// Update the AI profile.
  Future<void> updateProfile(AIProfile profile) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await ref.read(aiProfileRepositoryProvider).updateProfile(profile);
    });
  }

  /// Mark onboarding as completed.
  Future<void> completeOnboarding() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    await ref.read(aiProfileRepositoryProvider).completeOnboarding(user.id);

    // Refresh state
    ref.invalidateSelf();
  }

  /// Add an accepted suggestion to the learning context.
  Future<void> addAcceptedSuggestion(String suggestion) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    await ref
        .read(aiProfileRepositoryProvider)
        .addAcceptedSuggestion(user.id, suggestion);

    // Refresh state
    ref.invalidateSelf();
  }

  /// Add a rejected suggestion to the learning context.
  Future<void> addRejectedSuggestion(String suggestion) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    await ref
        .read(aiProfileRepositoryProvider)
        .addRejectedSuggestion(user.id, suggestion);

    // Refresh state
    ref.invalidateSelf();
  }
}

/// Simple provider to check if the current user is Premium.
/// Use this for quick checks in UI widgets.
@riverpod
bool isPremium(Ref ref) {
  final aiProfile = ref.watch(aIProfileControllerProvider);
  return aiProfile.valueOrNull != null;
}

/// Provider to check if Premium onboarding is needed.
/// Returns true if user has AI profile but hasn't completed onboarding.
@riverpod
bool needsOnboarding(Ref ref) {
  final aiProfile = ref.watch(aIProfileControllerProvider);
  final profile = aiProfile.valueOrNull;
  if (profile == null) return false;
  return !profile.onboardingCompleted;
}
