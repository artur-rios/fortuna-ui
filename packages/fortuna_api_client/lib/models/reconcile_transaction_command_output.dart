// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'transaction_reconciliation_output.dart';

part 'reconcile_transaction_command_output.g.dart';

@JsonSerializable()
class ReconcileTransactionCommandOutput {
  const ReconcileTransactionCommandOutput({
    this.amount,
    this.currencyCode,
    this.id,
    this.isReconciled,
    this.occurredOn,
    this.reconciliation,
    this.updatedAt,
  });

  factory ReconcileTransactionCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$ReconcileTransactionCommandOutputFromJson(json);

  final String? amount;
  final String? currencyCode;
  final String? id;
  final bool? isReconciled;
  final DateTime? occurredOn;
  final TransactionReconciliationOutput? reconciliation;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() =>
      _$ReconcileTransactionCommandOutputToJson(this);
}
