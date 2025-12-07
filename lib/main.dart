import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:saisonier/core/router/app_router.dart';
import 'package:saisonier/core/theme/app_theme.dart';
import 'package:saisonier/core/storage/shared_prefs_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  runApp(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
    child: const SaisonierApp(),
  ));
}

class SaisonierApp extends ConsumerWidget {
  const SaisonierApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Saisonier',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
