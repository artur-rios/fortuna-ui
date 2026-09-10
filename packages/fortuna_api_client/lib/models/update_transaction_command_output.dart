// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'transaction_direction.dart';
import 'transaction_source_type.dart';
import 'update_transaction_tag_output.dart';

part 'update_transaction_command_output.g.dart';

@JsonSerializable()
class UpdateTransactionCommandOutput {
  const UpdateTransactionCommandOutput({
    this.amount,
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
    this.direction,
    this.financialAccountId,
    this.financialAccountName,
    this.id,
    this.isLateArriving,
    this.isManuallyCorrected,
    this.isReconciled,
    this.isTransfer,
    this.occurredOn,
    this.originalAmount,
    this.originalCurrencyCode,
    this.rateDate,
    this.sourceType,
    this.statementId,
    this.tags,
    this.updatedAt,
  });

  factory UpdateTransactionCommandOutput.fromJson(Map<String, Object?> json) =>
      _$UpdateTransactionCommandOutputFromJson(json);

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
  final bool? isLateArriving;
  final bool? isManuallyCorrected;
  final bool? isReconciled;
  final bool? isTransfer;
  final DateTime? occurredOn;
  final String? originalAmount;
  final String? originalCurrencyCode;
  final DateTime? rateDate;
  final TransactionSourceType? sourceType;
  final String? statementId;
  final List<UpdateTransactionTagOutput>? tags;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$UpdateTransactionCommandOutputToJson(this);
}
