import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:saisonier/core/network/pocketbase_provider.dart';
import 'package:saisonier/features/auth/application/auth_sync_service.dart';
import 'package:saisonier/features/seasonality/data/repositories/vegetable_repository.dart';
import '../../helpers/mocks.mocks.dart';
import '../../helpers/provider_container.dart';

void main() {
  late MockVegetableRepository mockRepo;
  late MockPocketBase mockPb;
  late MockRecordService mockUserService;
  late RecordModel user;

  setUp(() {
    mockRepo = MockVegetableRepository();
    mockPb = MockPocketBase();
    mockUserService = MockRecordService();
    
    when(mockPb.collection('users')).thenReturn(mockUserService);
    when(mockUserService.update(any, body: anyNamed('body')))
        .thenAnswer((_) async => RecordModel());
    
    // Default user stub
    user = RecordModel(id: 'user1', data: {'favorites': []});
  });

  test('syncOnLogin Pushes local favorites to remote (Merge A)', () async {
    // Arrange
    // Local has ['1']
    when(mockRepo.getFavoriteIds()).thenAnswer((_) async => ['1']);
    
    // Remote has [] (fresh fetch)
    when(mockUserService.getOne('user1')).thenAnswer((_) async => RecordModel(
      id: 'user1', 
      data: {'favorites': []}
    ));

    final container = createContainer(overrides: [
      vegetableRepositoryProvider.overrideWithValue(mockRepo),
      pocketbaseProvider.overrideWithValue(mockPb),
    ]);
    final service = container.read(authSyncServiceProvider);

    // Act
    await service.syncOnLogin(user);

    // Assert
    // Verify Update called with ['1']
    verify(mockUserService.update('user1', body: argThat(
      predicate<Map<String, dynamic>>((body) {
        final f = body['favorites'] as List;
        return f.length == 1 && f.contains('1');
      }),
      named: 'body',
    ))).called(1);
    
    // Verify NO local update (remote didn't have anything new)
    verifyNever(mockRepo.setFavorite(any, any));
  });

  test('syncOnLogin Pulls remote favorites to local (Merge B)', () async {
    // Arrange
    // Local has []
    when(mockRepo.getFavoriteIds()).thenAnswer((_) async => []);
    
    // Remote has ['2']
    when(mockUserService.getOne('user1')).thenAnswer((_) async => RecordModel(
      id: 'user1', 
      data: {'favorites': ['2']}
    ));

    final container = createContainer(overrides: [
      vegetableRepositoryProvider.overrideWithValue(mockRepo),
      pocketbaseProvider.overrideWithValue(mockPb),
    ]);
    final service = container.read(authSyncServiceProvider);

    // Act
    await service.syncOnLogin(user);

    // Assert
    // Verify Local setFavorite('2', true) called
    verify(mockRepo.setFavorite('2', true)).called(1);
    
    // Verify NO remote update (local didn't have anything new)
    verifyNever(mockUserService.update(any, body: anyNamed('body')));
  });

  test('syncOnLogin Merges both ways (Merge C)', () async {
    // Arrange
    // Local has ['1']
    when(mockRepo.getFavoriteIds()).thenAnswer((_) async => ['1']);
    
    // Remote has ['2']
    when(mockUserService.getOne('user1')).thenAnswer((_) async => RecordModel(
      id: 'user1', 
      data: {'favorites': ['2']}
    ));

    final container = createContainer(overrides: [
      vegetableRepositoryProvider.overrideWithValue(mockRepo),
      pocketbaseProvider.overrideWithValue(mockPb),
    ]);
    final service = container.read(authSyncServiceProvider);

    // Act
    await service.syncOnLogin(user);

    // Assert
    // 1. Verify Remote Update: Should be ['1', '2'] (or any order)
    verify(mockUserService.update('user1', body: argThat(
      predicate<Map<String, dynamic>>((body) {
        final f = body['favorites'] as List;
        return f.contains('1') && f.contains('2') && f.length == 2;
      }),
      named: 'body',
    ))).called(1);

    // 2. Verify Local Update: Should set '2' as favorite (since it was missing locally)
    verify(mockRepo.setFavorite('2', true)).called(1);
    // Should NOT set '1' (already exists) - Impl logic checks logicSet.contains
    verifyNever(mockRepo.setFavorite('1', any));
  });
}
