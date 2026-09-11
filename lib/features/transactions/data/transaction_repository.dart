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
import 'package:fortuna_api_client/export.dart' hide TransactionDirection;
import 'package:fortuna_api_client/export.dart'
    as api
    show TransactionDirection;
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

  /// What the transaction is attached to, for display.
  String? get holdingName => financialAccountName ?? creditCardName;
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
