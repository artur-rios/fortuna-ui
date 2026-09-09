// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'record_transfer_command_output.g.dart';

@JsonSerializable()
class RecordTransferCommandOutput {
  const RecordTransferCommandOutput({
    this.appliedRate,
    this.createdAt,
    this.destinationFinancialAccountId,
    this.destinationStatementId,
    this.id,
    this.inboundAmount,
    this.inboundCurrencyCode,
    this.inboundTransactionId,
    this.occurredOn,
    this.originFinancialAccountId,
    this.outboundAmount,
    this.outboundCurrencyCode,
    this.outboundTransactionId,
    this.rateDate,
  });

  factory RecordTransferCommandOutput.fromJson(Map<String, Object?> json) =>
      _$RecordTransferCommandOutputFromJson(json);

  final double? appliedRate;
  final DateTime? createdAt;
  final String? destinationFinancialAccountId;
  final String? destinationStatementId;
  final String? id;
  final double? inboundAmount;
  final String? inboundCurrencyCode;
  final String? inboundTransactionId;
  final DateTime? occurredOn;
  final String? originFinancialAccountId;
  final double? outboundAmount;
  final String? outboundCurrencyCode;
  final String? outboundTransactionId;
  final DateTime? rateDate;

  Map<String, Object?> toJson() => _$RecordTransferCommandOutputToJson(this);
}
