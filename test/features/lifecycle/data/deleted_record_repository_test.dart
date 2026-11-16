import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/format/money.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/lifecycle/data/deleted_record_repository.dart';

import '../../../support/api_stub.dart';

/// A stub answering each of the three roots the list reads with its own data,
/// in the envelope; a root left out answers with no data.
ApiStub rootsStub({
  Object? transactions,
  Object? accounts,
  Object? categories,
}) => ApiStub(
  (request) => json(
    200,
    envelope(switch (request.path) {
      '/api/transactions' => transactions,
      '/api/accounts' => accounts,
      '/api/categories' => categories,
      _ => throw StateError('Unexpected request to ${request.path}.'),
    }),
  ),
);

const transactionRecord = DeletedRecord(
  id: 't1',
  kind: RecordKind.transaction,
  label: 'Lunch',
);

const accountRecord = DeletedRecord(
  id: 'a1',
  kind: RecordKind.account,
  label: 'Savings',
);

const categoryRecord = DeletedRecord(
  id: 'k1',
  kind: RecordKind.category,
  label: 'Food',
);

void main() {
  group('HttpDeletedRecordRepository.list', () {
    test('Given more transactions and accounts than one page holds '
        'When the deleted records are listed '
        'Then every page of each is read, and the deleted ones on any page '
        'are listed (UC-40 step 1)', () async {
      final stub = ApiStub((request) {
        final page = requestedPage(request);
        return switch (request.path) {
          '/api/transactions' => json(
            200,
            envelope({
              'items': [
                {'id': 'live-t$page', 'isDeleted': false},
                {'id': 't$page', 'description': 'Lunch', 'isDeleted': true},
              ],
              'pageNumber': page,
              'totalPages': 2,
            }),
          ),
          '/api/accounts' => paginated(
            [
              {'id': 'a$page', 'name': 'Savings', 'isDeleted': true},
            ],
            pageNumber: page,
            totalPages: 2,
          ),
          _ => json(200, envelope(null)),
        };
      });

      final result = await HttpDeletedRecordRepository.fromDio(stub.dio).list();

      expect(
        [
          for (final request in stub.requests)
            if (request.path != '/api/categories')
              (request.path, request.queryParameters['PageNumber']),
        ],
        [
          ('/api/transactions', 1),
          ('/api/transactions', 2),
          ('/api/accounts', 1),
          ('/api/accounts', 2),
        ],
      );
      expect(
        [for (final record in result.valueOrNull!) record.id],
        ['t1', 't2', 'a1', 'a2'],
      );
    });

    test('Given the three roots deleted records live under '
        'When the deleted records are listed '
        'Then each root is asked for its deleted ones, in order '
        '(UC-40 step 1)', () async {
      final stub = rootsStub();

      final result = await HttpDeletedRecordRepository.fromDio(stub.dio).list();

      expect(result.valueOrNull, isEmpty);
      expect(stub.requests.map((request) => request.method), [
        'GET',
        'GET',
        'GET',
      ]);
      expect(stub.requests.map((request) => request.path), [
        '/api/transactions',
        '/api/accounts',
        '/api/categories',
      ]);
      expect(stub.requests[0].queryParameters, {
        'IncludeDeleted': true,
        'PageNumber': 1,
        'PageSize': 100,
      });
      expect(stub.requests[1].queryParameters, {
        'IncludeDeleted': true,
        'PageNumber': 1,
        'PageSize': 100,
      });
      expect(stub.requests[2].queryParameters, {
        'includeDeleted': true,
        'includeUsageCounts': true,
      });
    });

    test(
      'Given live and deleted transactions '
      'When the deleted records are listed '
      'Then only the deleted ones are kept, with their amount and day',
      () async {
        final stub = rootsStub(
          transactions: {
            'items': [
              {
                'id': 't1',
                'description': 'Lunch',
                'categoryName': 'Food',
                'amount': '42.50',
                'currencyCode': 'BRL',
                'occurredOn': '2026-03-05T00:00:00.000',
                'isDeleted': true,
              },
              {'id': 't2', 'description': 'Live', 'isDeleted': false},
              {'id': 't3', 'description': 'Unknown state'},
            ],
          },
        );

        final records = (await HttpDeletedRecordRepository.fromDio(
          stub.dio,
        ).list()).valueOrNull!;

        final record = records.single;
        expect(record.id, 't1');
        expect(record.kind, RecordKind.transaction);
        expect(record.label, 'Lunch');
        expect(record.detail, isNull);
        expect(record.amount, Money.parse('42.50', 'BRL'));
        expect(record.occurredOn, DateTime(2026, 3, 5));
        expect(record.stillUsedBy, isNull);
      },
    );

    test('Given deleted transactions without a description '
        'When the deleted records are listed '
        'Then each is labelled by its category, or as a transaction', () async {
      final stub = rootsStub(
        transactions: {
          'items': [
            {'description': '', 'categoryName': 'Food', 'isDeleted': true},
            {'categoryName': 'Rent', 'isDeleted': true},
            {'description': '', 'isDeleted': true},
          ],
        },
      );

      final records = (await HttpDeletedRecordRepository.fromDio(
        stub.dio,
      ).list()).valueOrNull!;

      expect(records.map((record) => record.label), [
        'Food',
        'Rent',
        'Transaction',
      ]);
      expect(records.map((record) => record.id), ['', '', '']);
    });

    test('Given deleted transactions missing half of their amount '
        'When the deleted records are listed '
        'Then they carry no amount, since a number without its currency '
        'is not money', () async {
      final stub = rootsStub(
        transactions: {
          'items': [
            {'amount': '42.50', 'isDeleted': true},
            {'currencyCode': 'BRL', 'isDeleted': true},
          ],
        },
      );

      final records = (await HttpDeletedRecordRepository.fromDio(
        stub.dio,
      ).list()).valueOrNull!;

      expect(records.map((record) => record.amount), [null, null]);
      expect(records.map((record) => record.occurredOn), [null, null]);
    });

    test(
      'Given live and deleted accounts '
      'When the deleted records are listed '
      'Then only the deleted ones are kept, with their currency as detail',
      () async {
        final stub = rootsStub(
          accounts: [
            {
              'id': 'a1',
              'name': 'Savings',
              'currencyCode': 'BRL',
              'isDeleted': true,
            },
            {'id': 'a2', 'name': 'Live', 'isDeleted': false},
            {'id': 'a3', 'name': 'Unknown state'},
            {'isDeleted': true},
          ],
        );

        final records = (await HttpDeletedRecordRepository.fromDio(
          stub.dio,
        ).list()).valueOrNull!;

        expect(records.map((record) => record.kind), [
          RecordKind.account,
          RecordKind.account,
        ]);
        expect(records.map((record) => record.id), ['a1', '']);
        expect(records.map((record) => record.label), ['Savings', 'Account']);
        expect(records.map((record) => record.detail), ['BRL', null]);
        expect(records.map((record) => record.amount), [null, null]);
        expect(records.map((record) => record.stillUsedBy), [null, null]);
      },
    );

    test('Given deleted categories at every depth of the tree '
        'When the deleted records are listed '
        'Then the whole tree is walked and each carries what still uses it '
        '(UC-40 AF-06)', () async {
      final stub = rootsStub(
        categories: {
          'categories': [
            {
              'id': 'k1',
              'name': 'Food',
              'isDeleted': false,
              'children': [
                {
                  'id': 'k2',
                  'name': 'Restaurants',
                  'isDeleted': true,
                  'usageCount': 3,
                  'children': [
                    {'id': 'k3', 'isDeleted': true, 'usageCount': 0},
                  ],
                },
              ],
            },
            {'id': 'k4', 'name': 'Rent', 'isDeleted': true},
            {'id': 'k5', 'name': 'Unknown state'},
            {'isDeleted': true},
          ],
        },
      );

      final records = (await HttpDeletedRecordRepository.fromDio(
        stub.dio,
      ).list()).valueOrNull!;

      expect(records.map((record) => record.kind).toSet(), {
        RecordKind.category,
      });
      expect(records.map((record) => record.id), ['k2', 'k3', 'k4', '']);
      expect(records.map((record) => record.label), [
        'Restaurants',
        'Category',
        'Rent',
        'Category',
      ]);
      expect(records.map((record) => record.stillUsedBy), [3, 0, null, null]);
      expect(records.map((record) => record.isStillReferenced), [
        true,
        false,
        false,
        false,
      ]);
    });

    test(
      'Given deleted records under all three roots '
      'When the deleted records are listed '
      'Then transactions come first, then accounts, then categories',
      () async {
        final stub = rootsStub(
          transactions: {
            'items': [
              {'id': 't1', 'description': 'Lunch', 'isDeleted': true},
            ],
          },
          accounts: [
            {'id': 'a1', 'name': 'Savings', 'isDeleted': true},
          ],
          categories: {
            'categories': [
              {'id': 'k1', 'name': 'Food', 'isDeleted': true},
            ],
          },
        );

        final records = (await HttpDeletedRecordRepository.fromDio(
          stub.dio,
        ).list()).valueOrNull!;

        expect(records.map((record) => record.id), ['t1', 'a1', 'k1']);
      },
    );

    test('Given roots that answer with empty lists '
        'When the deleted records are listed '
        'Then nothing is deleted (UC-40 AF-04)', () async {
      final stub = rootsStub(
        transactions: <String, Object?>{},
        accounts: <Object?>[],
        categories: <String, Object?>{},
      );

      final result = await HttpDeletedRecordRepository.fromDio(stub.dio).list();

      expect(result.valueOrNull, isEmpty);
    });

    test('Given one root that the API refuses '
        'When the deleted records are listed '
        "Then the whole list fails with the API's reason", () async {
      final stub = ApiStub(
        (request) => request.path == '/api/categories'
            ? refusal(500, ['The categories could not be read.'])
            : json(200, envelope(null)),
      );

      final result = await HttpDeletedRecordRepository.fromDio(stub.dio).list();

      expect(
        result,
        const Failure<List<DeletedRecord>>(
          message: 'The categories could not be read.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the deleted records are listed '
        'Then it is a failure saying so, after the first request', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpDeletedRecordRepository.fromDio(stub.dio).list();

      expect(
        result,
        const Failure<List<DeletedRecord>>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
      expect(stub.request.path, '/api/transactions');
    });
  });

  group('HttpDeletedRecordRepository.restore', () {
    test(
      'Given a deleted record of each kind '
      'When each is restored '
      "Then the restore is posted to that kind's own route (UC-40 step 2)",
      () async {
        final stub = ApiStub.data({'id': 'x'});
        final repository = HttpDeletedRecordRepository.fromDio(stub.dio);

        final results = [
          for (final record in [
            transactionRecord,
            accountRecord,
            categoryRecord,
          ])
            await repository.restore(record),
        ];

        expect(results, everyElement(const Success<void>(null)));
        expect(stub.requests.map((request) => request.method), [
          'POST',
          'POST',
          'POST',
        ]);
        expect(stub.requests.map((request) => request.path), [
          '/api/transactions/t1/restore',
          '/api/accounts/a1/restore',
          '/api/categories/k1/restore',
        ]);
      },
    );

    test('Given the API refuses the restoration '
        'When a record is restored '
        "Then the API's reason is the failure (UC-40 AF-02)", () async {
      final stub = ApiStub(
        (_) => refusal(409, ['Its account is deleted; restore that first.']),
      );

      final result = await HttpDeletedRecordRepository.fromDio(stub.dio)
          .restore(transactionRecord);

      expect(
        result,
        const Failure<void>(
          message: 'Its account is deleted; restore that first.',
          kind: FailureKind.conflict,
        ),
      );
    });

    test('Given a record that no longer exists '
        'When it is restored '
        "Then the API's not-found is the failure (UC-40 AF-03)", () async {
      final stub = ApiStub((_) => refusal(404, ['Category not found.']));

      final result = await HttpDeletedRecordRepository.fromDio(stub.dio)
          .restore(categoryRecord);

      expect(
        result,
        const Failure<void>(
          message: 'Category not found.',
          kind: FailureKind.notFound,
        ),
      );
    });
  });

  group('HttpDeletedRecordRepository.purge', () {
    test(
      'Given a deleted record of each kind '
      'When each is permanently removed '
      "Then the hard delete goes to that kind's own route (UC-40 step 3)",
      () async {
        final stub = ApiStub.data({'id': 'x'});
        final repository = HttpDeletedRecordRepository.fromDio(stub.dio);

        final results = [
          for (final record in [
            transactionRecord,
            accountRecord,
            categoryRecord,
          ])
            await repository.purge(record),
        ];

        expect(results, everyElement(const Success<void>(null)));
        expect(stub.requests.map((request) => request.method), [
          'DELETE',
          'DELETE',
          'DELETE',
        ]);
        expect(stub.requests.map((request) => request.path), [
          '/api/transactions/t1/hard',
          '/api/accounts/a1/hard',
          '/api/categories/k1/hard',
        ]);
      },
    );

    test(
      'Given live records still referencing the target '
      'When it is permanently removed '
      "Then the API's reason naming them is the failure (UC-40 AF-01)",
      () async {
        final stub = ApiStub(
          (_) => refusal(409, ['3 transactions still use this account.']),
        );

        final result = await HttpDeletedRecordRepository.fromDio(stub.dio)
            .purge(accountRecord);

        expect(
          result,
          const Failure<void>(
            message: '3 transactions still use this account.',
            kind: FailureKind.conflict,
          ),
        );
      },
    );

    test('Given an instance that cannot be reached '
        'When a record is permanently removed '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpDeletedRecordRepository.fromDio(stub.dio)
          .purge(categoryRecord);

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
