// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'transaction_direction.dart';
import 'transaction_label_output.dart';
import 'transaction_source_type.dart';

part 'transaction_output.g.dart';

@JsonSerializable()
class TransactionOutput {
  const TransactionOutput({
    this.direction,
    this.appliedRate,
    this.categoryId,
    this.categoryName,
    this.counterpartyId,
    this.counterpartyName,
    this.createdAt,
    this.creditCardId,
    this.creditCardName,
    this.currencyCode,
    this.description,
    this.amount,
    this.financialAccountId,
    this.financialAccountName,
    this.id,
    this.importJobId,
    this.importedAmount,
    this.importedOccurredOn,
    this.importedRecordId,
    this.installmentNumber,
    this.installmentPlanId,
    this.isDeleted,
    this.isLateArriving,
    this.updatedAt,
    this.isPossibleDuplicate,
    this.isReconciled,
    this.isTransfer,
    this.occurredOn,
    this.originalAmount,
    this.originalCurrencyCode,
    this.rateDate,
    this.recurringTransactionId,
    this.sourceType,
    this.statementId,
    this.tags,
    this.isManuallyCorrected,
  });

  factory TransactionOutput.fromJson(Map<String, Object?> json) =>
      _$TransactionOutputFromJson(json);

  final String? amount;
  final String? appliedRate;
  final String? categoryId;
  final String? categoryName;
  final String? counterpartyId;
  final String? counterpartyName;
  final DateTime? createdAt;
  final String? creditCardId;
  final String? creditCardName;
  final String? currencyCode;
  final String? description;
  final TransactionDirection? direction;
  final String? financialAccountId;
  final String? financialAccountName;
  final String? id;
  final String? importJobId;
  final String? importedAmount;
  final DateTime? importedOccurredOn;
  final int? importedRecordId;
  final int? installmentNumber;
  final String? installmentPlanId;
  final bool? isDeleted;
  final bool? isLateArriving;
  final bool? isManuallyCorrected;
  final bool? isPossibleDuplicate;
  final bool? isReconciled;
  final bool? isTransfer;
  final DateTime? occurredOn;
  final String? originalAmount;
  final String? originalCurrencyCode;
  final DateTime? rateDate;
  final String? recurringTransactionId;
  final TransactionSourceType? sourceType;
  final String? statementId;
  final List<TransactionLabelOutput>? tags;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$TransactionOutputToJson(this);
}
