// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'transfer_output.g.dart';

@JsonSerializable()
class TransferOutput {
  const TransferOutput({
    this.appliedRate,
    this.createdAt,
    this.destinationCreditCardId,
    this.destinationFinancialAccountId,
    this.destinationInvestmentId,
    this.destinationStatementId,
    this.id,
    this.inboundAmount,
    this.inboundCurrencyCode,
    this.inboundInvestmentMovementId,
    this.inboundIsDeleted,
    this.inboundTransactionId,
    this.isDeleted,
    this.occurredOn,
    this.originFinancialAccountId,
    this.outboundAmount,
    this.outboundCurrencyCode,
    this.outboundIsDeleted,
    this.outboundTransactionId,
    this.rateDate,
    this.updatedAt,
  });

  factory TransferOutput.fromJson(Map<String, Object?> json) =>
      _$TransferOutputFromJson(json);

  final double? appliedRate;
  final DateTime? createdAt;
  final String? destinationCreditCardId;
  final String? destinationFinancialAccountId;
  final String? destinationInvestmentId;
  final String? destinationStatementId;
  final String? id;
  final double? inboundAmount;
  final String? inboundCurrencyCode;
  final String? inboundInvestmentMovementId;
  final bool? inboundIsDeleted;
  final String? inboundTransactionId;
  final bool? isDeleted;
  final DateTime? occurredOn;
  final String? originFinancialAccountId;
  final double? outboundAmount;
  final String? outboundCurrencyCode;
  final bool? outboundIsDeleted;
  final String? outboundTransactionId;
  final DateTime? rateDate;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$TransferOutputToJson(this);
}
