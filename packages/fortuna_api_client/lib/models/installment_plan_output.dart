// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'installment_output.dart';

part 'installment_plan_output.g.dart';

@JsonSerializable()
class InstallmentPlanOutput {
  const InstallmentPlanOutput({
    this.appliedRate,
    this.createdAt,
    this.creditCardId,
    this.currencyCode,
    this.id,
    this.installmentCount,
    this.installments,
    this.isDeleted,
    this.originalCurrencyCode,
    this.originalTotalAmount,
    this.purchasedOn,
    this.rateDate,
    this.totalAmount,
    this.updatedAt,
  });

  factory InstallmentPlanOutput.fromJson(Map<String, Object?> json) =>
      _$InstallmentPlanOutputFromJson(json);

  final String? appliedRate;
  final DateTime? createdAt;
  final String? creditCardId;
  final String? currencyCode;
  final String? id;
  final int? installmentCount;
  final List<InstallmentOutput>? installments;
  final bool? isDeleted;
  final String? originalCurrencyCode;
  final String? originalTotalAmount;
  final DateTime? purchasedOn;
  final DateTime? rateDate;
  final String? totalAmount;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$InstallmentPlanOutputToJson(this);
}
