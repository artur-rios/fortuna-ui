// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'installment_command_output.g.dart';

@JsonSerializable()
class InstallmentCommandOutput {
  const InstallmentCommandOutput({
    this.amount,
    this.appliedRate,
    this.currencyCode,
    this.isLateArriving,
    this.number,
    this.occurredOn,
    this.originalAmount,
    this.originalCurrencyCode,
    this.rateDate,
    this.statementId,
    this.transactionId,
  });

  factory InstallmentCommandOutput.fromJson(Map<String, Object?> json) =>
      _$InstallmentCommandOutputFromJson(json);

  final String? amount;
  final String? appliedRate;
  final String? currencyCode;
  final bool? isLateArriving;
  final int? number;
  final DateTime? occurredOn;
  final String? originalAmount;
  final String? originalCurrencyCode;
  final DateTime? rateDate;
  final String? statementId;
  final String? transactionId;

  Map<String, Object?> toJson() => _$InstallmentCommandOutputToJson(this);
}
