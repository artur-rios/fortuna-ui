// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'recurrence_frequency.dart';
import 'transaction_direction.dart';

part 'update_recurring_transaction_command.g.dart';

@JsonSerializable()
class UpdateRecurringTransactionCommand {
  const UpdateRecurringTransactionCommand({
    this.amount,
    this.categoryId,
    this.counterparty,
    this.creditCardId,
    this.description,
    this.direction,
    this.endsOn,
    this.financialAccountId,
    this.frequency,
    this.ownerId,
    this.startsOn,
  });

  factory UpdateRecurringTransactionCommand.fromJson(
    Map<String, Object?> json,
  ) => _$UpdateRecurringTransactionCommandFromJson(json);

  final double? amount;
  final String? categoryId;
  final String? counterparty;
  final String? creditCardId;
  final String? description;
  final TransactionDirection? direction;
  final DateTime? endsOn;
  final String? financialAccountId;
  final RecurrenceFrequency? frequency;
  final String? ownerId;
  final DateTime? startsOn;

  Map<String, Object?> toJson() =>
      _$UpdateRecurringTransactionCommandToJson(this);
}
