// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'transaction_direction.dart';

part 'record_transaction_command.g.dart';

@JsonSerializable()
class RecordTransactionCommand {
  const RecordTransactionCommand({
    this.amount,
    this.categoryId,
    this.counterparty,
    this.creditCardId,
    this.currencyCode,
    this.description,
    this.direction,
    this.financialAccountId,
    this.occurredOn,
    this.ownerId,
    this.tags,
  });

  factory RecordTransactionCommand.fromJson(Map<String, Object?> json) =>
      _$RecordTransactionCommandFromJson(json);

  final String? amount;
  final String? categoryId;
  final String? counterparty;
  final String? creditCardId;
  final String? currencyCode;
  final String? description;
  final TransactionDirection? direction;
  final String? financialAccountId;
  final DateTime? occurredOn;
  final String? ownerId;
  final List<String>? tags;

  Map<String, Object?> toJson() => _$RecordTransactionCommandToJson(this);
}
