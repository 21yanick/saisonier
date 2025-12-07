import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saisonier/core/network/pocketbase_provider.dart';
// import 'package:saisonier/features/auth/presentation/controllers/auth_controller.dart';
import 'package:saisonier/features/seasonality/data/repositories/vegetable_repository.dart';

part 'auth_sync_service.g.dart';

@riverpod
AuthSyncService authSyncService(Ref ref) {
  return AuthSyncService(ref);
}

class AuthSyncService {
  final Ref _ref;

  AuthSyncService(this._ref);

  /// Called when verifying auth state or after login.
  /// Merges local favorites with remote favorites.
  Future<void> syncOnLogin(RecordModel user) async {
    final vegRepo = _ref.read(vegetableRepositoryProvider);
    final pb = _ref.read(pocketbaseProvider);

    try {
      // 1. Get Local Favorites
      final localIds = await vegRepo.getFavoriteIds();

      // 2. Get Remote Favorites
      // Need to fetch fresh user record to ensure we have the list
      final freshUser = await pb.collection('users').getOne(user.id);
      final remoteList = freshUser.data['favorites'];
      
      List<String> remoteIds = [];
      if (remoteList is List) {
        remoteIds = remoteList.map((e) => e.toString()).toList();
      }

      // 3. Union Merge
      final Set<String> mergedSet = {...localIds, ...remoteIds};
      final mergedList = mergedSet.toList();

      // Optimize: Only if different
      final localSet = localIds.toSet();
      final remoteSet = remoteIds.toSet();

      final needsRemoteUpdate = !remoteSet.containsAll(localSet);
      final needsLocalUpdate = !localSet.containsAll(remoteSet);

      // 4. Update Remote if needed (Action: Add local favs to cloud)
      if (needsRemoteUpdate) {
        await pb.collection('users').update(user.id, body: {
          'favorites': mergedList,
        });
        // print('Sync: Updated Remote with ${mergedList.length} items');
      }

      // 5. Update Local if needed (Action: Mark cloud favs as local favs)
      if (needsLocalUpdate) {
        for (final id in mergedList) {
          if (!localSet.contains(id)) {
            await vegRepo.setFavorite(id, true);
          }
        }
        // print('Sync: Updated Local with new favorites from cloud');
      }

    } catch (e) {
      // Silent fail allowed in background, but ideally log
      // print('AuthSyncService Error: $e');
    }
  }

  /// Called on Logout
  Future<void> clearLocalData() async {
    await _ref.read(vegetableRepositoryProvider).clearAllFavorites();
  }
}
