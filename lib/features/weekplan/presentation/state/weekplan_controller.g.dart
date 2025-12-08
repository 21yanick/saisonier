// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekplan_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$weekPlannedMealsHash() => r'cdc92237189877e9246f7cdc4005d9b9de7084e1';

/// Provider for planned meals of the selected week
///
/// Copied from [weekPlannedMeals].
@ProviderFor(weekPlannedMeals)
final weekPlannedMealsProvider =
    AutoDisposeStreamProvider<List<PlannedMeal>>.internal(
  weekPlannedMeals,
  name: r'weekPlannedMealsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$weekPlannedMealsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeekPlannedMealsRef = AutoDisposeStreamProviderRef<List<PlannedMeal>>;
String _$selectedWeekStartHash() => r'95b26be845014614ae1392a4cdbf10d90e18636e';

/// Provider for the currently selected week's start date (Monday)
///
/// Copied from [SelectedWeekStart].
@ProviderFor(SelectedWeekStart)
final selectedWeekStartProvider =
    AutoDisposeNotifierProvider<SelectedWeekStart, DateTime>.internal(
  SelectedWeekStart.new,
  name: r'selectedWeekStartProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedWeekStartHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedWeekStart = AutoDisposeNotifier<DateTime>;
String _$weekplanControllerHash() =>
    r'68d4b91c9b325cb9b4d5fc6bf3e5d2da4fede964';

/// Controller for week plan actions
///
/// Copied from [WeekplanController].
@ProviderFor(WeekplanController)
final weekplanControllerProvider =
    AutoDisposeAsyncNotifierProvider<WeekplanController, void>.internal(
  WeekplanController.new,
  name: r'weekplanControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$weekplanControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WeekplanController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
