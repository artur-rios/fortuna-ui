// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'credit_card_statement_transaction_output.g.dart';

@JsonSerializable()
class CreditCardStatementTransactionOutput {
  const CreditCardStatementTransactionOutput({
    this.amount,
    this.appliedRate,
    this.createdAt,
    this.direction,
    this.id,
    this.isLateArriving,
    this.occurredOn,
    this.originalAmount,
    this.originalCurrencyCode,
    this.rateDate,
    this.updatedAt,
  });

  factory CreditCardStatementTransactionOutput.fromJson(
    Map<String, Object?> json,
  ) => _$CreditCardStatementTransactionOutputFromJson(json);

  final String? amount;
  final String? appliedRate;
  final DateTime? createdAt;
  final String? direction;
  final String? id;
  final bool? isLateArriving;
  final DateTime? occurredOn;
  final String? originalAmount;
  final String? originalCurrencyCode;
  final DateTime? rateDate;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() =>
      _$CreditCardStatementTransactionOutputToJson(this);
}
