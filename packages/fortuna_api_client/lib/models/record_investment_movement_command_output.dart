// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'investment_movement_type.dart';

part 'record_investment_movement_command_output.g.dart';

@JsonSerializable()
class RecordInvestmentMovementCommandOutput {
  const RecordInvestmentMovementCommandOutput({
    this.amount,
    this.appliedRate,
    this.createdAt,
    this.currencyCode,
    this.financialAccountId,
    this.fundingAmount,
    this.fundingCurrencyCode,
    this.id,
    this.investmentId,
    this.movementType,
    this.occurredOn,
    this.outboundTransactionId,
    this.position,
    this.rateDate,
    this.transferId,
    this.updatedAt,
  });

  factory RecordInvestmentMovementCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$RecordInvestmentMovementCommandOutputFromJson(json);

  final String? amount;
  final String? appliedRate;
  final DateTime? createdAt;
  final String? currencyCode;
  final String? financialAccountId;
  final String? fundingAmount;
  final String? fundingCurrencyCode;
  final String? id;
  final String? investmentId;
  final InvestmentMovementType? movementType;
  final DateTime? occurredOn;
  final String? outboundTransactionId;
  final String? position;
  final DateTime? rateDate;
  final String? transferId;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() =>
      _$RecordInvestmentMovementCommandOutputToJson(this);
}
