// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isPremiumHash() => r'25b23f13cc5eca69120fbdfcfe937954c3ed4e01';

/// Simple provider to check if the current user is Premium.
/// Use this for quick checks in UI widgets.
///
/// Copied from [isPremium].
@ProviderFor(isPremium)
final isPremiumProvider = AutoDisposeProvider<bool>.internal(
  isPremium,
  name: r'isPremiumProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isPremiumHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsPremiumRef = AutoDisposeProviderRef<bool>;
String _$needsOnboardingHash() => r'eb4893774bd6e28cc9cf56be59dd556057801006';

/// Provider to check if Premium onboarding is needed.
/// Returns true if user has AI profile but hasn't completed onboarding.
///
/// Copied from [needsOnboarding].
@ProviderFor(needsOnboarding)
final needsOnboardingProvider = AutoDisposeProvider<bool>.internal(
  needsOnboarding,
  name: r'needsOnboardingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$needsOnboardingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NeedsOnboardingRef = AutoDisposeProviderRef<bool>;
String _$aIProfileControllerHash() =>
    r'd1bd437bcf8c323cf81523dadba5dd782c9dcb92';

/// Controller for AI Profile state management.
/// Watches the current user and loads their AI profile if they are Premium.
///
/// Copied from [AIProfileController].
@ProviderFor(AIProfileController)
final aIProfileControllerProvider =
    AutoDisposeAsyncNotifierProvider<AIProfileController, AIProfile?>.internal(
  AIProfileController.new,
  name: r'aIProfileControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$aIProfileControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AIProfileController = AutoDisposeAsyncNotifier<AIProfile?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
