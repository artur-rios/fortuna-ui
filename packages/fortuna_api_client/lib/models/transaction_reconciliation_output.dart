// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'transaction_reconciliation_output.g.dart';

@JsonSerializable()
class TransactionReconciliationOutput {
  const TransactionReconciliationOutput({
    this.hasDiscrepancy,
    this.importJobId,
    this.importedAmount,
    this.importedOccurredOn,
    this.importedRecordId,
    this.transactionAmount,
    this.transactionOccurredOn,
  });

  factory TransactionReconciliationOutput.fromJson(Map<String, Object?> json) =>
      _$TransactionReconciliationOutputFromJson(json);

  final bool? hasDiscrepancy;
  final String? importJobId;
  final double? importedAmount;
  final DateTime? importedOccurredOn;
  final int? importedRecordId;
  final double? transactionAmount;
  final DateTime? transactionOccurredOn;

  Map<String, Object?> toJson() =>
      _$TransactionReconciliationOutputToJson(this);
}
