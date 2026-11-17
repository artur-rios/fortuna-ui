import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/format/money.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/transactions/data/transaction_repository.dart';

import '../../../support/api_stub.dart';

/// A full transaction as the API stores it.
Map<String, Object?> transactionOutput({
  String id = 't1',
  int? direction = 1,
  int? sourceType = 1,
  bool? isDeleted = false,
  bool? isReconciled = false,
  String? financialAccountName = 'Checking',
  String? creditCardName,
  int? importedRecordId,
  String? importedAmount,
}) => {
  'id': id,
  'occurredOn': '2026-03-05T00:00:00.000',
  'amount': '42.10',
  'currencyCode': 'BRL',
  'direction': ?direction,
  'categoryId': 'c1',
  'categoryName': 'Groceries',
  'financialAccountId': 'a1',
  'financialAccountName': ?financialAccountName,
  'creditCardName': ?creditCardName,
  'description': 'Weekly shop',
  'counterpartyName': 'Market',
  'isTransfer': false,
  'isReconciled': ?isReconciled,
  'isDeleted': ?isDeleted,
  'isManuallyCorrected': false,
  'sourceType': ?sourceType,
  'importedRecordId': ?importedRecordId,
  'importedAmount': ?importedAmount,
};

/// Answers the command at [method] with [commandAnswer] and the re-read with
/// [readAnswer], the way `update` and `reconcile` talk to the API.
ApiStub commandThenRead({
  required String method,
  ResponseBody Function()? commandAnswer,
  ResponseBody Function()? readAnswer,
}) => ApiStub(
  (request) => request.method == method
      ? (commandAnswer ?? () => json(200, envelope({'id': 't1'})))()
      : (readAnswer ?? () => json(200, envelope(transactionOutput())))(),
);

HttpTransactionRepository repositoryOn(ApiStub stub) =>
    HttpTransactionRepository.fromDio(stub.dio);

Future<Result<Transaction>> recordGroceries(
  ApiStub stub, {
  Direction direction = Direction.expense,
  List<String> tags = const [],
}) => repositoryOn(stub).record(
  occurredOn: DateTime(2026, 3, 5),
  amount: '42.10',
  direction: direction,
  categoryId: 'c1',
  currencyCode: 'BRL',
  financialAccountId: 'a1',
  description: 'Weekly shop',
  counterparty: 'Market',
  tags: tags,
);

Future<Result<Transaction>> updateGroceries(
  ApiStub stub, {
  List<String> tags = const [],
}) => repositoryOn(stub).update(
  id: 't1',
  occurredOn: DateTime(2026, 3, 6),
  amount: '45.00',
  direction: Direction.earning,
  categoryId: 'c2',
  currencyCode: 'BRL',
  creditCardId: 'cc1',
  description: 'Refund',
  counterparty: 'Market',
  tags: tags,
);

Future<Transaction> readOne(Map<String, Object?> output) async =>
    (await repositoryOn(ApiStub.data(output)).read('t1')).valueOrNull!;

void main() {
  group('HttpTransactionRepository.record', () {
    test(
      'Given a transaction on an account '
      'When it is recorded '
      'Then the amount travels as the exact string typed (FR-MM-02)',
      () async {
        final stub = ApiStub.data({'id': 't1'}, status: 201);

        await recordGroceries(stub, tags: ['food', 'weekly']);

        expect(stub.request.method, 'POST');
        expect(stub.request.path, '/api/transactions');
        expect(stub.body, {
          'amount': '42.10',
          'categoryId': 'c1',
          'counterparty': 'Market',
          'currencyCode': 'BRL',
          'description': 'Weekly shop',
          'direction': 1,
          'financialAccountId': 'a1',
          'occurredOn': '2026-03-05',
          'tags': ['food', 'weekly'],
        });
      },
    );

    test(
      'Given an earning on a card with no tags '
      'When it is recorded '
      'Then the earning is sent as such and empty tags are left out',
      () async {
        final stub = ApiStub.data({'id': 't1'}, status: 201);

        await repositoryOn(stub).record(
          occurredOn: DateTime(2026, 3, 5),
          amount: '10',
          direction: Direction.earning,
          categoryId: 'c1',
          currencyCode: 'BRL',
          creditCardId: 'cc1',
        );

        final body = stub.body! as Map<String, Object?>;
        expect(body['direction'], 2);
        expect(body['creditCardId'], 'cc1');
        expect(body['financialAccountId'], isNull);
        expect(body['description'], isNull);
        expect(body['counterparty'], isNull);
        expect(body['tags'], isNull);
      },
    );

    test('Given the API stored the transaction '
        'When it is recorded '
        'Then what comes back is what the API stored, not the form (UC-19 '
        'step 6)', () async {
      final stub = ApiStub.data({
        'id': 't1',
        'occurredOn': '2026-03-05T00:00:00.000',
        'amount': '42.1',
        'currencyCode': 'BRL',
        'direction': 2,
        'categoryId': 'c1',
        'categoryName': 'Groceries',
        'financialAccountId': 'a1',
        'creditCardId': 'cc1',
        'description': 'Weekly shop',
        'counterpartyName': 'Market',
      }, status: 201);

      final result = await recordGroceries(stub);

      final transaction = result.valueOrNull!;
      expect(transaction.id, 't1');
      expect(transaction.occurredOn, DateTime(2026, 3, 5));
      expect(transaction.amount, Money.parse('42.10', 'BRL'));
      expect(transaction.direction, Direction.earning);
      expect(transaction.categoryId, 'c1');
      expect(transaction.categoryName, 'Groceries');
      expect(transaction.financialAccountId, 'a1');
      expect(transaction.creditCardId, 'cc1');
      expect(transaction.description, 'Weekly shop');
      expect(transaction.counterpartyName, 'Market');
      expect(transaction.financialAccountName, isNull);
      expect(transaction.creditCardName, isNull);
      expect(transaction.isTransfer, isFalse);
      expect(transaction.isReconciled, isFalse);
      expect(transaction.isDeleted, isFalse);
      expect(transaction.source, TransactionSource.manual);
      expect(transaction.importedRecord, isNull);
      expect(transaction.tags, isEmpty);
    });

    test('Given the API stored the transaction with tags '
        'When it is recorded '
        'Then the tags that come back are their names', () async {
      final stub = ApiStub.data({
        'id': 't1',
        'tags': [
          {'id': 'g1', 'name': 'food'},
          {'id': 'g2', 'name': 'weekly'},
        ],
      }, status: 201);

      final transaction = (await recordGroceries(stub)).valueOrNull!;

      expect(transaction.tags, ['food', 'weekly']);
    });

    test('Given a confirmation with every optional field missing '
        'When a transaction is recorded '
        'Then the gaps read as empty rather than failing', () async {
      final stub = ApiStub.data(<String, Object?>{}, status: 201);

      final transaction = (await recordGroceries(stub)).valueOrNull!;

      expect(transaction.id, '');
      expect(transaction.occurredOn, DateTime(1970));
      expect(transaction.amount, Money.parse('0', ''));
      expect(transaction.direction, Direction.expense);
      expect(transaction.categoryId, '');
      expect(transaction.categoryName, isNull);
    });

    test('Given the API answers without the transaction '
        'When it is recorded '
        'Then it is not reported as recorded (UC-19 AF-06)', () async {
      final stub = ApiStub.data(null, status: 201);

      final result = await recordGroceries(stub);

      expect(
        result,
        const Failure<Transaction>(
          message: 'The instance did not confirm the transaction.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test('Given an account that is not the user\'s '
        'When a transaction is recorded on it '
        "Then it is not found, in the API's words (UC-19 AF-04)", () async {
      final stub = ApiStub((_) => refusal(404, ['Account not found.']));

      final result = await recordGroceries(stub);

      expect(
        result,
        const Failure<Transaction>(
          message: 'Account not found.',
          kind: FailureKind.notFound,
        ),
      );
    });

    test('Given a rule this client does not enforce '
        'When a transaction is recorded '
        "Then the API's reason is the failure (UC-19 AF-05)", () async {
      final stub = ApiStub(
        (_) => refusal(409, ['The statement for that date is closed.']),
      );

      final result = await recordGroceries(stub);

      expect(
        result,
        const Failure<Transaction>(
          message: 'The statement for that date is closed.',
          kind: FailureKind.conflict,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When a transaction is recorded '
        'Then it is a failure the form can retry (UC-19 AF-06)', () async {
      final stub = ApiStub.unreachable();

      final result = await recordGroceries(stub);

      expect(
        result,
        const Failure<Transaction>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpTransactionRepository.read', () {
    test(
      'Given a transaction '
      'When it is read '
      'Then it is fetched by its id, deleted ones included (UC-20 AF-05)',
      () async {
        final stub = ApiStub.data(transactionOutput());

        await repositoryOn(stub).read('t1');

        expect(stub.request.method, 'GET');
        expect(stub.request.path, '/api/transactions/t1');
        expect(stub.request.queryParameters, {'includeDeleted': true});
      },
    );

    test('Given a transaction the API stores '
        'When it is read '
        'Then every field is mapped as the API sent it', () async {
      final transaction = await readOne({
        ...transactionOutput(),
        'creditCardId': 'cc1',
        'creditCardName': 'Gold',
        'isTransfer': true,
        'isReconciled': true,
        'isManuallyCorrected': true,
      });

      expect(transaction.id, 't1');
      expect(transaction.occurredOn, DateTime(2026, 3, 5));
      expect(transaction.amount, Money.parse('42.10', 'BRL'));
      expect(transaction.direction, Direction.expense);
      expect(transaction.categoryId, 'c1');
      expect(transaction.categoryName, 'Groceries');
      expect(transaction.financialAccountId, 'a1');
      expect(transaction.financialAccountName, 'Checking');
      expect(transaction.creditCardId, 'cc1');
      expect(transaction.creditCardName, 'Gold');
      expect(transaction.holdingName, 'Checking');
      expect(transaction.description, 'Weekly shop');
      expect(transaction.counterpartyName, 'Market');
      expect(transaction.isTransfer, isTrue);
      expect(transaction.isReconciled, isTrue);
      expect(transaction.isDeleted, isFalse);
      expect(transaction.isEditable, isTrue);
      expect(transaction.isManuallyCorrected, isTrue);
      expect(transaction.source, TransactionSource.manual);
      expect(transaction.source.isImported, isFalse);
      expect(transaction.importedRecord, isNull);
    });

    test('Given a transaction on a card '
        'When it is read '
        'Then the card is what it is held on', () async {
      final transaction = await readOne(
        transactionOutput(financialAccountName: null, creditCardName: 'Gold'),
      );

      expect(transaction.holdingName, 'Gold');
    });

    test(
      'Given a transaction the API stores with tags '
      'When it is read '
      'Then the tags are their names, so an edit keeps them (UC-20 step 1)',
      () async {
        final transaction = await readOne({
          ...transactionOutput(),
          'tags': [
            {'id': 'g1', 'name': 'food'},
            {'id': 'g2', 'name': 'weekly'},
            {'id': 'g3', 'name': null},
          ],
        });

        expect(transaction.tags, ['food', 'weekly']);
      },
    );

    test('Given each direction the API reports '
        'When a transaction is read '
        'Then an earning is an earning and anything else an expense', () async {
      final expected = {
        1: Direction.expense,
        2: Direction.earning,
        99: Direction.expense,
        null: Direction.expense,
      };

      for (final MapEntry(key: wire, value: direction) in expected.entries) {
        final transaction = await readOne(transactionOutput(direction: wire));

        expect(transaction.direction, direction, reason: 'direction $wire');
      }
    });

    test('Given each source the API reports '
        'When a transaction is read '
        'Then each maps to its origin, and anything else to manual '
        '(FR-MM-13)', () async {
      final expected = {
        1: TransactionSource.manual,
        2: TransactionSource.connection,
        3: TransactionSource.spreadsheet,
        4: TransactionSource.statementFile,
        99: TransactionSource.manual,
        null: TransactionSource.manual,
      };

      for (final MapEntry(key: wire, value: source) in expected.entries) {
        final transaction = await readOne(transactionOutput(sourceType: wire));

        expect(transaction.source, source, reason: 'source $wire');
        expect(
          transaction.source.isImported,
          source != TransactionSource.manual,
          reason: 'source $wire',
        );
      }
    });

    test(
      'Given a transaction derived from an imported record '
      'When it is read '
      'Then the record is kept beside it in the same currency (UC-20 AF-04)',
      () async {
        final transaction = await readOne({
          ...transactionOutput(
            sourceType: 3,
            importedRecordId: 7,
            importedAmount: '40.00',
          ),
          'importJobId': 'j1',
          'importedOccurredOn': '2026-03-04T00:00:00.000',
        });

        final record = transaction.importedRecord!;
        expect(record.recordId, 7);
        expect(record.importJobId, 'j1');
        expect(record.amount, Money.parse('40', 'BRL'));
        expect(record.occurredOn, DateTime(2026, 3, 4));
      },
    );

    test('Given an imported record the API sent no amount for '
        'When the transaction is read '
        'Then the record has no amount rather than zero', () async {
      final transaction = await readOne(
        transactionOutput(sourceType: 2, importedRecordId: 7),
      );

      expect(transaction.importedRecord!.recordId, 7);
      expect(transaction.importedRecord!.amount, isNull);
      expect(transaction.importedRecord!.importJobId, isNull);
      expect(transaction.importedRecord!.occurredOn, isNull);
    });

    test('Given an imported amount with no record behind it '
        'When the transaction is read '
        'Then there is no imported record', () async {
      final transaction = await readOne(
        transactionOutput(importedAmount: '40.00'),
      );

      expect(transaction.importedRecord, isNull);
    });

    test(
      'Given a deleted transaction '
      'When it is read '
      'Then it is offered for restoring, not editing (UC-20 AF-05)',
      () async {
        final transaction = await readOne(transactionOutput(isDeleted: true));

        expect(transaction.isDeleted, isTrue);
        expect(transaction.isEditable, isFalse);
      },
    );

    test('Given a transaction with every optional field missing '
        'When it is read '
        'Then the gaps read as empty rather than failing', () async {
      final transaction = await readOne(<String, Object?>{});

      expect(transaction.id, '');
      expect(transaction.occurredOn, DateTime(1970));
      expect(transaction.amount, Money.parse('0', ''));
      expect(transaction.direction, Direction.expense);
      expect(transaction.categoryId, '');
      expect(transaction.categoryName, isNull);
      expect(transaction.financialAccountId, isNull);
      expect(transaction.holdingName, isNull);
      expect(transaction.isTransfer, isFalse);
      expect(transaction.isReconciled, isFalse);
      expect(transaction.isDeleted, isFalse);
      expect(transaction.isManuallyCorrected, isFalse);
      expect(transaction.source, TransactionSource.manual);
      expect(transaction.importedRecord, isNull);
      expect(transaction.tags, isEmpty);
    });

    test('Given an answer with no data '
        'When a transaction is read '
        'Then it is not found (UC-20 AF-02)', () async {
      final stub = ApiStub.data(null);

      final result = await repositoryOn(stub).read('t1');

      expect(
        result,
        const Failure<Transaction>(
          message: 'That transaction was not found.',
          kind: FailureKind.notFound,
        ),
      );
    });

    test('Given the API answers 404 '
        'When a transaction is read '
        "Then the API's reason is the failure (UC-20 AF-02)", () async {
      final stub = ApiStub((_) => refusal(404, ['Transaction not found.']));

      final result = await repositoryOn(stub).read('t1');

      expect(
        result,
        const Failure<Transaction>(
          message: 'Transaction not found.',
          kind: FailureKind.notFound,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When a transaction is read '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await repositoryOn(stub).read('t1');

      expect((result as Failure).kind, FailureKind.unreachable);
    });
  });

  group('HttpTransactionRepository.update', () {
    test('Given an edited transaction '
        'When it is saved '
        'Then every field is put to its address and the stored record re-read '
        '(UC-20 step 3)', () async {
      final stub = commandThenRead(
        method: 'PUT',
        readAnswer: () =>
            json(200, envelope({...transactionOutput(), 'amount': '45.00'})),
      );

      final result = await updateGroceries(stub, tags: ['refund']);

      expect(stub.requests, hasLength(2));
      final put = stub.requests.first;
      expect(put.method, 'PUT');
      expect(put.path, '/api/transactions/t1');
      expect(put.data, {
        'amount': '45.00',
        'categoryId': 'c2',
        'counterparty': 'Market',
        'creditCardId': 'cc1',
        'currencyCode': 'BRL',
        'description': 'Refund',
        'direction': 2,
        'financialAccountId': null,
        'occurredOn': '2026-03-06',
        'ownerId': null,
        'tags': ['refund'],
      });
      final reRead = stub.requests.last;
      expect(reRead.method, 'GET');
      expect(reRead.path, '/api/transactions/t1');
      expect(reRead.queryParameters, {'includeDeleted': true});
      expect(result.valueOrNull!.amount, Money.parse('45', 'BRL'));
    });

    test('Given an edit that leaves no tags '
        'When it is saved '
        'Then the tags travel as null, which clears them', () async {
      final stub = commandThenRead(method: 'PUT');

      await updateGroceries(stub);

      expect(stub.requests.first.data, containsPair('tags', null));
    });

    test('Given a transaction moved to an account and cleared of its '
        'description and counterparty '
        'When it is saved '
        'Then each cleared field travels as null, not left out: the offline '
        'core keeps a field an update leaves out', () async {
      final stub = commandThenRead(method: 'PUT');

      await repositoryOn(stub).update(
        id: 't1',
        occurredOn: DateTime(2026, 3, 6),
        amount: '45.00',
        direction: Direction.expense,
        categoryId: 'c2',
        currencyCode: 'BRL',
        financialAccountId: 'a1',
      );

      final body = stub.requests.first.data! as Map<String, Object?>;
      expect(body, containsPair('financialAccountId', 'a1'));
      for (final cleared in [
        'creditCardId',
        'description',
        'counterparty',
        'tags',
      ]) {
        expect(body, containsPair(cleared, null), reason: cleared);
      }
    });

    test('Given a transaction on a settled statement '
        'When the edit is saved '
        "Then the API's reason is the failure and nothing is re-read "
        '(UC-20 AF-03)', () async {
      final stub = commandThenRead(
        method: 'PUT',
        commandAnswer: () =>
            refusal(409, ['The statement is already settled.']),
      );

      final result = await updateGroceries(stub);

      expect(
        result,
        const Failure<Transaction>(
          message: 'The statement is already settled.',
          kind: FailureKind.conflict,
        ),
      );
      expect(stub.requests, hasLength(1));
    });

    test('Given an edit the API took but a record it then cannot find '
        'When the edit is saved '
        'Then it is not found rather than reported saved', () async {
      final stub = commandThenRead(
        method: 'PUT',
        readAnswer: () => json(200, envelope(null)),
      );

      final result = await updateGroceries(stub);

      expect(
        result,
        const Failure<Transaction>(
          message: 'That transaction was not found.',
          kind: FailureKind.notFound,
        ),
      );
    });

    test('Given an edit the API took but a re-read it refuses '
        'When the edit is saved '
        "Then the re-read's reason is the failure", () async {
      final stub = commandThenRead(
        method: 'PUT',
        readAnswer: () => refusal(503, ['The instance is restarting.']),
      );

      final result = await updateGroceries(stub);

      expect(
        result,
        const Failure<Transaction>(
          message: 'The instance is restarting.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When an edit is saved '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await updateGroceries(stub);

      expect(
        result,
        const Failure<Transaction>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
      expect(stub.requests, hasLength(1));
    });
  });

  group('HttpTransactionRepository.delete', () {
    test('Given a transaction '
        'When it is deleted '
        'Then the delete goes to its own address (UC-40)', () async {
      final stub = ApiStub.data({'id': 't1'});

      final result = await repositoryOn(stub).delete('t1');

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'DELETE');
      expect(stub.request.path, '/api/transactions/t1');
    });

    test('Given the API refuses the delete '
        'When a transaction is deleted '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub(
        (_) => refusal(409, ['A reconciled transaction cannot be deleted.']),
      );

      final result = await repositoryOn(stub).delete('t1');

      expect(
        result,
        const Failure<void>(
          message: 'A reconciled transaction cannot be deleted.',
          kind: FailureKind.conflict,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When a transaction is deleted '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await repositoryOn(stub).delete('t1');

      expect(
        result,
        const Failure<void>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpTransactionRepository.search', () {
    test('Given every filter and a sort '
        'When transactions are searched '
        'Then each is a question for the API (FR-TB-02)', () async {
      final stub = ApiStub.data(<String, Object?>{});

      await repositoryOn(stub).search(
        from: DateTime(2026),
        to: DateTime(2026, 3, 31),
        financialAccountId: 'a1',
        creditCardId: 'cc1',
        categoryId: 'c1',
        tagId: 'g1',
        counterpartyId: 'p1',
        direction: Direction.earning,
        minimumAmount: '10.00',
        maximumAmount: '99.99',
        text: 'market',
        sortBy: 'amount',
        descending: false,
        pageNumber: 3,
        pageSize: 10,
      );

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/transactions');
      final query = stub.request.queryParameters;
      expect(query['From'], '2026-01-01');
      expect(query['To'], '2026-03-31');
      expect(query['FinancialAccountId'], 'a1');
      expect(query['CreditCardId'], 'cc1');
      expect(query['CategoryId'], 'c1');
      expect(query['TagId'], 'g1');
      expect(query['CounterpartyId'], 'p1');
      expect('${query['Direction']}', '2');
      expect(query['MinimumAmount'], '10.00');
      expect(query['MaximumAmount'], '99.99');
      expect(query['Text'], 'market');
      expect(query['SortBy'], 'amount');
      expect(query['Descending'], isFalse);
      expect(query['PageNumber'], 3);
      expect(query['PageSize'], 10);
      expect(query, hasLength(15));
    });

    test(
      'Given no filter '
      'When transactions are searched '
      'Then the first page of twenty-five is asked for, newest first',
      () async {
        final stub = ApiStub.data(<String, Object?>{});

        await repositoryOn(stub).search();

        expect(stub.request.queryParameters, {
          'Descending': true,
          'PageNumber': 1,
          'PageSize': 25,
        });
      },
    );

    test('Given a page beyond the last '
        'When transactions are searched '
        "Then the API's own page is what comes back (UC-25 AF-05)", () async {
      final stub = ApiStub.data({
        'items': [transactionOutput(), transactionOutput(id: 't2')],
        'pageNumber': 4,
        'pageSize': 2,
        'totalItems': 8,
        'totalPages': 4,
      });

      final result = await repositoryOn(stub)
          .search(pageNumber: 9, pageSize: 2);

      final page = result.valueOrNull!;
      expect(page.items.map((t) => t.id), ['t1', 't2']);
      expect(page.items.first.amount, Money.parse('42.10', 'BRL'));
      expect(page.pageNumber, 4);
      expect(page.pageSize, 2);
      expect(page.totalItems, 8);
      expect(page.totalPages, 4);
      expect(page.isEmpty, isFalse);
      expect(page.hasPrevious, isTrue);
      expect(page.hasNext, isFalse);
    });

    test('Given a page in the middle '
        'When transactions are searched '
        'Then there are pages both before and after it', () async {
      final stub = ApiStub.data({
        'items': [transactionOutput()],
        'pageNumber': 2,
        'totalPages': 3,
      });

      final page = (await repositoryOn(stub).search()).valueOrNull!;

      expect(page.hasPrevious, isTrue);
      expect(page.hasNext, isTrue);
    });

    test('Given a page with every optional field missing '
        'When transactions are searched '
        'Then the request stands and nothing matched (UC-25 AF-02)', () async {
      final stub = ApiStub.data(<String, Object?>{});

      final page = (await repositoryOn(
        stub,
      ).search(pageNumber: 2, pageSize: 10)).valueOrNull!;

      expect(page.items, isEmpty);
      expect(page.isEmpty, isTrue);
      expect(page.pageNumber, 2);
      expect(page.pageSize, 10);
      expect(page.totalItems, 0);
      expect(page.totalPages, 0);
      expect(page.hasNext, isFalse);
    });

    test('Given the first page '
        'When transactions are searched '
        'Then there is no page before it', () async {
      final stub = ApiStub.data({'pageNumber': 1, 'totalPages': 2});

      final page = (await repositoryOn(stub).search()).valueOrNull!;

      expect(page.hasPrevious, isFalse);
      expect(page.hasNext, isTrue);
    });

    test('Given an answer with no data '
        'When transactions are searched '
        'Then it is a failure of the instance', () async {
      final stub = ApiStub.data(null);

      final result = await repositoryOn(stub).search();

      expect(
        result,
        const Failure<TransactionPage>(
          message: 'The instance returned no page.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test('Given the API refuses the filters '
        'When transactions are searched '
        "Then the API's reason is the failure (UC-25 AF-03)", () async {
      final stub = ApiStub(
        (_) => refusal(400, ['The minimum exceeds the maximum.']),
      );

      final result = await repositoryOn(stub)
          .search(minimumAmount: '100', maximumAmount: '1');

      expect(
        result,
        const Failure<TransactionPage>(
          message: 'The minimum exceeds the maximum.',
          kind: FailureKind.invalidInput,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When transactions are searched '
        'Then it is a failure saying so (UC-25 AF-03)', () async {
      final stub = ApiStub.unreachable();

      final result = await repositoryOn(stub).search();

      expect((result as Failure).kind, FailureKind.unreachable);
    });
  });

  group('HttpTransactionRepository.reconcile', () {
    test(
      'Given an imported record the API proposed '
      'When the transaction is reconciled against it '
      'Then the record is posted and the stored transaction re-read',
      () async {
        final stub = commandThenRead(
          method: 'POST',
          readAnswer: () => json(
            200,
            envelope(
              transactionOutput(
                isReconciled: true,
                sourceType: 2,
                importedRecordId: 7,
              ),
            ),
          ),
        );

        final result = await repositoryOn(stub)
            .reconcile(id: 't1', importedRecordId: 7, importJobId: 'j1');

        expect(stub.requests, hasLength(2));
        final post = stub.requests.first;
        expect(post.method, 'POST');
        expect(post.path, '/api/transactions/t1/reconcile');
        expect(post.data, {
          'importJobId': 'j1',
          'importedRecordId': 7,
          'unreconcile': false,
        });
        expect(stub.requests.last.path, '/api/transactions/t1');
        final transaction = result.valueOrNull!;
        expect(transaction.isReconciled, isTrue);
        expect(
          transaction.reconciliationKind,
          ReconciliationKind.matchedToRecord,
        );
      },
    );

    test('Given no imported record '
        'When the user vouches for the transaction '
        'Then only the reconciling itself is sent (UC-24 AF-02)', () async {
      final stub = commandThenRead(
        method: 'POST',
        readAnswer: () =>
            json(200, envelope(transactionOutput(isReconciled: true))),
      );

      final result = await repositoryOn(stub).reconcile(id: 't1');

      expect(stub.requests.first.data, {'unreconcile': false});
      expect(
        result.valueOrNull!.reconciliationKind,
        ReconciliationKind.selfConfirmed,
      );
    });

    test('Given the API refuses the reconciliation '
        'When the transaction is reconciled '
        "Then the API's reason is the failure and nothing is re-read "
        '(UC-24 AF-03)', () async {
      final stub = commandThenRead(
        method: 'POST',
        commandAnswer: () =>
            refusal(409, ['The transaction is already reconciled.']),
      );

      final result = await repositoryOn(stub).reconcile(id: 't1');

      expect(
        result,
        const Failure<Transaction>(
          message: 'The transaction is already reconciled.',
          kind: FailureKind.conflict,
        ),
      );
      expect(stub.requests, hasLength(1));
    });

    test('Given a reconciliation the API took but a record it then cannot find '
        'When the transaction is reconciled '
        'Then it is not found', () async {
      final stub = commandThenRead(
        method: 'POST',
        readAnswer: () => json(200, envelope(null)),
      );

      final result = await repositoryOn(stub).reconcile(id: 't1');

      expect(
        result,
        const Failure<Transaction>(
          message: 'That transaction was not found.',
          kind: FailureKind.notFound,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the transaction is reconciled '
        'Then it is a failure saying so (UC-24 AF-04)', () async {
      final stub = ApiStub.unreachable();

      final result = await repositoryOn(stub).reconcile(id: 't1');

      expect(
        result,
        const Failure<Transaction>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });
}
