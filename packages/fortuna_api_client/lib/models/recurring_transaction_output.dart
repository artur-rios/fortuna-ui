// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'recurrence_frequency.dart';
import 'transaction_direction.dart';

part 'recurring_transaction_output.g.dart';

@JsonSerializable()
class RecurringTransactionOutput {
  const RecurringTransactionOutput({
    this.amount,
    this.categoryId,
    this.counterpartyId,
    this.counterpartyName,
    this.createdAt,
    this.creditCardId,
    this.currencyCode,
    this.description,
    this.direction,
    this.endsOn,
    this.financialAccountId,
    this.frequency,
    this.id,
    this.lastMaterializedOn,
    this.nextOccurrences,
    this.startsOn,
    this.updatedAt,
  });

  factory RecurringTransactionOutput.fromJson(Map<String, Object?> json) =>
      _$RecurringTransactionOutputFromJson(json);

  final double? amount;
  final String? categoryId;
  final String? counterpartyId;
  final String? counterpartyName;
  final DateTime? createdAt;
  final String? creditCardId;
  final String? currencyCode;
  final String? description;
  final TransactionDirection? direction;
  final DateTime? endsOn;
  final String? financialAccountId;
  final RecurrenceFrequency? frequency;
  final String? id;
  final DateTime? lastMaterializedOn;
  final List<DateTime>? nextOccurrences;
  final DateTime? startsOn;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$RecurringTransactionOutputToJson(this);
}
