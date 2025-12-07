class AppConfig {
  /// Base URL for the PocketBase backend.
  ///
  /// Defaults to 'http://127.0.0.1:8091' for local development.
  /// Can be overridden at compile time using:
  /// `flutter run --dart-define=PB_URL=https://your-production-url.com`
  static const String pocketBaseUrl = String.fromEnvironment(
    'PB_URL',
    defaultValue: 'http://127.0.0.1:8091',
  );
}
