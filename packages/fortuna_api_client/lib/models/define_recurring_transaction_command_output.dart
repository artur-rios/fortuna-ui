// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'recurrence_frequency.dart';
import 'transaction_direction.dart';

part 'define_recurring_transaction_command_output.g.dart';

@JsonSerializable()
class DefineRecurringTransactionCommandOutput {
  const DefineRecurringTransactionCommandOutput({
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
    this.nextOccurrences,
    this.startsOn,
  });

  factory DefineRecurringTransactionCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$DefineRecurringTransactionCommandOutputFromJson(json);

  final String? amount;
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
  final List<DateTime>? nextOccurrences;
  final DateTime? startsOn;

  Map<String, Object?> toJson() =>
      _$DefineRecurringTransactionCommandOutputToJson(this);
}
