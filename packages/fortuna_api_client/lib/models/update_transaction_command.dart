// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'transaction_direction.dart';

part 'update_transaction_command.g.dart';

@JsonSerializable()
class UpdateTransactionCommand {
  const UpdateTransactionCommand({
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

  factory UpdateTransactionCommand.fromJson(Map<String, Object?> json) =>
      _$UpdateTransactionCommandFromJson(json);

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

  Map<String, Object?> toJson() => _$UpdateTransactionCommandToJson(this);
}
