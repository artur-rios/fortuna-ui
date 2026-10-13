import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/auth/data/registration_repository.dart';

/// Answers from memory and remembers what it was sent.
class _Adapter implements HttpClientAdapter {
  _Adapter(this.status, this.body);

  final int status;
  final String body;
  RequestOptions? request;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options;
    return ResponseBody.fromString(
      body,
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

HttpRegistrationRepository _repository(_Adapter adapter) =>
    HttpRegistrationRepository(
      AuthClient(
        Dio(BaseOptions(baseUrl: 'https://fortuna.example'))
          ..httpClientAdapter = adapter,
      ),
    );

void main() {
  group('HttpRegistrationRepository', () {
    test('Given the API accepts '
        'When registering '
        'Then its own message is returned and the request is the documented shape', () async {
      final adapter = _Adapter(
        202,
        jsonEncode({
          'success': true,
          'data': <String, Object?>{},
          'messages': ['Check your email.'],
          'errors': <String>[],
        }),
      );

      final result = await _repository(adapter).register(
        name: 'New Person',
        email: 'new@example.com',
        password: 'a-long-secret',
      );

      expect(result, const Success('Check your email.'));
      expect(adapter.request!.path, endsWith('/api/auth/register'));
      expect(adapter.request!.method, 'POST');
      final sent = jsonDecode(jsonEncode(adapter.request!.data)) as Map;
      expect(sent['name'], 'New Person');
      expect(sent['email'], 'new@example.com');
      expect(sent['password'], 'a-long-secret');
    });

    test('Given the API accepts with no message '
        'When registering '
        "Then the API's own wording is the fallback", () async {
      final adapter = _Adapter(
        202,
        jsonEncode({
          'success': true,
          'data': <String, Object?>{},
          'messages': <String>[],
          'errors': <String>[],
        }),
      );

      final result = await _repository(adapter).register(
        name: 'New Person',
        email: 'new@example.com',
        password: 'a-long-secret',
      );

      expect(
        result,
        const Success(
          "If this address can be registered, we've sent it an email. "
          'Follow it, then sign in.',
        ),
      );
    });

    test('Given the scope is closed '
        'When registering '
        'Then the API reason is returned as forbidden', () async {
      final adapter = _Adapter(
        403,
        jsonEncode({
          'success': false,
          'errors': ['This instance is not accepting new accounts.'],
          'messages': <String>[],
        }),
      );

      final result = await _repository(adapter).register(
        name: 'New Person',
        email: 'new@example.com',
        password: 'a-long-secret',
      );

      expect(
        result,
        const Failure<String>(
          message: 'This instance is not accepting new accounts.',
          kind: FailureKind.forbidden,
        ),
      );
    });

    test('Given Heimdall is down '
        'When registering '
        'Then a server error carrying the API reason is returned', () async {
      final adapter = _Adapter(
        503,
        jsonEncode({
          'success': false,
          'errors': ['The identity service is temporarily unavailable.'],
          'messages': <String>[],
        }),
      );

      final result = await _repository(adapter).register(
        name: 'New Person',
        email: 'new@example.com',
        password: 'a-long-secret',
      );

      expect(result, isA<Failure<String>>());
      expect((result as Failure<String>).kind, FailureKind.serverError);
      expect(
        result.message,
        'The identity service is temporarily unavailable.',
      );
    });
  });
}
