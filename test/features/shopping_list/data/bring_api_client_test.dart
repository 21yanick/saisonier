import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:saisonier/features/shopping_list/data/bring_api_client.dart';

@GenerateMocks([http.Client])
import 'bring_api_client_test.mocks.dart';

void main() {
  late BringApiClient apiClient;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    apiClient = BringApiClient(client: mockClient);
  });

  group('BringApiClient', () {
    test('login returns token and uuid on success', () async {
      when(mockClient.post(
        Uri.parse('https://api.getbring.com/rest/v2/bringauth'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
            '{"access_token": "token123", "uuid": "user-uuid-123", "refresh_token": "refresh"}',
            200,
          ));

      final result = await apiClient.login('test@email.com', 'password');

      expect(result.$1, 'token123');
      expect(result.$2, 'user-uuid-123');
      verify(mockClient.post(any, body: {'email': 'test@email.com', 'password': 'password'})).called(1);
    });

    test('login throws BringApiException on failure', () async {
      when(mockClient.post(any, body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('Unauthorized', 401));

      expect(
        () => apiClient.login('test@email.com', 'password'),
        throwsA(isA<BringApiException>()),
      );
    });

    test('loadLists returns lists', () async {
      const responseBody = '''
      {
        "lists": [
          {"listUuid": "list-1", "name": "Home", "theme": "red"},
          {"listUuid": "list-2", "name": "Office", "theme": "blue"}
        ]
      }
      ''';

      when(mockClient.get(
        Uri.parse('https://api.getbring.com/rest/bringusers/user-uuid/lists'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(responseBody, 200));

      final lists = await apiClient.loadLists('token', 'user-uuid');

      expect(lists.length, 2);
      expect(lists[0].name, 'Home');
      expect(lists[1].uuid, 'list-2');
    });

    test('saveItem puts item to list', () async {
      when(mockClient.put(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('', 204));

      await apiClient.saveItem('token', 'list-id', 'Milk', '2 liters');

      verify(mockClient.put(
        Uri.parse('https://api.getbring.com/rest/v2/bringlists/list-id'),
        headers: argThat(containsPair('Authorization', 'Bearer token'), named: 'headers'),
        body: {'purchase': 'Milk', 'specification': '2 liters'},
      )).called(1);
    });
  });
}
