// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'record_installment_plan_command.g.dart';

@JsonSerializable()
class RecordInstallmentPlanCommand {
  const RecordInstallmentPlanCommand({
    this.categoryId,
    this.counterparty,
    this.creditCardId,
    this.currencyCode,
    this.installmentCount,
    this.ownerId,
    this.purchasedOn,
    this.totalAmount,
  });

  factory RecordInstallmentPlanCommand.fromJson(Map<String, Object?> json) =>
      _$RecordInstallmentPlanCommandFromJson(json);

  final String? categoryId;
  final String? counterparty;
  final String? creditCardId;
  final String? currencyCode;
  final int? installmentCount;
  final String? ownerId;
  final DateTime? purchasedOn;
  final String? totalAmount;

  Map<String, Object?> toJson() => _$RecordInstallmentPlanCommandToJson(this);
}
