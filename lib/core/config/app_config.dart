import 'dart:io' show Platform;

class AppConfig {
  /// Base URL for the PocketBase backend.
  ///
  /// Priority:
  /// 1. Compile-time override: `--dart-define=PB_URL=https://your-url.com`
  /// 2. Android Emulator: Uses 10.0.2.2 (host loopback alias)
  /// 3. Default: 127.0.0.1 for Desktop/iOS Simulator
  static String get pocketBaseUrl {
    const envUrl = String.fromEnvironment('PB_URL');
    if (envUrl.isNotEmpty) return envUrl;

    // Android Emulator uses 10.0.2.2 to reach host's localhost
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8091';
    }

    return 'http://127.0.0.1:8091';
  }
}
