import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saisonier/features/shopping_list/application/listing_service.dart';

part 'shopping_list_controller.g.dart';

@riverpod
class ShoppingListController extends _$ShoppingListController {
  @override
  FutureOr<bool> build() async {
    return ref.watch(listingServiceProvider).isConnected;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(listingServiceProvider).login(email, password);
      return true;
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(listingServiceProvider).logout();
      return false;
    });
  }

  Future<void> addItem(String item, String spec) async {
    await ref.read(listingServiceProvider).addItem(item, spec);
  }
}
