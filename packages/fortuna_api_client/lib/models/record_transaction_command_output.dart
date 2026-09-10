// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'transaction_direction.dart';
import 'transaction_tag_output.dart';

part 'record_transaction_command_output.g.dart';

@JsonSerializable()
class RecordTransactionCommandOutput {
  const RecordTransactionCommandOutput({
    this.amount,
    this.appliedRate,
    this.categoryId,
    this.categoryName,
    this.counterpartyId,
    this.counterpartyName,
    this.createdAt,
    this.creditCardId,
    this.currencyCode,
    this.description,
    this.direction,
    this.financialAccountId,
    this.id,
    this.isLateArriving,
    this.occurredOn,
    this.originalAmount,
    this.originalCurrencyCode,
    this.rateDate,
    this.statementClosingDate,
    this.statementDueDate,
    this.statementId,
    this.statementPeriodEnd,
    this.statementPeriodStart,
    this.statementPurchaseTotal,
    this.statementStatus,
    this.tags,
    this.updatedAt,
  });

  factory RecordTransactionCommandOutput.fromJson(Map<String, Object?> json) =>
      _$RecordTransactionCommandOutputFromJson(json);

  final String? amount;
  final String? appliedRate;
  final String? categoryId;
  final String? categoryName;
  final String? counterpartyId;
  final String? counterpartyName;
  final DateTime? createdAt;
  final String? creditCardId;
  final String? currencyCode;
  final String? description;
  final TransactionDirection? direction;
  final String? financialAccountId;
  final String? id;
  final bool? isLateArriving;
  final DateTime? occurredOn;
  final String? originalAmount;
  final String? originalCurrencyCode;
  final DateTime? rateDate;
  final DateTime? statementClosingDate;
  final DateTime? statementDueDate;
  final String? statementId;
  final DateTime? statementPeriodEnd;
  final DateTime? statementPeriodStart;
  final String? statementPurchaseTotal;
  final String? statementStatus;
  final List<TransactionTagOutput>? tags;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$RecordTransactionCommandOutputToJson(this);
}
