/// Deleted records (UC-40).
///
/// Deletion and permanent removal are two different acts, and this file keeps
/// them apart at every level (`FR-LC-01`). A deleted record still exists: it
/// is out of the views it belongs to and can be brought back. A permanently
/// removed one is gone, and nothing here can undo that — which is why
/// [purge] is offered only for something already deleted (`FR-LC-02`) and why
/// the interface confirms it separately.
///
/// **Scope.** Three kinds are covered: transactions, financial accounts and
/// categories. Those are the kinds the contract lets this client both
/// *enumerate when deleted* and *restore or purge*. Credit cards and
/// investments have restore and hard-delete but no way to list their deleted
/// ones; tags, counterparties, budgets and goals can be listed with their
/// deleted ones but have no restore. Either gap makes the use case
/// unimplementable for that kind, so it is left out rather than half-built.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/api.dart';
import 'package:meta/meta.dart';

import '../../../core/format/money.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/date_only_fields.dart';
import '../../../core/network/paging.dart';
import '../../../core/result/result.dart';

/// What kind of thing was deleted.
enum RecordKind {
  transaction('Transaction'),
  account('Account'),
  category('Category');

  const RecordKind(this.label);

  final String label;
}

/// One deleted record, in the only view it appears in (step 1).
@immutable
class DeletedRecord {
  const DeletedRecord({
    required this.id,
    required this.kind,
    required this.label,
    this.detail,
    this.amount,
    this.occurredOn,
    this.stillUsedBy,
  });

  final String id;
  final RecordKind kind;

  /// What the record is called, as the user would recognize it.
  final String label;

  /// A second line — an institution, a currency.
  final String? detail;

  /// The record's amount, where it has one. Carried as [Money] rather than
  /// pre-rendered text so the screen formats it in the user's locale like
  /// every other figure (`FR-PS-02`, `IR-06`).
  final Money? amount;

  /// The day the record is dated, where it has one — formatted by the screen,
  /// for the same reason.
  final DateTime? occurredOn;

  /// How many live records still point at this one, where the API says.
  ///
  /// `AF-06`: what else a permanent removal would take with it, stated
  /// *before* the confirmation rather than discovered in a refusal
  /// afterwards. Null where the instance does not report it for this kind,
  /// which is different from zero and is shown differently.
  final int? stillUsedBy;

  /// Whether anything is known to still refer to this record.
  bool get isStillReferenced => (stillUsedBy ?? 0) > 0;
}

abstract interface class DeletedRecordRepository {
  /// Every deleted record, across the kinds this client can act on.
  Future<Result<List<DeletedRecord>>> list();

  /// Brings a record back (`FR-LC-04`, step 2).
  Future<Result<void>> restore(DeletedRecord record);

  /// Removes it for good (`FR-LC-02`, step 3).
  ///
  /// Takes a [DeletedRecord] rather than an id and a kind, so it is not
  /// possible to ask for the permanent removal of something that was never
  /// listed as deleted — `AF-05` is a matter of what this method can be
  /// called with, not a check inside it.
  Future<Result<void>> purge(DeletedRecord record);
}

class HttpDeletedRecordRepository implements DeletedRecordRepository {
  /// Three clients because deleted records live under three roots — there is
  /// no one route that enumerates them.
  HttpDeletedRecordRepository(
    this._transactions,
    this._accounts,
    this._categories,
  );

  factory HttpDeletedRecordRepository.fromDio(Dio dio) =>
      HttpDeletedRecordRepository(
        TransactionsClient(dio),
        AccountsClient(dio),
        CategoriesClient(dio),
      );

  final TransactionsClient _transactions;
  final AccountsClient _accounts;
  final CategoriesClient _categories;

  @override
  Future<Result<List<DeletedRecord>>> list() async {
    try {
      final records = <DeletedRecord>[
        ...await _deletedTransactions(),
        ...await _deletedAccounts(),
        ...await _deletedCategories(),
      ];

      return Success(records);
    } on DioException catch (exception) {
      return failureFromDioException<List<DeletedRecord>>(exception);
    } on Object catch (error) {
      return failureFromUnreadableAnswer<List<DeletedRecord>>(error);
    }
  }

  @override
  Future<Result<void>> restore(DeletedRecord record) async {
    try {
      switch (record.kind) {
        case RecordKind.transaction:
          await _transactions.postApiTransactionsByIdRestore(id: record.id);
        case RecordKind.account:
          await _accounts.postApiAccountsByIdRestore(id: record.id);
        case RecordKind.category:
          await _categories.postApiCategoriesByIdRestore(id: record.id);
      }
      return const Success(null);
    } on DioException catch (exception) {
      // AF-02 and AF-03: a refusal and a not-found, each in the API's words.
      return failureFromDioException<void>(exception);
    } on Object catch (error) {
      return failureFromUnreadableAnswer<void>(error);
    }
  }

  @override
  Future<Result<void>> purge(DeletedRecord record) async {
    try {
      switch (record.kind) {
        case RecordKind.transaction:
          await _transactions.deleteApiTransactionsByIdHard(id: record.id);
        case RecordKind.account:
          await _accounts.deleteApiAccountsByIdHard(id: record.id);
        case RecordKind.category:
          await _categories.deleteApiCategoriesByIdHard(id: record.id);
      }
      return const Success(null);
    } on DioException catch (exception) {
      // AF-01: the API names what still refers to it, and that reason is
      // what the user reads. The control is not hidden on a guess about
      // whether the removal would be allowed.
      return failureFromDioException<void>(exception);
    } on Object catch (error) {
      return failureFromUnreadableAnswer<void>(error);
    }
  }

  Future<List<DeletedRecord>> _deletedTransactions() async {
    // Only the deleted ones are asked for, so the read grows with what was
    // deleted rather than with every record kept. The check on each item
    // below stays: a record not marked deleted is not offered for removal
    // whatever the answer says.
    final items = await readEveryPage((pageNumber, pageSize) async {
      final page = (await _transactions.getApiTransactions(
        deletedOnly: true,
        pageNumber: pageNumber,
        pageSize: pageSize,
      )).data;
      return (
        items: page?.items ?? const <TransactionOutput>[],
        totalPages: page?.totalPages,
      );
    });

    return [
      for (final item in items)
        if (item.isDeleted ?? false)
          DeletedRecord(
            id: item.id ?? '',
            kind: RecordKind.transaction,
            label: switch (item.description?.value) {
              final description? when description.isNotEmpty => description,
              _ => item.categoryName?.value ?? 'Transaction',
            },
            amount: switch ((item.amount, item.currencyCode?.value)) {
              (final amount?, final currency?) => Money.parse(amount, currency),
              _ => null,
            },
            occurredOn: dateFromWire(item.occurredOn),
          ),
    ];
  }

  Future<List<DeletedRecord>> _deletedAccounts() async {
    final items = await readEveryPage((pageNumber, pageSize) async {
      final page = await _accounts.getApiAccounts(
        deletedOnly: true,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return (
        items: page.data?.value ?? const <FinancialAccountOutput>[],
        totalPages: page.totalPages,
      );
    });

    return [
      for (final item in items)
        if (item.isDeleted ?? false)
          DeletedRecord(
            id: item.id ?? '',
            kind: RecordKind.account,
            label: item.name?.value ?? 'Account',
            detail: item.currencyCode?.value,
          ),
    ];
  }

  Future<List<DeletedRecord>> _deletedCategories() async {
    final output = (await _categories.getApiCategories(
      includeDeleted: true,
      // AF-06: what still points at a category, so the confirmation can say
      // what a permanent removal would take with it.
      includeUsageCounts: true,
    )).data;

    final deleted = <DeletedRecord>[];

    void walk(Iterable<CategoryOutput> nodes) {
      for (final node in nodes) {
        if (node.isDeleted ?? false) {
          deleted.add(
            DeletedRecord(
              id: node.id ?? '',
              kind: RecordKind.category,
              label: node.name?.value ?? 'Category',
              stillUsedBy: node.usageCount?.value,
            ),
          );
        }
        walk(node.children?.value ?? const <CategoryOutput>[]);
      }
    }

    walk(output?.categories?.value ?? const <CategoryOutput>[]);
    return deleted;
  }
}

final deletedRecordRepositoryProvider = Provider<DeletedRecordRepository>(
  (ref) => HttpDeletedRecordRepository.fromDio(ref.watch(dioProvider)),
);
