/// Transactions (UC-19).
///
/// The most frequent action in the application, and the one the money rules
/// bear on hardest. Two things hold everywhere below:
///
/// - **The amount is a string from the form to the API.** It is parsed to an
///   exact [Decimal] to be validated and displayed, and serialized back to a
///   string to be sent. No `double` appears on any part of that path
///   (`FR-MM-02`, `IR-14`).
/// - **A transaction is recorded only when the API says so.** [record] returns
///   what the API stored, not what was submitted, so step 6 can show the user
///   the thing that actually exists rather than an optimistic copy of their
///   form (`AF-06`).
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart'
    hide TransactionDirection, TransactionSourceType;
import 'package:fortuna_api_client/export.dart'
    as api
    show TransactionDirection, TransactionSourceType;
import 'package:meta/meta.dart';

import '../../../core/format/money.dart';
import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// Which way the money went.
///
/// Mapped from the contract's numbers rather than the generated names, for the
/// reason `AccountType` gives: swagger_parser does not read `x-enum-varnames`,
/// so the generated enum is positional.
enum Direction {
  expense(1, 'Expense'),
  earning(2, 'Earning');

  const Direction(this.wire, this.label);

  final int wire;
  final String label;

  static Direction from(api.TransactionDirection? direction) =>
      switch (direction?.json) {
        2 => Direction.earning,
        _ => Direction.expense,
      };

  api.TransactionDirection get asApi => api.TransactionDirection.fromJson(wire);
}

/// Where a transaction came from (`FR-MM-13`).
///
/// Mapped from the contract's numbers for the reason [Direction] gives.
enum TransactionSource {
  manual(1, 'Entered by hand'),
  connection(2, 'From a connected institution'),
  spreadsheet(3, 'Imported from a spreadsheet'),
  statementFile(4, 'Imported from a statement file');

  const TransactionSource(this.wire, this.label);

  final int wire;
  final String label;

  static TransactionSource from(api.TransactionSourceType? source) =>
      switch (source?.json) {
        2 => TransactionSource.connection,
        3 => TransactionSource.spreadsheet,
        4 => TransactionSource.statementFile,
        _ => TransactionSource.manual,
      };

  /// Whether this transaction derives from an imported record, which is what
  /// decides whether there is evidence to show beneath it.
  bool get isImported => this != TransactionSource.manual;
}

/// The raw record an imported transaction derives from (`FR-MM-13`, `AF-04`).
///
/// Deliberately a separate type from [Transaction], and deliberately carrying
/// no way to change itself. It is the evidence the import is reconciled
/// against: if it could be edited, it would stop being evidence of anything.
@immutable
class ImportedRecord {
  const ImportedRecord({
    required this.recordId,
    this.importJobId,
    this.amount,
    this.occurredOn,
  });

  final int recordId;
  final String? importJobId;

  /// What the file or institution said, before any correction. Kept beside
  /// the transaction's own amount precisely so a correction is visible as a
  /// difference rather than silently replacing the original.
  final Money? amount;

  final DateTime? occurredOn;
}

/// How a transaction came to be reconciled (`UC-24 AF-02`).
///
/// The two are kept apart because they are different claims. A matched
/// reconciliation says an institution reported this movement; a self-confirmed
/// one says the user vouches for it with nothing behind it but their word.
/// `AF-02` requires the interface to say which happened, and a single boolean
/// could not.
enum ReconciliationKind {
  /// Reconciled against an imported record.
  matchedToRecord,

  /// Confirmed by the user, with no imported record behind it.
  selfConfirmed;

  String get label => switch (this) {
    ReconciliationKind.matchedToRecord => 'Matched to an imported record',
    ReconciliationKind.selfConfirmed => 'Confirmed by you',
  };
}

/// One page of the spreadsheet view (`UC-25`).
@immutable
class TransactionPage {
  const TransactionPage({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
  });

  final List<Transaction> items;

  /// The page the API actually returned, which is not always the page asked
  /// for — `AF-05` relies on this being the API's answer rather than the
  /// request echoed back.
  final int pageNumber;

  final int pageSize;
  final int totalItems;
  final int totalPages;

  /// `AF-02`: no matching records, which is not a failure.
  bool get isEmpty => items.isEmpty;

  bool get hasPrevious => pageNumber > 1;
  bool get hasNext => pageNumber < totalPages;
}

/// A recorded transaction, as the API stored it.
@immutable
class Transaction {
  const Transaction({
    required this.id,
    required this.occurredOn,
    required this.amount,
    required this.direction,
    required this.categoryId,
    this.categoryName,
    this.financialAccountId,
    this.financialAccountName,
    this.creditCardId,
    this.creditCardName,
    this.description,
    this.counterpartyName,
    this.isTransfer = false,
    this.isReconciled = false,
    this.isDeleted = false,
    this.isManuallyCorrected = false,
    this.source = TransactionSource.manual,
    this.importedRecord,
    this.tags = const [],
  });

  final String id;
  final DateTime occurredOn;

  /// The amount the API stored, with its currency. Read, never recomputed.
  final Money amount;

  final Direction direction;
  final String categoryId;
  final String? categoryName;

  /// A transaction sits on an account or on a card, never both.
  final String? financialAccountId;
  final String? financialAccountName;
  final String? creditCardId;
  final String? creditCardName;

  final String? description;
  final String? counterpartyName;

  /// `FR-MM-08`: a transfer is neither an earning nor an expense, so a screen
  /// showing direction must know not to claim one.
  final bool isTransfer;

  final bool isReconciled;

  /// `AF-05`: a deleted transaction is not editable, only restorable.
  final bool isDeleted;

  /// Whether a value was changed after import, which is what makes the
  /// imported record worth showing beside it.
  final bool isManuallyCorrected;

  final TransactionSource source;

  /// Present only where this derives from an import (`FR-MM-13`).
  final ImportedRecord? importedRecord;

  final List<String> tags;

  /// What the transaction is attached to, for display.
  String? get holdingName => financialAccountName ?? creditCardName;

  /// Whether editing is offered at all (`UC-20 AF-05`).
  bool get isEditable => !isDeleted;

  /// Whether reconciling is offered (`UC-24` step 1, `AF-01`).
  ///
  /// A deleted transaction is excluded as well as an already-reconciled one:
  /// vouching for a record that is not in any view would be confirming
  /// something the user cannot see.
  bool get canReconcile => !isReconciled && !isDeleted;

  /// Which kind of reconciliation happened (`AF-02`), or `null` where none
  /// has.
  ///
  /// Derived from whether an imported record backs the transaction, because
  /// that is what the API's transaction payload actually carries: it reports
  /// `isReconciled` and the imported record, but not a separate account of
  /// how the two were joined. A transaction with a record behind it was
  /// matched to one; a transaction without is the user's own word.
  ReconciliationKind? get reconciliationKind {
    if (!isReconciled) return null;

    return importedRecord == null
        ? ReconciliationKind.selfConfirmed
        : ReconciliationKind.matchedToRecord;
  }
}

abstract interface class TransactionRepository {
  /// Records a transaction and returns what the API stored (`UC-19` step 6).
  Future<Result<Transaction>> record({
    required DateTime occurredOn,
    required String amount,
    required Direction direction,
    required String categoryId,
    required String currencyCode,
    String? financialAccountId,
    String? creditCardId,
    String? description,
    String? counterparty,
    List<String> tags,
  });

  /// Reads one transaction, including a deleted one (`AF-02`, `AF-05`).
  ///
  /// Deleted records are fetched rather than hidden so the screen can offer
  /// restoration instead of claiming the transaction never existed.
  Future<Result<Transaction>> read(String id);

  /// Updates the editable fields (`FR-MM-06`).
  Future<Result<Transaction>> update({
    required String id,
    required DateTime occurredOn,
    required String amount,
    required Direction direction,
    required String categoryId,
    required String currencyCode,
    String? financialAccountId,
    String? creditCardId,
    String? description,
    String? counterparty,
    List<String> tags,
  });

  /// Deletes a transaction, recoverably (`UC-40`).
  Future<Result<void>> delete(String id);

  /// One page of records, filtered and sorted **by the API** (`FR-TB-02`).
  ///
  /// Every argument is a question for the instance, not a hint for a local
  /// pass: this client never holds a full set to filter or sort. That is what
  /// keeps the view usable on a history too large to fit in memory, and it is
  /// why there is no unfiltered `list` on this interface to be tempted by.
  Future<Result<TransactionPage>> search({
    DateTime? from,
    DateTime? to,
    String? financialAccountId,
    String? creditCardId,
    String? categoryId,
    String? tagId,
    String? counterpartyId,
    Direction? direction,
    String? minimumAmount,
    String? maximumAmount,
    String? text,
    String? sortBy,
    bool descending,
    int pageNumber,
    int pageSize,
  });

  /// Reconciles a transaction (`FR-MM-12`).
  ///
  /// With an imported record where the API proposed one, and without where
  /// the user is vouching for the transaction themselves (`AF-02`).
  Future<Result<Transaction>> reconcile({
    required String id,
    int? importedRecordId,
    String? importJobId,
  });
}

class HttpTransactionRepository implements TransactionRepository {
  HttpTransactionRepository(this._client);

  factory HttpTransactionRepository.fromDio(Dio dio) =>
      HttpTransactionRepository(TransactionsClient(dio));

  final TransactionsClient _client;

  @override
  Future<Result<Transaction>> record({
    required DateTime occurredOn,
    required String amount,
    required Direction direction,
    required String categoryId,
    required String currencyCode,
    String? financialAccountId,
    String? creditCardId,
    String? description,
    String? counterparty,
    List<String> tags = const [],
  }) async {
    try {
      final response = await _client.postApiTransactions(
        body: RecordTransactionCommand(
          occurredOn: occurredOn,
          // The exact decimal, serialized. Never a number on the wire.
          amount: amount,
          direction: direction.asApi,
          categoryId: categoryId,
          currencyCode: currencyCode,
          financialAccountId: financialAccountId,
          creditCardId: creditCardId,
          description: description,
          counterparty: counterparty,
          tags: tags.isEmpty ? null : tags,
        ),
      );

      final output = response.data;

      // The API answered without the transaction it claims to have recorded.
      // Reporting success here would tell the user something exists that this
      // client cannot show them (`AF-06`).
      if (output == null) {
        return const Failure(
          message: 'The instance did not confirm the transaction.',
          kind: FailureKind.serverError,
        );
      }

      return Success(_from(output));
    } on DioException catch (exception) {
      // AF-04, AF-05 and AF-06 all arrive here: an account or category that is
      // not the user's reads as not found, a rule this client does not enforce
      // reads as the API stated it, and a transport failure reads as
      // unreachable — which is what lets the form offer a retry rather than
      // claiming the transaction was recorded.
      return failureFromDioException<Transaction>(exception);
    }
  }

  @override
  Future<Result<Transaction>> read(String id) async {
    try {
      final output = (await _client.getApiTransactionsId(
        id: id,
        // AF-05 needs the deleted one back, not a 404 that would read as
        // AF-02 and send the user looking for something that is still there.
        includeDeleted: true,
      )).data;

      // AF-02.
      if (output == null) {
        return const Failure(
          message: 'That transaction was not found.',
          kind: FailureKind.notFound,
        );
      }

      return Success(fromOutput(output));
    } on DioException catch (exception) {
      return failureFromDioException<Transaction>(exception);
    }
  }

  @override
  Future<Result<Transaction>> update({
    required String id,
    required DateTime occurredOn,
    required String amount,
    required Direction direction,
    required String categoryId,
    required String currencyCode,
    String? financialAccountId,
    String? creditCardId,
    String? description,
    String? counterparty,
    List<String> tags = const [],
  }) async {
    try {
      await _client.putApiTransactionsId(
        id: id,
        body: UpdateTransactionCommand(
          occurredOn: occurredOn,
          amount: amount,
          direction: direction.asApi,
          categoryId: categoryId,
          currencyCode: currencyCode,
          financialAccountId: financialAccountId,
          creditCardId: creditCardId,
          description: description,
          counterparty: counterparty,
          tags: tags.isEmpty ? null : tags,
        ),
      );

      // The update response carries the command's own shape rather than the
      // full transaction, so the stored record is re-read: step 3 confirms
      // what the API now holds, not what was sent to it.
      return await read(id);
    } on DioException catch (exception) {
      // AF-03: a settled statement, a reconciled record, or any other rule
      // this client does not know — all in the API's own words.
      return failureFromDioException<Transaction>(exception);
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await _client.deleteApiTransactionsId(id: id);
      return const Success(null);
    } on DioException catch (exception) {
      return failureFromDioException<void>(exception);
    }
  }

  @override
  Future<Result<TransactionPage>> search({
    DateTime? from,
    DateTime? to,
    String? financialAccountId,
    String? creditCardId,
    String? categoryId,
    String? tagId,
    String? counterpartyId,
    Direction? direction,
    String? minimumAmount,
    String? maximumAmount,
    String? text,
    String? sortBy,
    bool descending = true,
    int pageNumber = 1,
    int pageSize = 25,
  }) async {
    try {
      final output = (await _client.getApiTransactions(
        from: from,
        to: to,
        financialAccountId: financialAccountId,
        creditCardId: creditCardId,
        categoryId: categoryId,
        tagId: tagId,
        counterpartyId: counterpartyId,
        direction: direction?.asApi,
        // The bounds travel as strings, like every other amount.
        minimumAmount: minimumAmount,
        maximumAmount: maximumAmount,
        text: text,
        sortBy: sortBy,
        descending: descending,
        pageNumber: pageNumber,
        pageSize: pageSize,
      )).data;

      if (output == null) {
        return const Failure(
          message: 'The instance returned no page.',
          kind: FailureKind.serverError,
        );
      }

      return Success(
        TransactionPage(
          items: [
            for (final item in output.items ?? const <TransactionOutput>[])
              fromOutput(item),
          ],
          // The API's own page number, not the one requested: asking beyond
          // the last page is answered with the last, and `AF-05` shows what
          // came back rather than insisting on what was asked for.
          pageNumber: output.pageNumber ?? pageNumber,
          pageSize: output.pageSize ?? pageSize,
          totalItems: output.totalItems ?? 0,
          totalPages: output.totalPages ?? 0,
        ),
      );
    } on DioException catch (exception) {
      // AF-03.
      return failureFromDioException<TransactionPage>(exception);
    }
  }

  @override
  Future<Result<Transaction>> reconcile({
    required String id,
    int? importedRecordId,
    String? importJobId,
  }) async {
    try {
      await _client.postApiTransactionsIdReconcile(
        id: id,
        body: ReconcileTransactionCommand(
          importedRecordId: importedRecordId,
          importJobId: importJobId,
          // This use case only reconciles. Undoing one is a different action
          // with a different meaning, and sending `false` here states that
          // plainly rather than leaving the flag to a default.
          unreconcile: false,
        ),
      );

      // The reconcile response carries a narrow projection, so the stored
      // record is re-read: step 4 shows the transaction's new state as the
      // API now holds it, including which kind of reconciliation happened.
      return await read(id);
    } on DioException catch (exception) {
      // AF-03 and AF-04, in the API's own words.
      return failureFromDioException<Transaction>(exception);
    }
  }

  /// Maps the full transaction the API stores.
  ///
  /// Public because the search and the detail read the same shape, and two
  /// mappings of one payload is how the two drift apart.
  static Transaction fromOutput(TransactionOutput output) {
    final currency = output.currencyCode ?? '';
    final recordId = output.importedRecordId;
    final importedAmount = output.importedAmount;

    return Transaction(
      id: output.id ?? '',
      occurredOn: output.occurredOn ?? DateTime(1970),
      amount: Money.parse(output.amount ?? '0', currency),
      direction: Direction.from(output.direction),
      categoryId: output.categoryId ?? '',
      categoryName: output.categoryName,
      financialAccountId: output.financialAccountId,
      financialAccountName: output.financialAccountName,
      creditCardId: output.creditCardId,
      creditCardName: output.creditCardName,
      description: output.description,
      counterpartyName: output.counterpartyName,
      isTransfer: output.isTransfer ?? false,
      isReconciled: output.isReconciled ?? false,
      isDeleted: output.isDeleted ?? false,
      isManuallyCorrected: output.isManuallyCorrected ?? false,
      source: TransactionSource.from(output.sourceType),
      tags: output.tags?.whereType<String>().toList() ?? const [],
      importedRecord: recordId == null
          ? null
          : ImportedRecord(
              recordId: recordId,
              importJobId: output.importJobId,
              amount: importedAmount == null
                  ? null
                  : Money.parse(importedAmount, currency),
              occurredOn: output.importedOccurredOn,
            ),
    );
  }

  static Transaction _from(RecordTransactionCommandOutput output) {
    final currency = output.currencyCode ?? '';

    return Transaction(
      id: output.id ?? '',
      occurredOn: output.occurredOn ?? DateTime(1970),
      amount: Money.parse(output.amount ?? '0', currency),
      direction: Direction.from(output.direction),
      categoryId: output.categoryId ?? '',
      categoryName: output.categoryName,
      financialAccountId: output.financialAccountId,
      creditCardId: output.creditCardId,
      description: output.description,
      counterpartyName: output.counterpartyName,
      // The record response carries ids but not the holding's name, and
      // neither flag: a just-recorded transaction is not a transfer and is
      // not yet reconciled. Both are read from the transaction itself where a
      // later use case needs them, rather than guessed at from this response.
    );
  }
}

final transactionRepositoryProvider = Provider<TransactionRepository>(
  (ref) => HttpTransactionRepository.fromDio(ref.watch(dioProvider)),
);
