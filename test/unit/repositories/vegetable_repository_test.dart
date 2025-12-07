import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:saisonier/core/database/app_database.dart';
import 'package:saisonier/features/seasonality/data/repositories/vegetable_repository.dart';
// import 'package:saisonier/features/seasonality/data/remote/vegetable_dto.dart';
import '../../helpers/mocks.mocks.dart';
import '../../helpers/test_env.dart';

void main() {
  late AppDatabase db;
  late MockPocketBase mockPb;
  late MockRecordService mockRecordService;
  late MockAuthStore mockAuthStore;
  late VegetableRepository repository;

  setUp(() {
    setupSqlite();
    // 1. In-Memory Database
    db = AppDatabase(NativeDatabase.memory());
    
    // 2. Mock PocketBase
    mockPb = MockPocketBase();
    mockRecordService = MockRecordService();
    mockAuthStore = MockAuthStore();

    // Stub common PB properties
    when(mockPb.collection('vegetables')).thenReturn(mockRecordService);
    when(mockPb.collection('users')).thenReturn(mockRecordService);
    when(mockPb.authStore).thenReturn(mockAuthStore);
    when(mockAuthStore.isValid).thenReturn(false); // Default: Guest
    when(mockAuthStore.model).thenReturn(null);

    // 3. Repository
    repository = VegetableRepository(db, mockPb);
  });

  tearDown(() async {
    await db.close();
  });

  group('VegetableRepository', () {
    test('watchAll returns sorted vegetables', () async {
      // Arrange
      await db.batch((batch) {
        batch.insertAll(db.vegetables, [
          VegetablesCompanion.insert(
            id: '1',
            name: 'Zucchetti', // Tier 2
            type: 'vegetable',
            description: const drift.Value('Desc'),
            image: 'img.png',
            hexColor: '#000000',
            months: '[7, 8]',
            tier: 2,
          ),
          VegetablesCompanion.insert(
            id: '2',
            name: 'Auberffine', // Tier 1 (Made up name to test sort)
            type: 'vegetable',
            description: const drift.Value('Desc'),
            image: 'img.png',
            hexColor: '#000000',
            months: '[7, 8]',
            tier: 1,
          ),
        ]);
      });

      // Act
      final stream = repository.watchAll();
      final result = await stream.first;

      // Assert (Sort by Name for watchAll as per impl line 30 in repo)
      // Wait, repo line 30 says: orderBy: [(t) => OrderingTerm(expression: t.name)]
      // So Auberffine should be first.
      expect(result.length, 2);
      expect(result.first.name, 'Auberffine');
      expect(result.last.name, 'Zucchetti');
    });

    test('watchSeasonal filters by month and sorts by Tier then Name', () async {
      // Arrange
      await db.batch((batch) {
        batch.insertAll(db.vegetables, [
          VegetablesCompanion.insert(
            id: '1',
            name: 'Winter Item',
            type: 'veg',
            description: const drift.Value(''),
            image: '',
            hexColor: '',
            months: '[12, 1, 2]',
            tier: 2,
          ),
          VegetablesCompanion.insert(
            id: '2',
            name: 'Summer Item',
            type: 'veg',
            description: const drift.Value(''),
            image: '',
            hexColor: '',
            months: '[6, 7, 8]',
            tier: 1,
          ),
          VegetablesCompanion.insert(
            id: '3',
            name: 'Another Winter',
            type: 'veg',
            description: const drift.Value(''),
            image: '',
            hexColor: '',
            months: '[1]',
            tier: 1, // Higher tier than Winter Item
          ),
        ]);
      });

      // Act
      final stream = repository.watchSeasonal(1); // January
      final result = await stream.first;

      // Assert
      // Expected: [Another Winter (Tier 1), Winter Item (Tier 2)]
      expect(result.length, 2);
      expect(result[0].name, 'Another Winter');
      expect(result[1].name, 'Winter Item');
      // Summer item should be excluded
      expect(result.any((e) => e.name == 'Summer Item'), false);
    });

    test('toggleFavorite updates local DB and calls API when logged in', () async {
      // Arrange: Add item
      await db.into(db.vegetables).insert(
        VegetablesCompanion.insert(
          id: '1',
          name: 'Carrot',
          type: 'veg',
          description: const drift.Value(''),
          image: '',
          hexColor: '',
          months: '[]',
          tier: 1,
          isFavorite: const drift.Value(false),
        ),
      );

      // Arrange: Login User
      final user = RecordModel(id: 'user1', data: {'favorites': []});
      when(mockAuthStore.isValid).thenReturn(true);
      when(mockAuthStore.model).thenReturn(user);
      
      // Stub update call
      when(mockPb.collection('users')).thenReturn(mockRecordService);
      when(mockRecordService.update(any, body: anyNamed('body')))
          .thenAnswer((_) async => user); // Return dummy

      // Act
      await repository.toggleFavorite('1');

      // Assert: Local
      final updated = await (db.select(db.vegetables)..where((t) => t.id.equals('1'))).getSingle();
      expect(updated.isFavorite, true);

      // Assert: Remote
      verify(mockRecordService.update('user1', body: argThat(
        predicate<Map<String, dynamic>>((body) {
          final favs = body['favorites'] as List;
          return favs.contains('1');
        }),
        named: 'body',
      ))).called(1);
    });

    test('sync merges remote data and preserves local favorites', () async {
      // Arrange: Local DB has "Old Name" and isFavorite=true
      await db.into(db.vegetables).insert(
        VegetablesCompanion.insert(
          id: '1',
          name: 'Old Name',
          type: 'veg',
          description: const drift.Value(''),
          image: '',
          hexColor: '',
          months: '[]',
          tier: 1,
          isFavorite: const drift.Value(true),
        ),
      );

      // Arrange: Remote has "New Name"
      final remoteJson = {
        'id': '1',
        'name': 'New Name',
        'type': 'veg',
        'description': 'New Desc',
        'image': 'img.png',
        'hex_color': '#fff',
        'months': [1],
        'tier': 1,
        'created': '2023-01-01 10:00:00.000Z',
        'updated': '2023-01-01 10:00:00.000Z',
        'collectionId': 'col1',
        'collectionName': 'vegetables',
      };
      final recordHelper = RecordModel.fromJson(remoteJson);
      
      when(mockRecordService.getFullList()).thenAnswer((_) async => [recordHelper]);

      // Act
      await repository.sync();

      // Assert
      final result = await (db.select(db.vegetables)..where((t) => t.id.equals('1'))).getSingle();
      
      // Should have new name (Sync update)
      expect(result.name, 'New Name');
      // Should preserve favorite (Local state)
      expect(result.isFavorite, true); 
    });
  });
}
