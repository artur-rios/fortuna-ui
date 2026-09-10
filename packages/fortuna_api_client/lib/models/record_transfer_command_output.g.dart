// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_transfer_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordTransferCommandOutput _$RecordTransferCommandOutputFromJson(
  Map<String, dynamic> json,
) => RecordTransferCommandOutput(
  appliedRate: json['appliedRate'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  destinationFinancialAccountId:
      json['destinationFinancialAccountId'] as String?,
  destinationStatementId: json['destinationStatementId'] as String?,
  id: json['id'] as String?,
  inboundAmount: json['inboundAmount'] as String?,
  inboundCurrencyCode: json['inboundCurrencyCode'] as String?,
  inboundTransactionId: json['inboundTransactionId'] as String?,
  occurredOn: json['occurredOn'] == null
      ? null
      : DateTime.parse(json['occurredOn'] as String),
  originFinancialAccountId: json['originFinancialAccountId'] as String?,
  outboundAmount: json['outboundAmount'] as String?,
  outboundCurrencyCode: json['outboundCurrencyCode'] as String?,
  outboundTransactionId: json['outboundTransactionId'] as String?,
  rateDate: json['rateDate'] == null
      ? null
      : DateTime.parse(json['rateDate'] as String),
);

Map<String, dynamic> _$RecordTransferCommandOutputToJson(
  RecordTransferCommandOutput instance,
) => <String, dynamic>{
  'appliedRate': instance.appliedRate,
  'createdAt': instance.createdAt?.toIso8601String(),
  'destinationFinancialAccountId': instance.destinationFinancialAccountId,
  'destinationStatementId': instance.destinationStatementId,
  'id': instance.id,
  'inboundAmount': instance.inboundAmount,
  'inboundCurrencyCode': instance.inboundCurrencyCode,
  'inboundTransactionId': instance.inboundTransactionId,
  'occurredOn': instance.occurredOn?.toIso8601String(),
  'originFinancialAccountId': instance.originFinancialAccountId,
  'outboundAmount': instance.outboundAmount,
  'outboundCurrencyCode': instance.outboundCurrencyCode,
  'outboundTransactionId': instance.outboundTransactionId,
  'rateDate': instance.rateDate?.toIso8601String(),
};
