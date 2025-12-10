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
String _$dialogPlannedMealsHash() =>
    r'a266c042499bbf08651f3c0736bd5948dfe5c548';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider for planned meals over a date range (used by AddToPlanDialog)
/// Watches from today for specified number of days
///
/// Copied from [dialogPlannedMeals].
@ProviderFor(dialogPlannedMeals)
const dialogPlannedMealsProvider = DialogPlannedMealsFamily();

/// Provider for planned meals over a date range (used by AddToPlanDialog)
/// Watches from today for specified number of days
///
/// Copied from [dialogPlannedMeals].
class DialogPlannedMealsFamily extends Family<AsyncValue<List<PlannedMeal>>> {
  /// Provider for planned meals over a date range (used by AddToPlanDialog)
  /// Watches from today for specified number of days
  ///
  /// Copied from [dialogPlannedMeals].
  const DialogPlannedMealsFamily();

  /// Provider for planned meals over a date range (used by AddToPlanDialog)
  /// Watches from today for specified number of days
  ///
  /// Copied from [dialogPlannedMeals].
  DialogPlannedMealsProvider call({
    int days = 21,
  }) {
    return DialogPlannedMealsProvider(
      days: days,
    );
  }

  @override
  DialogPlannedMealsProvider getProviderOverride(
    covariant DialogPlannedMealsProvider provider,
  ) {
    return call(
      days: provider.days,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dialogPlannedMealsProvider';
}

/// Provider for planned meals over a date range (used by AddToPlanDialog)
/// Watches from today for specified number of days
///
/// Copied from [dialogPlannedMeals].
class DialogPlannedMealsProvider
    extends AutoDisposeStreamProvider<List<PlannedMeal>> {
  /// Provider for planned meals over a date range (used by AddToPlanDialog)
  /// Watches from today for specified number of days
  ///
  /// Copied from [dialogPlannedMeals].
  DialogPlannedMealsProvider({
    int days = 21,
  }) : this._internal(
          (ref) => dialogPlannedMeals(
            ref as DialogPlannedMealsRef,
            days: days,
          ),
          from: dialogPlannedMealsProvider,
          name: r'dialogPlannedMealsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dialogPlannedMealsHash,
          dependencies: DialogPlannedMealsFamily._dependencies,
          allTransitiveDependencies:
              DialogPlannedMealsFamily._allTransitiveDependencies,
          days: days,
        );

  DialogPlannedMealsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.days,
  }) : super.internal();

  final int days;

  @override
  Override overrideWith(
    Stream<List<PlannedMeal>> Function(DialogPlannedMealsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DialogPlannedMealsProvider._internal(
        (ref) => create(ref as DialogPlannedMealsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<PlannedMeal>> createElement() {
    return _DialogPlannedMealsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DialogPlannedMealsProvider && other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DialogPlannedMealsRef on AutoDisposeStreamProviderRef<List<PlannedMeal>> {
  /// The parameter `days` of this provider.
  int get days;
}

class _DialogPlannedMealsProviderElement
    extends AutoDisposeStreamProviderElement<List<PlannedMeal>>
    with DialogPlannedMealsRef {
  _DialogPlannedMealsProviderElement(super.provider);

  @override
  int get days => (origin as DialogPlannedMealsProvider).days;
}

String _$scrollCalendarMealsHash() =>
    r'b0d36b8876295106095bd92dfec85b797c894560';

/// Provider for scroll calendar meals (28 days: 7 past + today + 20 future)
///
/// Copied from [scrollCalendarMeals].
@ProviderFor(scrollCalendarMeals)
final scrollCalendarMealsProvider =
    AutoDisposeStreamProvider<List<PlannedMeal>>.internal(
  scrollCalendarMeals,
  name: r'scrollCalendarMealsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scrollCalendarMealsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ScrollCalendarMealsRef
    = AutoDisposeStreamProviderRef<List<PlannedMeal>>;
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
