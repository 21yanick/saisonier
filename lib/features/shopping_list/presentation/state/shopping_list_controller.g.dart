// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shoppingItemsHash() => r'bb0451742a6b7e0ba4be73967cb71187ce22e82e';

/// Stream provider for shopping items
///
/// Copied from [shoppingItems].
@ProviderFor(shoppingItems)
final shoppingItemsProvider =
    AutoDisposeStreamProvider<List<ShoppingItem>>.internal(
  shoppingItems,
  name: r'shoppingItemsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$shoppingItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ShoppingItemsRef = AutoDisposeStreamProviderRef<List<ShoppingItem>>;
String _$shoppingListControllerHash() =>
    r'0724affbfe27d834e90d2b6a0599ab749c86e838';

/// Bring connection status controller (unchanged)
///
/// Copied from [ShoppingListController].
@ProviderFor(ShoppingListController)
final shoppingListControllerProvider =
    AutoDisposeAsyncNotifierProvider<ShoppingListController, bool>.internal(
  ShoppingListController.new,
  name: r'shoppingListControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$shoppingListControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ShoppingListController = AutoDisposeAsyncNotifier<bool>;
String _$nativeShoppingControllerHash() =>
    r'33a713553b69af4518f66a5f8e9e3fb5bb526d47';

/// Controller for native shopping list operations
///
/// Copied from [NativeShoppingController].
@ProviderFor(NativeShoppingController)
final nativeShoppingControllerProvider =
    AutoDisposeAsyncNotifierProvider<NativeShoppingController, void>.internal(
  NativeShoppingController.new,
  name: r'nativeShoppingControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$nativeShoppingControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NativeShoppingController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
