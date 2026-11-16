import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/ingestion/data/imported_record_repository.dart';

import '../../../support/api_stub.dart';

/// The paginated envelope the records endpoint answers with.
ApiStub recordsStub(
  Object? records, {
  Object? pageNumber = 1,
  Object? totalPages = 1,
}) => ApiStub(
  (_) => json(200, {
    ...envelope(records),
    'pageNumber': ?pageNumber,
    'pageSize': 50,
    'totalPages': ?totalPages,
    'totalItems': 1,
  }),
);

void main() {
  group('HttpImportedRecordRepository.forJob', () {
    test('Given a job '
        'When its records are read '
        'Then the first page of fifty is asked for by default', () async {
      final stub = recordsStub(const <Object?>[]);

      await HttpImportedRecordRepository.fromDio(stub.dio).forJob('j1');

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/import-jobs/j1/records');
      expect(stub.request.queryParameters, {'PageNumber': 1, 'PageSize': 50});
    });

    test('Given a page asked for '
        'When the records are read '
        'Then that page and size are sent', () async {
      final stub = recordsStub(const <Object?>[], pageNumber: 3);

      await HttpImportedRecordRepository.fromDio(stub.dio)
          .forJob('j1', pageNumber: 3, pageSize: 10);

      expect(stub.request.queryParameters, {'PageNumber': 3, 'PageSize': 10});
    });

    test('Given a record that produced a live transaction '
        'When it is read '
        'Then it is mapped exactly as the API stored it (UC-34)', () async {
      final stub = recordsStub([
        {
          'outcome': 1,
          'hasLiveTransaction': true,
          'externalId': 'row-7',
          'amount': '-12.50',
          'occurredOn': '2026-10-09T00:00:00.000',
          'rawPayload': '2026-10-09;Coffee;-12,50',
          'transactionId': 't1',
        },
      ], totalPages: 4);

      final page = (await HttpImportedRecordRepository.fromDio(
        stub.dio,
      ).forJob('j1')).valueOrNull!;

      expect(page.pageNumber, 1);
      expect(page.totalPages, 4);
      expect(page.isEmpty, isFalse);
      final record = page.items.single;
      expect(record.outcome, RecordOutcome.imported);
      expect(record.hasLiveTransaction, isTrue);
      expect(record.externalId, 'row-7');
      expect(record.amount, '-12.50');
      expect(record.occurredOn, DateTime(2026, 10, 9));
      expect(record.rawPayload, '2026-10-09;Coffee;-12,50');
      expect(record.rejectionReason, isNull);
      expect(record.transactionId, 't1');
      expect(record.canOpenTransaction, isTrue);
    });

    test('Given each outcome the API publishes '
        'When the records are read '
        'Then 1, 2 and 3 are imported, duplicate and rejected, '
        'and anything else is unknown (UC-34 AF-02)', () async {
      final stub = recordsStub([
        {'outcome': 1},
        {'outcome': 2},
        {'outcome': 3, 'rejectionReason': 'The amount is not a number.'},
        {'outcome': 8},
        <String, Object?>{},
      ]);

      final page = (await HttpImportedRecordRepository.fromDio(
        stub.dio,
      ).forJob('j1')).valueOrNull!;

      expect(page.items.map((r) => r.outcome), [
        RecordOutcome.imported,
        RecordOutcome.duplicate,
        RecordOutcome.rejected,
        RecordOutcome.unknown,
        RecordOutcome.unknown,
      ]);
      expect(page.items[2].rejectionReason, 'The amount is not a number.');
    });

    test('Given a record with every optional field missing '
        'When it is read '
        'Then it has no live transaction and the gaps stay absent', () async {
      final stub = recordsStub([<String, Object?>{}]);

      final record = (await HttpImportedRecordRepository.fromDio(
        stub.dio,
      ).forJob('j1')).valueOrNull!.items.single;

      expect(record.hasLiveTransaction, isFalse);
      expect(record.externalId, isNull);
      expect(record.amount, isNull);
      expect(record.occurredOn, isNull);
      expect(record.rawPayload, isNull);
      expect(record.transactionId, isNull);
      expect(record.canOpenTransaction, isFalse);
    });

    test('Given an answer with no paging figures '
        'When a page is read '
        'Then it is the page asked for, out of none', () async {
      final stub = recordsStub(
        const <Object?>[],
        pageNumber: null,
        totalPages: null,
      );

      final page = (await HttpImportedRecordRepository.fromDio(
        stub.dio,
      ).forJob('j1', pageNumber: 2)).valueOrNull!;

      expect(page.pageNumber, 2);
      expect(page.totalPages, 0);
    });

    test('Given an answer with no data '
        'When the records are read '
        'Then the page is empty (UC-34 AF-03)', () async {
      final stub = recordsStub(null);

      final page = (await HttpImportedRecordRepository.fromDio(
        stub.dio,
      ).forJob('j1')).valueOrNull!;

      expect(page.items, isEmpty);
      expect(page.isEmpty, isTrue);
    });

    test('Given a job that is not the user\'s '
        'When its records are read '
        "Then the API's not-found is the failure (UC-34 AF-04)", () async {
      final stub = ApiStub((_) => refusal(404, ['Import job not found.']));

      final result = await HttpImportedRecordRepository.fromDio(stub.dio)
          .forJob('j1');

      expect(
        result,
        const Failure<ImportedRecordPage>(
          message: 'Import job not found.',
          kind: FailureKind.notFound,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the records are read '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpImportedRecordRepository.fromDio(stub.dio)
          .forJob('j1');

      expect(
        result,
        const Failure<ImportedRecordPage>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });
}
