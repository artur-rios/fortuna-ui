// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'recurrence_frequency.dart';
import 'transaction_direction.dart';

part 'update_recurring_transaction_command_output.g.dart';

@JsonSerializable()
class UpdateRecurringTransactionCommandOutput {
  const UpdateRecurringTransactionCommandOutput({
    this.amount,
    this.appliesFrom,
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
    this.materializedOccurrencesChanged,
    this.nextOccurrences,
    this.startsOn,
    this.updatedAt,
  });

  factory UpdateRecurringTransactionCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$UpdateRecurringTransactionCommandOutputFromJson(json);

  final double? amount;
  final DateTime? appliesFrom;
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
  final bool? materializedOccurrencesChanged;
  final List<DateTime>? nextOccurrences;
  final DateTime? startsOn;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() =>
      _$UpdateRecurringTransactionCommandOutputToJson(this);
}
