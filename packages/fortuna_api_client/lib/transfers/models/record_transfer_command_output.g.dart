// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_transfer_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordTransferCommandOutput _$RecordTransferCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'appliedRate',
      'createdAt',
      'destinationFinancialAccountId',
      'destinationStatementId',
      'id',
      'inboundAmount',
      'inboundCurrencyCode',
      'inboundTransactionId',
      'occurredOn',
      'originFinancialAccountId',
      'outboundAmount',
      'outboundCurrencyCode',
      'outboundTransactionId',
      'rateDate',
    ],
    disallowNullValues: const [
      'createdAt',
      'id',
      'inboundAmount',
      'inboundTransactionId',
      'occurredOn',
      'originFinancialAccountId',
      'outboundAmount',
      'outboundTransactionId',
    ],
  );
  return RecordTransferCommandOutput(
    appliedRate: json['appliedRate'] as String?,
    createdAt: RecordTransferCommandOutput._read_createdAt(json['createdAt']),
    destinationFinancialAccountId:
        json['destinationFinancialAccountId'] as String?,
    destinationStatementId: json['destinationStatementId'] as String?,
    id: json['id'] as String?,
    inboundAmount: json['inboundAmount'] as String?,
    inboundCurrencyCode: json['inboundCurrencyCode'] as String?,
    inboundTransactionId: json['inboundTransactionId'] as String?,
    occurredOn: json['occurredOn'] as String?,
    originFinancialAccountId: json['originFinancialAccountId'] as String?,
    outboundAmount: json['outboundAmount'] as String?,
    outboundCurrencyCode: json['outboundCurrencyCode'] as String?,
    outboundTransactionId: json['outboundTransactionId'] as String?,
    rateDate: json['rateDate'] as String?,
  );
}

Map<String, dynamic> _$RecordTransferCommandOutputToJson(
  RecordTransferCommandOutput instance,
) => <String, dynamic>{
  'appliedRate': ?instance.appliedRate,
  'createdAt': ?RecordTransferCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  'destinationFinancialAccountId': ?instance.destinationFinancialAccountId,
  'destinationStatementId': ?instance.destinationStatementId,
  'id': ?instance.id,
  'inboundAmount': ?instance.inboundAmount,
  'inboundCurrencyCode': ?instance.inboundCurrencyCode,
  'inboundTransactionId': ?instance.inboundTransactionId,
  'occurredOn': ?instance.occurredOn,
  'originFinancialAccountId': ?instance.originFinancialAccountId,
  'outboundAmount': ?instance.outboundAmount,
  'outboundCurrencyCode': ?instance.outboundCurrencyCode,
  'outboundTransactionId': ?instance.outboundTransactionId,
  'rateDate': ?instance.rateDate,
};
