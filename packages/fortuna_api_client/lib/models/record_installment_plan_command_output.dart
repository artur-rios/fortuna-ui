// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'installment_command_output.dart';

part 'record_installment_plan_command_output.g.dart';

@JsonSerializable()
class RecordInstallmentPlanCommandOutput {
  const RecordInstallmentPlanCommandOutput({
    this.appliedRate,
    this.creditCardId,
    this.currencyCode,
    this.id,
    this.installmentCount,
    this.installments,
    this.originalCurrencyCode,
    this.originalTotalAmount,
    this.purchasedOn,
    this.rateDate,
    this.totalAmount,
  });

  factory RecordInstallmentPlanCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$RecordInstallmentPlanCommandOutputFromJson(json);

  final double? appliedRate;
  final String? creditCardId;
  final String? currencyCode;
  final String? id;
  final int? installmentCount;
  final List<InstallmentCommandOutput>? installments;
  final String? originalCurrencyCode;
  final double? originalTotalAmount;
  final DateTime? purchasedOn;
  final DateTime? rateDate;
  final double? totalAmount;

  Map<String, Object?> toJson() =>
      _$RecordInstallmentPlanCommandOutputToJson(this);
}
