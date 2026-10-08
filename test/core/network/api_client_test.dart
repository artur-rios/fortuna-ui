import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:fortuna_ui/core/bindings/core_dispatcher.dart';
import 'package:fortuna_ui/core/network/api_client.dart';
import 'package:fortuna_ui/core/network/date_only_fields.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/storage/token_store.dart';

/// Answers HTTP from memory and remembers the body it was sent.
class CapturingHttpAdapter implements HttpClientAdapter {
  CapturingHttpAdapter(this.body, {this.status = 200});

  final String body;
  final int status;
  Object? sent;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    sent = options.data;
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

/// Answers core calls from memory and remembers the envelope it was sent.
class CapturingDispatcher implements CoreDispatcher {
  CapturingDispatcher(this.answer);

  final CoreResponse answer;
  Map<String, Object?>? sent;

  @override
  Future<CoreResponse> initialize(String requestJson) async =>
      const CoreResponse(status: 200, body: '');

  @override
  Future<CoreResponse> call(String symbol, String requestJson) async {
    sent = jsonDecode(requestJson) as Map<String, Object?>;
    return answer;
  }

  @override
  Future<void> dispose() async {}
}

/// The API's own failure envelope, as both the API and the core write it.
String refusal(String reason) => jsonEncode({
  'data': null,
  'messages': <String>[],
  'errors': [reason],
  'timestamp': '2026-10-08T12:00:00Z',
  'success': false,
});

Dio httpDio(CapturingHttpAdapter adapter) => ApiClientFactory(
  baseUrl: 'https://fortuna.example',
  tokenStore: InMemoryTokenStore(),
).create()..httpClientAdapter = adapter;

Dio ffiDio(CapturingDispatcher dispatcher) => ApiClientFactory(
  baseUrl: 'core://fortuna/',
  tokenStore: InMemoryTokenStore(),
  offlineDispatcher: dispatcher,
).create();

RecordTransactionCommand command(DateTime occurredOn) =>
    RecordTransactionCommand(
      occurredOn: occurredOn,
      amount: '12.5',
      direction: TransactionDirection.value2,
      categoryId: 'c0ffee00-0000-0000-0000-000000000000',
      financialAccountId: 'acc00000-0000-0000-0000-000000000000',
    );

Future<Failure<void>> failureOf(Future<void> Function() call) async {
  try {
    await call();
  } on DioException catch (exception) {
    return failureFromDioException<void>(exception);
  }
  fail('The call was expected to fail.');
}

void main() {
  group('failureFromDioException', () {
    test('Given the API refuses with its reason in errors '
        'When the failure is read '
        "Then the API's own reason is what the user sees (FR-DA-14, "
        'UC-02 AF-02)', () async {
      final dio = httpDio(
        CapturingHttpAdapter(
          refusal('The category does not exist.'),
          status: 404,
        ),
      );

      final failure = await failureOf(() => dio.get<void>('/api/tags'));

      expect(failure.message, 'The category does not exist.');
      expect(failure.kind, FailureKind.notFound);
    });

    test('Given several reasons '
        'When the failure is read '
        'Then all of them are shown', () async {
      final dio = httpDio(
        CapturingHttpAdapter(
          jsonEncode({
            'data': null,
            'messages': <String>[],
            'errors': ['Amount: too precise.', 'Tags: too many.'],
            'success': false,
          }),
          status: 400,
        ),
      );

      final failure = await failureOf(() => dio.get<void>('/api/tags'));

      expect(failure.message, 'Amount: too precise. Tags: too many.');
      expect(failure.kind, FailureKind.invalidInput);
    });

    test('Given a failure whose envelope states no error '
        'When the failure is read '
        'Then its messages are shown rather than a generic sentence', () async {
      final dio = httpDio(
        CapturingHttpAdapter(
          jsonEncode({
            'data': null,
            'messages': ['Not available.'],
            'errors': <String>[],
            'success': false,
          }),
          status: 409,
        ),
      );

      final failure = await failureOf(() => dio.get<void>('/api/tags'));

      expect(failure.message, 'Not available.');
      expect(failure.kind, FailureKind.conflict);
    });

    test('Given the same refusal over either transport '
        'When each failure is read '
        'Then both read identically (FR-DA-03)', () async {
      final overHttp = httpDio(
        CapturingHttpAdapter(
          refusal('A transaction needs a category.'),
          status: 400,
        ),
      );
      final overFfi = ffiDio(
        CapturingDispatcher(
          CoreResponse(
            status: 400,
            body: refusal('A transaction needs a category.'),
          ),
        ),
      );

      final fromHttp = await failureOf(
        () =>
            TransactionsClient(overHttp)
                .postApiTransactions(body: command(DateTime(2026, 10, 9))),
      );
      final fromFfi = await failureOf(
        () =>
            TransactionsClient(overFfi)
                .postApiTransactions(body: command(DateTime(2026, 10, 9))),
      );

      expect(fromHttp.message, 'A transaction needs a category.');
      expect(fromFfi, fromHttp);
    });

    test(
      'Given the core answers 501 for a route it does not implement '
      'When the failure is read '
      "Then it is unavailable offline, worded with the core's reason",
      () async {
        const reason =
            'POST /api/transfers is not available offline. Transfers are not '
            'implemented by the native core.';
        final dispatcher = CapturingDispatcher(
          CoreResponse(status: 501, body: refusal(reason)),
        );

        final failure = await failureOf(
          () =>
              ffiDio(dispatcher)
                  .post<void>('/api/transfers', data: const {'amount': '10'}),
        );

        expect(failure.kind, FailureKind.unavailableOffline);
        expect(failure.message, reason);
        // The core was asked: the 501 is the core's answer, not the adapter's.
        expect(dispatcher.sent, isNotNull);
      },
    );

    test('Given a route the core does not export at all '
        'When the adapter refuses it '
        'Then it reads as unavailable offline too', () async {
      final dispatcher = CapturingDispatcher(
        const CoreResponse(status: 200, body: '{"success":true}'),
      );

      final failure = await failureOf(
        () => ffiDio(dispatcher).post<void>('/api/auth/login', data: const {}),
      );

      expect(failure.kind, FailureKind.unavailableOffline);
      expect(failure.message, contains('not available offline'));
      expect(dispatcher.sent, isNull);
    });

    test('Given a 501 over HTTP '
        'When the failure is read '
        'Then it maps the same way on either transport', () async {
      final dio = httpDio(
        CapturingHttpAdapter(refusal('Not implemented here.'), status: 501),
      );

      final failure = await failureOf(() => dio.get<void>('/api/tags'));

      expect(failure.kind, FailureKind.unavailableOffline);
      expect(failure.message, 'Not implemented here.');
    });
  });

  group('Calendar dates on the wire', () {
    const confirmed =
        '{"data":null,"messages":["Recorded."],"errors":[],'
        '"timestamp":"2026-10-08T12:00:00Z","success":true}';

    test('Given a transaction dated with a picked day '
        'When it is sent over HTTP '
        'Then the date travels as yyyy-MM-dd, which is all the API accepts '
        'for a calendar date', () async {
      final adapter = CapturingHttpAdapter(confirmed);

      await TransactionsClient(httpDio(adapter))
          .postApiTransactions(body: command(DateTime(2026, 10, 9, 14, 22, 5)));

      final body = adapter.sent! as Map<String, dynamic>;
      expect(body['occurredOn'], '2026-10-09');
      // Nothing else in the body is touched.
      expect(body['amount'], '12.5');
    });

    test(
      'Given the same transaction '
      'When it is sent over either transport '
      'Then the core receives exactly the body the API would (FR-DA-03)',
      () async {
        final adapter = CapturingHttpAdapter(confirmed);
        final dispatcher = CapturingDispatcher(
          const CoreResponse(status: 200, body: confirmed),
        );

        await TransactionsClient(httpDio(adapter))
            .postApiTransactions(body: command(DateTime(2026, 10, 9)));
        await TransactionsClient(ffiDio(dispatcher))
            .postApiTransactions(body: command(DateTime(2026, 10, 9)));

        expect(dispatcher.sent!['body'], adapter.sent);
        expect(
          (dispatcher.sent!['body']! as Map<String, Object?>)['occurredOn'],
          '2026-10-09',
        );
      },
    );

    test('Given a body with nested and unrelated values '
        'When it is normalized '
        'Then only the calendar-date fields change', () {
      expect(
        normalizeDateOnlyFields({
          'periodStart': '2026-10-01T00:00:00.000',
          'periodEnd': '2026-10-31',
          'targetDate': null,
          'name': '2026-10-01T00:00:00.000',
          'items': [
            {'occurredOn': '2026-09-30T23:59:59.999Z'},
          ],
        }),
        {
          'periodStart': '2026-10-01',
          'periodEnd': '2026-10-31',
          'targetDate': null,
          'name': '2026-10-01T00:00:00.000',
          'items': [
            {'occurredOn': '2026-09-30'},
          ],
        },
      );
    });

    test('Given the published contract '
        'When its request bodies are read '
        'Then the calendar-date fields are exactly the ones normalized, and '
        'none of them is a timestamp anywhere', () {
      final contract = jsonDecode(
        File('api/fortuna.json').readAsStringSync(),
      ) as Map<String, dynamic>;
      final schemas =
          (contract['components'] as Map<String, dynamic>)['schemas']
              as Map<String, dynamic>;

      final requestSchemas = <String>{};
      for (final operations in (contract['paths'] as Map).values) {
        for (final operation in (operations as Map).values) {
          final content =
              ((operation as Map)['requestBody'] as Map?)?['content'] as Map?;
          for (final media in (content ?? const {}).values) {
            final ref = ((media as Map)['schema'] as Map?)?[r'$ref'];
            if (ref is String) requestSchemas.add(ref.split('/').last);
          }
        }
      }

      final dates = <String>{};
      final timestamps = <String>{};
      final seen = <String>{};
      void walk(String name) {
        if (!seen.add(name)) return;
        final properties =
            (schemas[name] as Map)['properties'] as Map? ?? const {};
        for (final MapEntry(:key, :value) in properties.entries) {
          final property = value as Map;
          switch (property['format']) {
            case 'date':
              dates.add(key as String);
            case 'date-time':
              timestamps.add(key as String);
          }
          final ref =
              property[r'$ref'] ?? (property['items'] as Map?)?[r'$ref'];
          if (ref is String) walk(ref.split('/').last);
        }
      }

      requestSchemas.forEach(walk);

      expect(dates, dateOnlyRequestFields);
      expect(timestamps.intersection(dateOnlyRequestFields), isEmpty);
    });
  });
}
