import 'package:pocketbase/pocketbase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:saisonier/core/storage/shared_prefs_provider.dart';
import 'package:saisonier/core/config/app_config.dart';

part 'pocketbase_provider.g.dart';

@riverpod
PocketBase pocketbase(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  
  final store = AsyncAuthStore(
    save: (String data) async => prefs.setString('pb_auth', data),
    initial: prefs.getString('pb_auth'),
  );

  // Use 10.0.2.2 for Android Emulator, 127.0.0.1 for iOS/Web/Desktop
  final pb = PocketBase(AppConfig.pocketBaseUrl, authStore: store);
  return pb;
}
