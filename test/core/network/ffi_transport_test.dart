import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/bindings/core_dispatcher.dart';
import 'package:fortuna_ui/core/bindings/core_route.dart';
import 'package:fortuna_ui/core/network/ffi_transport.dart';

/// Records what the boundary was asked, and answers from memory.
class FakeDispatcher implements CoreDispatcher {
  FakeDispatcher({this.answer, this.fail});

  CoreResponse? answer;
  CoreUnavailable? fail;

  final List<String> symbols = [];
  final List<Map<String, Object?>> requests = [];

  @override
  Future<CoreResponse> initialize(String requestJson) async =>
      const CoreResponse(status: 200, body: '');

  @override
  Future<CoreResponse> call(String symbol, String requestJson) async {
    symbols.add(symbol);
    requests.add(jsonDecode(requestJson) as Map<String, Object?>);

    final failure = fail;
    if (failure != null) throw failure;

    return answer ?? const CoreResponse(status: 200, body: '{"success":true}');
  }

  @override
  Future<void> dispose() async {}
}

/// Answers HTTP from memory, for the two-transport comparison.
class StubHttpAdapter implements HttpClientAdapter {
  StubHttpAdapter(this.body, {this.status = 200});

  final String body;
  final int status;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString(
    body,
    status,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );

  @override
  void close({bool force = false}) {}
}

Dio offlineDio(CoreDispatcher dispatcher) =>
    Dio(BaseOptions(baseUrl: 'core://fortuna/'))
      ..httpClientAdapter = FfiHttpClientAdapter(dispatcher);

void main() {
  group('buildCoreRequest', () {
    RequestOptions options({
      String method = 'GET',
      String path = '/api/tags',
      Map<String, dynamic> headers = const {},
      Map<String, dynamic> query = const {},
      Object? data,
    }) => RequestOptions(
      method: method,
      path: path,
      headers: Map.of(headers),
      queryParameters: Map.of(query),
      data: data,
    );

    test('Given a request carrying a bearer token '
        'When the envelope is built '
        'Then the core receives the token without its scheme', () {
      final envelope = buildCoreRequest(
        options(headers: {'Authorization': 'Bearer abc.def.ghi'}),
        const ResolvedRoute(symbol: 's', values: {}),
      );

      expect(envelope['token'], 'abc.def.ghi');
    });

    test('Given a request with no token '
        'When the envelope is built '
        'Then the token is empty rather than absent or null', () {
      final envelope = buildCoreRequest(
        options(),
        const ResolvedRoute(symbol: 's', values: {}),
      );

      expect(envelope['token'], '');
    });

    test('Given a resolved route '
        'When the envelope is built '
        'Then its captured values travel under "route"', () {
      final envelope = buildCoreRequest(
        options(path: '/api/accounts/abc'),
        const ResolvedRoute(symbol: 's', values: {'id': 'abc'}),
      );

      expect(envelope['route'], {'id': 'abc'});
    });

    test('Given query parameters '
        'When the envelope is built '
        'Then they travel under "query" and a null is dropped', () {
      final envelope = buildCoreRequest(
        options(query: {'page': 2, 'includeDeleted': true, 'q': null}),
        const ResolvedRoute(symbol: 's', values: {}),
      );

      expect(envelope['query'], {'page': 2, 'includeDeleted': true});
    });

    test('Given a repeated query parameter '
        'When the envelope is built '
        'Then it stays a list rather than being flattened', () {
      final envelope = buildCoreRequest(
        options(
          query: {
            'tag': ['a', 'b'],
          },
        ),
        const ResolvedRoute(symbol: 's', values: {}),
      );

      expect((envelope['query']! as Map)['tag'], ['a', 'b']);
    });

    test('Given a body carrying a monetary amount as a decimal string '
        'When the envelope is built '
        'Then the amount travels unchanged, never through a double '
        '(UC-02 step 4, FR-DA-11)', () {
      final envelope = buildCoreRequest(
        options(
          method: 'POST',
          path: '/api/transactions',
          data: {'amount': '8017.61', 'currency': 'BRL'},
        ),
        const ResolvedRoute(symbol: 's', values: {}),
      );

      final body = envelope['body']! as Map;
      expect(body['amount'], '8017.61');
      expect(body['amount'], isA<String>());
      // The exact figure that a double would have corrupted.
      expect(jsonEncode(envelope), contains('"8017.61"'));
    });

    test('Given a body already encoded as a JSON string '
        'When the envelope is built '
        'Then it is carried as an object rather than as a quoted string', () {
      final envelope = buildCoreRequest(
        options(method: 'POST', data: '{"amount":"1.005"}'),
        const ResolvedRoute(symbol: 's', values: {}),
      );

      expect(envelope['body'], {'amount': '1.005'});
    });

    test('Given a request with no body '
        'When the envelope is built '
        'Then no body key is sent at all', () {
      final envelope = buildCoreRequest(
        options(),
        const ResolvedRoute(symbol: 's', values: {}),
      );

      expect(envelope.containsKey('body'), isFalse);
    });
  });

  group('FfiHttpClientAdapter', () {
    test('Given a route the core serves '
        'When a request is made '
        'Then it reaches the matching symbol and the answer comes back '
        '(UC-02 main flow)', () async {
      final dispatcher = FakeDispatcher(
        answer: const CoreResponse(
          status: 200,
          body: '{"data":[],"success":true}',
        ),
      );

      final response = await offlineDio(dispatcher)
          .get<Map<String, dynamic>>('/api/tags');

      expect(dispatcher.symbols, ['fortuna_api_tags_get']);
      expect(response.statusCode, 200);
      expect(response.data, {'data': <Object?>[], 'success': true});
    });

    test('Given a route the core does not export '
        'When a request is made '
        'Then it is refused as unavailable offline and the core is never '
        'called', () async {
      final dispatcher = FakeDispatcher();
      final dio = offlineDio(dispatcher);

      final response = await dio.post<Map<String, dynamic>>(
        '/api/auth/login',
        data: const {'email': 'someone@example.com'},
        options: Options(validateStatus: (_) => true),
      );

      expect(response.statusCode, 501);
      expect(
        (response.data!['messages']! as List).first,
        contains('not available offline'),
      );
      expect(dispatcher.symbols, isEmpty);
    });

    test('Given the core cannot be reached '
        'When a request is made '
        'Then a failure response carries the reason and no exception escapes '
        '(UC-02 AF-01)', () async {
      final dispatcher = FakeDispatcher(
        fail: const CoreUnavailable('The core could not be loaded.'),
      );

      final response = await offlineDio(dispatcher).get<Map<String, dynamic>>(
        '/api/tags',
        options: Options(validateStatus: (_) => true),
      );

      expect(response.statusCode, 503);
      expect(
        (response.data!['messages']! as List).first,
        'The core could not be loaded.',
      );
    });

    test(
      'Given the core refuses the operation '
      'When it answers with its own reason '
      'Then that reason reaches the caller unaltered (UC-02 AF-02, AF-03)',
      () async {
        final dispatcher = FakeDispatcher(
          answer: const CoreResponse(
            status: 400,
            body:
                '{"data":null,"success":false,'
                '"messages":["A transaction needs a category."]}',
          ),
        );

        final response = await offlineDio(dispatcher)
            .post<Map<String, dynamic>>(
              '/api/transactions',
              data: const {'amount': '10.00'},
              options: Options(validateStatus: (_) => true),
            );

        // AF-03: the client believed this valid; the core's answer stands.
        expect(response.statusCode, 400);
        expect(
          (response.data!['messages']! as List).first,
          'A transaction needs a category.',
        );
      },
    );

    test('Given the same answer over either transport '
        'When a caller reads it '
        'Then it reads identically (UC-02, FR-DA-03)', () async {
      const body = '{"data":[{"id":"1","name":"Groceries"}],"success":true}';

      final overHttp = Dio(BaseOptions(baseUrl: 'https://fortuna.example'))
        ..httpClientAdapter = StubHttpAdapter(body);
      final overFfi = offlineDio(
        FakeDispatcher(answer: const CoreResponse(status: 200, body: body)),
      );

      final fromHttp = await overHttp.get<Map<String, dynamic>>('/api/tags');
      final fromFfi = await overFfi.get<Map<String, dynamic>>('/api/tags');

      expect(fromFfi.data, fromHttp.data);
      expect(fromFfi.statusCode, fromHttp.statusCode);
    });

    test('Given a response carrying a field the client does not know '
        'When it is parsed '
        'Then the unknown field is ignored rather than crashing the parse '
        '(UC-02 AF-07)', () async {
      final dispatcher = FakeDispatcher(
        answer: const CoreResponse(
          status: 200,
          body: '{"data":[],"success":true,"aFieldFromALaterContract":42}',
        ),
      );

      final response = await offlineDio(dispatcher)
          .get<Map<String, dynamic>>('/api/tags');

      expect(response.statusCode, 200);
      expect(response.data!['success'], true);
    });

    test('Given a request with a route value that needs encoding '
        'When it is dispatched '
        'Then the core receives the decoded value', () async {
      final dispatcher = FakeDispatcher();

      await offlineDio(dispatcher)
          .get<Map<String, dynamic>>('/api/currencies/BRL');

      expect(dispatcher.requests.single['route'], {'code': 'BRL'});
    });
  });
}
