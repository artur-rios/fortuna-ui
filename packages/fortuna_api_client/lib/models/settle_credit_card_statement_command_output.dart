// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'settle_credit_card_statement_command_output.g.dart';

@JsonSerializable()
class SettleCreditCardStatementCommandOutput {
  const SettleCreditCardStatementCommandOutput({
    this.appliedAmount,
    this.appliedRate,
    this.carryStatementId,
    this.creditAmount,
    this.creditCardCurrencyCode,
    this.financialAccountId,
    this.id,
    this.inboundTransactionId,
    this.outboundTransactionId,
    this.paymentAmount,
    this.paymentCurrencyCode,
    this.paymentDate,
    this.rateDate,
    this.remainingBalance,
    this.statementAmountDue,
    this.status,
    this.transferId,
  });

  factory SettleCreditCardStatementCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$SettleCreditCardStatementCommandOutputFromJson(json);

  final String? appliedAmount;
  final String? appliedRate;
  final String? carryStatementId;
  final String? creditAmount;
  final String? creditCardCurrencyCode;
  final String? financialAccountId;
  final String? id;
  final String? inboundTransactionId;
  final String? outboundTransactionId;
  final String? paymentAmount;
  final String? paymentCurrencyCode;
  final DateTime? paymentDate;
  final DateTime? rateDate;
  final String? remainingBalance;
  final String? statementAmountDue;
  final String? status;
  final String? transferId;

  Map<String, Object?> toJson() =>
      _$SettleCreditCardStatementCommandOutputToJson(this);
}
