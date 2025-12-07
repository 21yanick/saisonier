import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saisonier/features/auth/data/repositories/auth_repository.dart';

import 'package:saisonier/features/auth/application/auth_sync_service.dart';

part 'auth_controller.g.dart';

@riverpod
Stream<RecordModel?> currentUser(Ref ref) async* {
  final repo = ref.watch(authRepositoryProvider);
  // Yield current state immediately
  yield repo.currentUser;
  // Yield subsequent changes
  yield* repo.authStateChanges;
}

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {
    // No initial state logic needed
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = await ref.read(authRepositoryProvider).login(email, password);
      // Trigger Sync
      await ref.read(authSyncServiceProvider).syncOnLogin(user);
    });
  }

  Future<void> register(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).register(email, password);
      // Auto login after registration
      final user = await ref.read(authRepositoryProvider).login(email, password);
      // Trigger Sync
      await ref.read(authSyncServiceProvider).syncOnLogin(user);
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      ref.read(authRepositoryProvider).logout();
      await ref.read(authSyncServiceProvider).clearLocalData();
    });
  }
}
