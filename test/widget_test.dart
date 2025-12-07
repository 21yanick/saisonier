import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/native.dart';
import 'package:mockito/mockito.dart';

import 'package:saisonier/main.dart';
import 'package:saisonier/core/database/app_database.dart';
import 'package:saisonier/core/storage/shared_prefs_provider.dart';
import 'package:saisonier/core/network/pocketbase_provider.dart';
import 'package:saisonier/features/seasonality/data/repositories/vegetable_repository.dart';
import 'package:saisonier/features/seasonality/data/repositories/recipe_repository.dart';

import 'helpers/mocks.mocks.dart';
import 'helpers/test_env.dart';

void main() {
  late AppDatabase db;
  late MockPocketBase mockPb;
  late MockAuthStore mockAuthStore;
  late MockVegetableRepository mockVegRepo;
  late MockRecipeRepository mockRecipeRepo;

  setUp(() {
    setupSqlite(); 
    db = AppDatabase(NativeDatabase.memory());
    
    mockPb = MockPocketBase();
    mockAuthStore = MockAuthStore();
    mockVegRepo = MockVegetableRepository();
    mockRecipeRepo = MockRecipeRepository();

    when(mockPb.authStore).thenReturn(mockAuthStore);
    when(mockAuthStore.isValid).thenReturn(false);
    when(mockAuthStore.model).thenReturn(null);

    // Stub Repositories to prevent async side-effects in init
    when(mockVegRepo.sync()).thenAnswer((_) async {});
    when(mockRecipeRepo.sync()).thenAnswer((_) async {});
    
    // Stub Data Streams for UI
    when(mockVegRepo.watchSeasonal(any)).thenAnswer((_) => Stream.value([]));
    // when(mockRecipeRepo.watchAll()).thenAnswer((_) => Stream.value([]));

    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('App initializes and shows Core Navigation', (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          sharedPreferencesProvider.overrideWithValue(prefs),
          pocketbaseProvider.overrideWithValue(mockPb),
          vegetableRepositoryProvider.overrideWithValue(mockVegRepo),
          recipeRepositoryProvider.overrideWithValue(mockRecipeRepo),
        ],
        child: const SaisonierApp(),
      ),
    );

    // Pump to settle any animations or microtasks
    await tester.pumpAndSettle();

    // Verify Core Navigation (TogglePill text)
    expect(find.text('Saison'), findsOneWidget);
    expect(find.text('Katalog'), findsOneWidget);
  });
}
