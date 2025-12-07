import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saisonier/features/shopping_list/data/bring_api_client.dart';

part 'listing_service.g.dart';

const _kStorageKeyAccessToken = 'bring_access_token';
const _kStorageKeyUserUuid = 'bring_user_uuid';
const _kStorageKeyDefaultListId = 'bring_default_list_id';

class ListingService {
  final BringApiClient _apiClient;
  final FlutterSecureStorage _storage;

  ListingService(this._apiClient, this._storage);

  Future<bool> get isConnected async {
    final token = await _storage.read(key: _kStorageKeyAccessToken);
    return token != null;
  }

  Future<void> login(String email, String password) async {
    final (accessToken, userUuid) = await _apiClient.login(email, password);
    await _storage.write(key: _kStorageKeyAccessToken, value: accessToken);
    await _storage.write(key: _kStorageKeyUserUuid, value: userUuid);
    
    // Auto-select first list as default
    try {
      final lists = await _apiClient.loadLists(accessToken, userUuid);
      if (lists.isNotEmpty) {
        await _storage.write(key: _kStorageKeyDefaultListId, value: lists.first.uuid);
      }
    } catch (_) {
      // Ignore if list loading fails initially
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: _kStorageKeyAccessToken);
    await _storage.delete(key: _kStorageKeyUserUuid);
    await _storage.delete(key: _kStorageKeyDefaultListId);
  }

  Future<List<BringList>> getLists() async {
    final token = await _storage.read(key: _kStorageKeyAccessToken);
    final uuid = await _storage.read(key: _kStorageKeyUserUuid);
    
    if (token == null || uuid == null) {
      throw BringApiException('Not authenticated');
    }

    return _apiClient.loadLists(token, uuid);
  }

  Future<void> addItem(String itemName, String specification) async {
    final token = await _storage.read(key: _kStorageKeyAccessToken);
    final uuid = await _storage.read(key: _kStorageKeyUserUuid);
    final listId = await _storage.read(key: _kStorageKeyDefaultListId);

    if (token == null || uuid == null || listId == null) {
      throw BringApiException('No active list or not authenticated');
    }

    await _apiClient.saveItem(token, uuid, listId, itemName, specification);
  }
}

@riverpod
ListingService listingService(Ref ref) {
  return ListingService(
    BringApiClient(),
    const FlutterSecureStorage(),
  );
}
