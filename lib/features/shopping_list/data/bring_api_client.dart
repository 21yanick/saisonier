import 'dart:convert';
import 'package:http/http.dart' as http;

class BringApiException implements Exception {
  final String message;
  final int? statusCode;

  BringApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'BringApiException: $message (Status: $statusCode)';
}

class BringList {
  final String uuid;
  final String name;
  final String theme;

  BringList({required this.uuid, required this.name, required this.theme});

  factory BringList.fromJson(Map<String, dynamic> json) {
    return BringList(
      uuid: json['listUuid'] as String,
      name: json['name'] as String,
      theme: json['theme'] as String? ?? 'default',
    );
  }
}

class BringApiClient {
  static const _baseUrl = 'https://api.getbring.com/rest';

  /// Required headers for Bring! API authentication.
  /// These are reverse-engineered from the official Android app.
  static const _defaultHeaders = {
    'X-BRING-API-KEY': 'cof4Nc6D8saplXjE3h3HXqHH8m7VU2i1Gs0g85Sp',
    'X-BRING-CLIENT': 'android',
    'X-BRING-APPLICATION': 'bring',
    'X-BRING-COUNTRY': 'CH',
  };

  final http.Client _client;

  BringApiClient({http.Client? client}) : _client = client ?? http.Client();

  /// Authenticates with Bring! using email and password.
  /// Returns a tuple of (accessToken, userUuid) on success.
  Future<(String accessToken, String userUuid)> login(
    String email,
    String password,
  ) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/v2/bringauth'),
      headers: {
        ..._defaultHeaders,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'email': email,
        'password': password,
      },
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200 && data.containsKey('access_token')) {
      final accessToken = data['access_token'] as String?;
      final uuid = data['uuid'] as String?;

      if (accessToken == null || uuid == null) {
        throw BringApiException('Ungültige Server-Antwort');
      }

      return (accessToken, uuid);
    }

    // Handle error responses (Bring returns 200 with error body sometimes)
    final errorMessage = data['message'] as String?;
    final errorCode = data['errorcode'] as int?;

    if (errorMessage?.contains('not existing') == true || errorCode == 200) {
      throw BringApiException(
        'Email/Passwort-Kombination nicht gefunden.\n\n'
        'Mit Google/Apple/Facebook angemeldet?\n'
        'Setze zuerst ein Passwort in der Bring! App.',
        401,
      );
    } else if (response.statusCode == 400) {
      throw BringApiException('Ungültige Email-Adresse.', 400);
    } else {
      throw BringApiException(
        errorMessage ?? 'Login fehlgeschlagen',
        response.statusCode,
      );
    }
  }

  /// Loads all shopping lists for the authenticated user.
  Future<List<BringList>> loadLists(
    String accessToken,
    String userUuid,
  ) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/bringusers/$userUuid/lists'),
      headers: {
        ..._defaultHeaders,
        'Authorization': 'Bearer $accessToken',
        'X-BRING-USER-UUID': userUuid,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final lists = data['lists'] as List<dynamic>?;

      if (lists == null) {
        return [];
      }

      return lists
          .map((e) => BringList.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw BringApiException('Listen konnten nicht geladen werden', response.statusCode);
    }
  }

  /// Adds an item to a shopping list.
  Future<void> saveItem(
    String accessToken,
    String userUuid,
    String listUuid,
    String itemName,
    String specification,
  ) async {
    final response = await _client.put(
      Uri.parse('$_baseUrl/v2/bringlists/$listUuid'),
      headers: {
        ..._defaultHeaders,
        'Authorization': 'Bearer $accessToken',
        'X-BRING-USER-UUID': userUuid,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'purchase': itemName,
        'specification': specification,
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw BringApiException(
        'Artikel konnte nicht hinzugefügt werden',
        response.statusCode,
      );
    }
  }

  /// Adds multiple items to a shopping list in a batch.
  Future<void> saveItems(
    String accessToken,
    String userUuid,
    String listUuid,
    List<({String name, String specification})> items,
  ) async {
    // Bring! doesn't have a batch API, so we send items sequentially
    for (final item in items) {
      await saveItem(accessToken, userUuid, listUuid, item.name, item.specification);
    }
  }
}
