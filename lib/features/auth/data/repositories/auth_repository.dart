import 'package:pocketbase/pocketbase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saisonier/core/network/pocketbase_provider.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(ref.watch(pocketbaseProvider));
}

class AuthRepository {
  final PocketBase _pb;

  AuthRepository(this._pb);

  /// Stream of auth state changes.
  /// Emits [RecordModel] if logged in as user, null otherwise.
  Stream<RecordModel?> get authStateChanges {
    return _pb.authStore.onChange.map((e) {
      if (e.model is RecordModel) {
        return e.model as RecordModel;
      }
      return null;
    });
  }

  /// Current user or null.
  RecordModel? get currentUser {
    if (_pb.authStore.model is RecordModel) {
      return _pb.authStore.model as RecordModel;
    }
    return null;
  }

  Future<RecordModel> login(String email, String password) async {
    final authData = await _pb.collection('users').authWithPassword(email, password);
    return authData.record!;
  }

  Future<RecordModel> register(String email, String password) async {
    final user = await _pb.collection('users').create(body: {
      'email': email,
      'password': password,
      'passwordConfirm': password,
    });
    return user;
  }

  void logout() {
    _pb.authStore.clear();
  }
}
