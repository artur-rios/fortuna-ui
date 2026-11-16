import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/ingestion/data/connection_repository.dart';

import '../../../support/api_stub.dart';

Map<String, Object?> connectionOutput({
  Object? id = 'c1',
  Object? status = 1,
  Object? createdAt = '2026-10-01T12:00:00Z',
  Object? externalReference = 'item-42',
}) => {
  'id': ?id,
  'status': ?status,
  'createdAt': ?createdAt,
  'externalReference': ?externalReference,
  'dataSourceType': 2,
};

void main() {
  group('HttpConnectionRepository.list', () {
    test('Given a connection the API holds '
        'When the connections are listed '
        'Then it is fetched without filters and mapped', () async {
      final stub = ApiStub.data([connectionOutput()]);

      final result = await HttpConnectionRepository.fromDio(stub.dio).list();

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/connections');
      expect(stub.request.queryParameters, isEmpty);
      final connection = result.valueOrNull!.single;
      expect(connection.id, 'c1');
      expect(connection.state, BankConnectionState.active);
      expect(connection.connectedAt, DateTime.utc(2026, 10, 1, 12));
      expect(connection.externalReference, 'item-42');
      expect(connection.isRevoked, isFalse);
    });

    test('Given each status the API publishes '
        'When the connections are listed '
        'Then 1, 2 and 3 are active, needing reauthentication and revoked, '
        'and anything else is unknown', () async {
      final stub = ApiStub.data([
        connectionOutput(status: 1),
        connectionOutput(status: 2),
        connectionOutput(status: 3),
        connectionOutput(status: 9),
        connectionOutput(status: null),
      ]);

      final result = await HttpConnectionRepository.fromDio(stub.dio).list();

      expect(result.valueOrNull!.map((c) => c.state), [
        BankConnectionState.active,
        BankConnectionState.requiresReauthentication,
        BankConnectionState.revoked,
        BankConnectionState.unknown,
        BankConnectionState.unknown,
      ]);
      expect(result.valueOrNull!.map((c) => c.isRevoked), [
        false,
        false,
        true,
        false,
        false,
      ]);
    });

    test('Given a connection with every optional field missing '
        'When it is listed '
        'Then the gaps read as empty rather than failing', () async {
      final stub = ApiStub.data([
        connectionOutput(
          id: null,
          status: null,
          createdAt: null,
          externalReference: null,
        ),
      ]);

      final result = await HttpConnectionRepository.fromDio(stub.dio).list();

      final connection = result.valueOrNull!.single;
      expect(connection.id, '');
      expect(connection.state, BankConnectionState.unknown);
      expect(connection.connectedAt, isA<DateTime>());
      expect(connection.externalReference, isNull);
    });

    test('Given an answer with no data '
        'When the connections are listed '
        'Then there are none', () async {
      final stub = ApiStub.data(null);

      final result = await HttpConnectionRepository.fromDio(stub.dio).list();

      expect(result.valueOrNull, isEmpty);
    });

    test('Given an instance that cannot be reached '
        'When the connections are listed '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpConnectionRepository.fromDio(stub.dio).list();

      expect(
        result,
        const Failure<List<Connection>>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpConnectionRepository.connect', () {
    test('Given an institution to connect '
        'When it is connected '
        'Then the source and reference are posted and the answer is mapped '
        '(UC-30)', () async {
      final stub = ApiStub.data({
        ...connectionOutput(),
        'institution': 'Bank',
      }, status: 201);

      final result = await HttpConnectionRepository.fromDio(stub.dio)
          .connect(dataSource: 'pluggy', externalReference: 'item-42');

      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/connections');
      expect(stub.body, {
        'dataSource': 'pluggy',
        'externalReference': 'item-42',
      });
      final connection = result.valueOrNull!;
      expect(connection.id, 'c1');
      expect(connection.state, BankConnectionState.active);
      expect(connection.connectedAt, DateTime.utc(2026, 10, 1, 12));
      expect(connection.externalReference, 'item-42');
    });

    test('Given an answer that names no reference and no id '
        'When an institution is connected '
        'Then the reference sent is kept and the id reads as empty', () async {
      final stub = ApiStub.data(
        connectionOutput(
          id: null,
          status: 2,
          createdAt: null,
          externalReference: null,
        ),
      );

      final result = await HttpConnectionRepository.fromDio(stub.dio)
          .connect(dataSource: 'pluggy', externalReference: 'item-42');

      final connection = result.valueOrNull!;
      expect(connection.id, '');
      expect(connection.state, BankConnectionState.requiresReauthentication);
      expect(connection.connectedAt, isA<DateTime>());
      expect(connection.externalReference, 'item-42');
    });

    test('Given an answer with no data '
        'When an institution is connected '
        'Then it is a server failure, not a connection', () async {
      final stub = ApiStub.data(null);

      final result = await HttpConnectionRepository.fromDio(stub.dio)
          .connect(dataSource: 'pluggy', externalReference: 'item-42');

      expect(
        result,
        const Failure<Connection>(
          message: 'The instance did not confirm the connection.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test('Given no consent for external processing '
        'When an institution is connected '
        "Then the API's reason is the failure (UC-30 AF-03)", () async {
      final stub = ApiStub(
        (_) => refusal(403, ['Consent for open banking is required.']),
      );

      final result = await HttpConnectionRepository.fromDio(stub.dio)
          .connect(dataSource: 'pluggy', externalReference: 'item-42');

      expect(
        result,
        const Failure<Connection>(
          message: 'Consent for open banking is required.',
          kind: FailureKind.forbidden,
        ),
      );
    });

    test('Given the aggregator is unavailable '
        'When an institution is connected '
        "Then the API's reason is a server failure (UC-30 AF-05)", () async {
      final stub = ApiStub(
        (_) => refusal(503, ['The aggregator is unavailable.']),
      );

      final result = await HttpConnectionRepository.fromDio(stub.dio)
          .connect(dataSource: 'pluggy', externalReference: 'item-42');

      expect(
        result,
        const Failure<Connection>(
          message: 'The aggregator is unavailable.',
          kind: FailureKind.serverError,
        ),
      );
    });
  });

  group('HttpConnectionRepository.synchronize', () {
    test('Given a connection '
        'When it is synchronized '
        'Then the job the API started is returned', () async {
      final stub = ApiStub.data({
        'importJobId': 'j1',
        'status': 1,
        'periodStart': '2026-09-01',
        'periodEnd': '2026-10-01',
      });

      final result = await HttpConnectionRepository.fromDio(stub.dio)
          .synchronize('c1');

      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/connections/c1/sync');
      expect(stub.body, <String, Object?>{});
      expect(result, const Success<String?>('j1'));
    });

    test('Given an answer naming an empty job '
        'When a connection is synchronized '
        'Then no job is returned', () async {
      final stub = ApiStub.data({'importJobId': ''});

      final result = await HttpConnectionRepository.fromDio(stub.dio)
          .synchronize('c1');

      expect(result, const Success<String?>(null));
    });

    test('Given an answer with no data '
        'When a connection is synchronized '
        'Then it succeeds with no job to follow', () async {
      final stub = ApiStub.data(null);

      final result = await HttpConnectionRepository.fromDio(stub.dio)
          .synchronize('c1');

      expect(result, const Success<String?>(null));
    });

    test('Given the aggregator is unavailable '
        'When a connection is synchronized '
        "Then the API's reason is the failure (UC-31 AF-03)", () async {
      final stub = ApiStub(
        (_) => refusal(503, ['The aggregator is unavailable.']),
      );

      final result = await HttpConnectionRepository.fromDio(stub.dio)
          .synchronize('c1');

      expect(
        result,
        const Failure<String?>(
          message: 'The aggregator is unavailable.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When a connection is synchronized '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpConnectionRepository.fromDio(stub.dio)
          .synchronize('c1');

      expect((result as Failure<String?>).kind, FailureKind.unreachable);
    });
  });

  group('HttpConnectionRepository.reauthenticate', () {
    test('Given a connection needing reauthentication '
        'When it is reauthenticated '
        'Then the request goes to its own address', () async {
      final stub = ApiStub.data(null);

      final result = await HttpConnectionRepository.fromDio(stub.dio)
          .reauthenticate('c1');

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/connections/c1/reauthenticate');
      expect(stub.body, <String, Object?>{});
    });

    test('Given a revoked connection '
        'When it is reauthenticated '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub(
        (_) =>
            refusal(409, ['A revoked connection cannot be reauthenticated.']),
      );

      final result = await HttpConnectionRepository.fromDio(stub.dio)
          .reauthenticate('c1');

      expect(
        result,
        const Failure<void>(
          message: 'A revoked connection cannot be reauthenticated.',
          kind: FailureKind.conflict,
        ),
      );
    });
  });

  group('HttpConnectionRepository.revoke', () {
    test('Given a connection '
        'When it is revoked '
        'Then the request goes to its own address with no body', () async {
      final stub = ApiStub.data(null);

      final result = await HttpConnectionRepository.fromDio(stub.dio)
          .revoke('c1');

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/connections/c1/revoke');
      expect(stub.body, isNull);
    });

    test('Given a connection that is not there '
        'When it is revoked '
        "Then the API's reason is not found (UC-31 AF-05)", () async {
      final stub = ApiStub((_) => refusal(404, ['Connection not found.']));

      final result = await HttpConnectionRepository.fromDio(stub.dio)
          .revoke('c1');

      expect(
        result,
        const Failure<void>(
          message: 'Connection not found.',
          kind: FailureKind.notFound,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When a connection is revoked '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpConnectionRepository.fromDio(stub.dio)
          .revoke('c1');

      expect(
        result,
        const Failure<void>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });
}
