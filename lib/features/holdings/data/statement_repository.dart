/// Credit card statements (UC-16).
///
/// A statement is a period the API composed, not one this client assembles.
/// Every total it carries — the previous balance, the purchases, the payments
/// received, the foreign tax, the other entries and the amount due — is read
/// as sent (`FR-HO-06`). None is derived from the others, for the reason
/// `credit_card_repository.dart` gives about the available balance: the
/// arithmetic that looks obvious is not always the arithmetic the API meant,
/// and a statement is precisely where a rounding difference would hide.
///
/// The settlement is a **transfer**, not an expense (`FR-HO-08`). That is a
/// statement about meaning rather than presentation: paying a card moves money
/// between two things the user owns, and recording it as spending would count
/// the same money twice — once when the charge was made and again when the
/// bill was paid.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/format/money.dart';
import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// Where a statement is in its life.
///
/// Closing fixes the composition; settling records the payment. The order is
/// one-way, which is what makes `AF-02` and `AF-04` decidable from this value
/// alone rather than from a date comparison the client would have to guess at.
enum StatementStatus {
  open,
  closed,
  settled;

  /// The API sends the name, per its published enum names.
  static StatementStatus parse(String? wire) => switch (wire?.toLowerCase()) {
    'closed' => StatementStatus.closed,
    'settled' => StatementStatus.settled,
    _ => StatementStatus.open,
  };

  String get label => switch (this) {
    StatementStatus.open => 'Open',
    StatementStatus.closed => 'Closed',
    StatementStatus.settled => 'Settled',
  };
}

/// One charge on a statement.
@immutable
class StatementCharge {
  const StatementCharge({
    required this.id,
    required this.occurredOn,
    required this.amount,
    required this.isLateArriving,
    this.direction,
    this.originalAmount,
    this.appliedRate,
    this.rateDate,
  });

  final String id;
  final DateTime occurredOn;
  final Money amount;

  /// `FR-HO-09`: the API decides this, and the statement that received the
  /// charge is where it is marked. A late arrival is not an error — it is a
  /// charge that reached the card after the period it belongs to had passed,
  /// and a reader comparing the statement to their own records needs to see
  /// why the two differ.
  final bool isLateArriving;

  final String? direction;

  /// What was charged before conversion, when the card converted it. Kept as
  /// its own [Money] so the original currency travels with the amount.
  final Money? originalAmount;

  /// The rate the API applied, as a string. Deliberately not a [Money]: a rate
  /// is not an amount of money, and it has no currency of its own.
  final String? appliedRate;

  final DateTime? rateDate;

  /// Whether this charge was converted from another currency.
  bool get wasConverted => originalAmount != null;
}

/// A billing cycle and the charges it contains.
@immutable
class CardStatement {
  const CardStatement({
    required this.id,
    required this.creditCardId,
    required this.currencyCode,
    required this.status,
    required this.periodStart,
    required this.periodEnd,
    required this.closingDate,
    required this.dueDate,
    required this.previousBalance,
    required this.purchaseTotal,
    required this.paymentsReceived,
    required this.foreignTaxTotal,
    required this.otherEntries,
    required this.amountDue,
    required this.charges,
    this.settlementTransactionId,
  });

  final String id;
  final String creditCardId;
  final String currencyCode;
  final StatementStatus status;

  final DateTime periodStart;
  final DateTime periodEnd;
  final DateTime closingDate;
  final DateTime dueDate;

  /// The six figures the API composed. All read, none computed.
  final Money previousBalance;
  final Money purchaseTotal;
  final Money paymentsReceived;
  final Money foreignTaxTotal;
  final Money otherEntries;
  final Money amountDue;

  final List<StatementCharge> charges;

  /// The transfer that settled this statement, once it was settled.
  final String? settlementTransactionId;

  /// `AF-04`: a settled statement's composition is frozen.
  bool get isFrozen => status == StatementStatus.settled;

  /// Whether closing is offered. Only an open statement can be closed, and
  /// whether the closing date has passed is the API's judgement (`AF-01`) —
  /// asking it here would refuse closings the API would have accepted, on a
  /// clock that is the device's rather than the instance's.
  bool get canClose => status == StatementStatus.open;

  /// `AF-02`: settlement is offered on a closed statement and nowhere else.
  bool get canSettle => status == StatementStatus.closed;

  /// Whether any charge on this statement arrived late (`FR-HO-09`).
  bool get hasLateArrivals => charges.any((charge) => charge.isLateArriving);
}

abstract interface class StatementRepository {
  /// The card's billing cycles, most recent first.
  Future<Result<List<CardStatement>>> listForCard(String creditCardId);

  Future<Result<CardStatement>> read(String statementId);

  /// Closes a statement, fixing its composition (`FR-HO-07`).
  Future<Result<void>> close(String statementId);

  /// Settles a closed statement from a financial account (`FR-HO-08`).
  Future<Result<void>> settle({
    required String statementId,
    required String financialAccountId,
    required String amount,
    required DateTime paymentDate,
  });
}

class HttpStatementRepository implements StatementRepository {
  /// Two clients because the endpoints live under two paths: the list hangs
  /// off the card, and everything else off the statement itself.
  HttpStatementRepository(this._cards, this._statements);

  factory HttpStatementRepository.fromDio(Dio dio) =>
      HttpStatementRepository(CreditCardsClient(dio), StatementsClient(dio));

  final CreditCardsClient _cards;
  final StatementsClient _statements;

  @override
  Future<Result<List<CardStatement>>> listForCard(String creditCardId) async {
    try {
      final page = await _cards.getApiCreditCardsIdStatements(
        id: creditCardId,
        sortBy: 'periodEnd',
        descending: true,
      );

      return Success([
        for (final statement
            in page.data ?? const <CreditCardStatementOutput>[])
          _from(statement),
      ]);
    } on DioException catch (exception) {
      // AF-05: a card that is not yours is not found, and the API makes the
      // two indistinguishable on purpose.
      return failureFromDioException<List<CardStatement>>(exception);
    }
  }

  @override
  Future<Result<CardStatement>> read(String statementId) async {
    try {
      final output = (await _statements.getApiStatementsId(id: statementId))
          .data;

      // AF-05.
      if (output == null) {
        return const Failure(
          message: 'That statement was not found.',
          kind: FailureKind.notFound,
        );
      }

      return Success(_from(output));
    } on DioException catch (exception) {
      return failureFromDioException<CardStatement>(exception);
    }
  }

  @override
  Future<Result<void>> close(String statementId) async {
    try {
      await _statements.postApiStatementsIdClose(id: statementId);
      return const Success(null);
    } on DioException catch (exception) {
      // AF-01: closing before the closing date is refused in the API's words,
      // on the instance's clock rather than this device's.
      return failureFromDioException<void>(exception);
    }
  }

  @override
  Future<Result<void>> settle({
    required String statementId,
    required String financialAccountId,
    required String amount,
    required DateTime paymentDate,
  }) async {
    try {
      await _statements.postApiStatementsIdSettle(
        id: statementId,
        body: SettleCreditCardStatementCommand(
          id: statementId,
          financialAccountId: financialAccountId,
          // The amount as a string, all the way out. Never parsed to a number.
          amount: amount,
          paymentDate: paymentDate,
        ),
      );
      return const Success(null);
    } on DioException catch (exception) {
      // AF-02 and AF-03 both land here: a statement that is not closed, and an
      // account in another currency. No conversion is attempted locally —
      // inventing a rate is exactly what `BR-07` forbids.
      return failureFromDioException<void>(exception);
    }
  }

  static CardStatement _from(CreditCardStatementOutput output) {
    final currency = output.currencyCode ?? '';

    Money money(String? amount) => Money.parse(amount ?? '0', currency);

    return CardStatement(
      id: output.id ?? '',
      creditCardId: output.creditCardId ?? '',
      currencyCode: currency,
      status: StatementStatus.parse(output.status),
      periodStart: output.periodStart ?? DateTime(1970),
      periodEnd: output.periodEnd ?? DateTime(1970),
      closingDate: output.closingDate ?? DateTime(1970),
      dueDate: output.dueDate ?? DateTime(1970),
      previousBalance: money(output.previousBalance),
      purchaseTotal: money(output.purchaseTotal),
      paymentsReceived: money(output.paymentsReceived),
      foreignTaxTotal: money(output.foreignTaxTotal),
      otherEntries: money(output.otherEntries),
      amountDue: money(output.amountDue),
      settlementTransactionId: output.settlementTransactionId,
      charges: [
        for (final charge
            in output.transactions ??
                const <CreditCardStatementTransactionOutput>[])
          _chargeFrom(charge, currency),
      ],
    );
  }

  static StatementCharge _chargeFrom(
    CreditCardStatementTransactionOutput output,
    String statementCurrency,
  ) {
    final originalCurrency = output.originalCurrencyCode;
    final originalAmount = output.originalAmount;

    return StatementCharge(
      id: output.id ?? '',
      occurredOn: output.occurredOn ?? DateTime(1970),
      amount: Money.parse(output.amount ?? '0', statementCurrency),
      isLateArriving: output.isLateArriving ?? false,
      direction: output.direction,
      // Only when both halves are present: an amount without its currency is
      // the bare number `Money` exists to prevent.
      originalAmount: (originalAmount != null && originalCurrency != null)
          ? Money.parse(originalAmount, originalCurrency)
          : null,
      appliedRate: output.appliedRate,
      rateDate: output.rateDate,
    );
  }
}

final statementRepositoryProvider = Provider<StatementRepository>(
  (ref) => HttpStatementRepository.fromDio(ref.watch(dioProvider)),
);
