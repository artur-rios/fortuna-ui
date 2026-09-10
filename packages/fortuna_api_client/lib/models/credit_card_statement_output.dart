// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'credit_card_statement_transaction_output.dart';

part 'credit_card_statement_output.g.dart';

@JsonSerializable()
class CreditCardStatementOutput {
  const CreditCardStatementOutput({
    this.amountDue,
    this.closingDate,
    this.createdAt,
    this.creditCardId,
    this.currencyCode,
    this.dueDate,
    this.foreignTaxTotal,
    this.id,
    this.otherEntries,
    this.paymentsReceived,
    this.periodEnd,
    this.periodStart,
    this.previousBalance,
    this.purchaseTotal,
    this.settlementTransactionId,
    this.status,
    this.transactions,
    this.updatedAt,
  });

  factory CreditCardStatementOutput.fromJson(Map<String, Object?> json) =>
      _$CreditCardStatementOutputFromJson(json);

  final String? amountDue;
  final DateTime? closingDate;
  final DateTime? createdAt;
  final String? creditCardId;
  final String? currencyCode;
  final DateTime? dueDate;
  final String? foreignTaxTotal;
  final String? id;
  final String? otherEntries;
  final String? paymentsReceived;
  final DateTime? periodEnd;
  final DateTime? periodStart;
  final String? previousBalance;
  final String? purchaseTotal;
  final String? settlementTransactionId;
  final String? status;
  final List<CreditCardStatementTransactionOutput>? transactions;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$CreditCardStatementOutputToJson(this);
}
