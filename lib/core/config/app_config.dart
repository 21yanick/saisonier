import 'dart:io' show Platform;

class AppConfig {
  // Live server URLs
  static const _livePocketBaseUrl = 'https://saisonier-api.21home.ch';
  static const _liveAiServiceUrl = 'https://saisonier-ai.21home.ch';

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

  /// Check if we're running against the live PocketBase server.
  static bool get isLiveMode {
    const pbUrl = String.fromEnvironment('PB_URL');
    return pbUrl.contains('saisonier-api.21home.ch');
  }

  /// Base URL for the AI Service (Gemini Proxy).
  ///
  /// Priority:
  /// 1. Compile-time override: `--dart-define=AI_URL=https://your-url.com`
  /// 2. If PB_URL points to live server → use live AI service
  /// 3. Android Emulator: Uses 10.0.2.2
  /// 4. Default: 127.0.0.1
  static String get aiServiceUrl {
    const envUrl = String.fromEnvironment('AI_URL');
    if (envUrl.isNotEmpty) return envUrl;

    // If using live PocketBase, also use live AI service
    if (isLiveMode) {
      return _liveAiServiceUrl;
    }

    // Local Development
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3001';
    }

    return 'http://127.0.0.1:3001';
  }
}
