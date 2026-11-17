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
    appliedRate: !json.containsKey('appliedRate')
        ? null
        : RecordTransferCommandOutput._read_appliedRate(json['appliedRate']),
    createdAt: RecordTransferCommandOutput._read_createdAt(json['createdAt']),
    destinationFinancialAccountId:
        !json.containsKey('destinationFinancialAccountId')
        ? null
        : RecordTransferCommandOutput._read_destinationFinancialAccountId(
            json['destinationFinancialAccountId'],
          ),
    destinationStatementId: !json.containsKey('destinationStatementId')
        ? null
        : RecordTransferCommandOutput._read_destinationStatementId(
            json['destinationStatementId'],
          ),
    id: json['id'] as String?,
    inboundAmount: json['inboundAmount'] as String?,
    inboundCurrencyCode: !json.containsKey('inboundCurrencyCode')
        ? null
        : RecordTransferCommandOutput._read_inboundCurrencyCode(
            json['inboundCurrencyCode'],
          ),
    inboundTransactionId: json['inboundTransactionId'] as String?,
    occurredOn: json['occurredOn'] as String?,
    originFinancialAccountId: json['originFinancialAccountId'] as String?,
    outboundAmount: json['outboundAmount'] as String?,
    outboundCurrencyCode: !json.containsKey('outboundCurrencyCode')
        ? null
        : RecordTransferCommandOutput._read_outboundCurrencyCode(
            json['outboundCurrencyCode'],
          ),
    outboundTransactionId: json['outboundTransactionId'] as String?,
    rateDate: !json.containsKey('rateDate')
        ? null
        : RecordTransferCommandOutput._read_rateDate(json['rateDate']),
  );
}

Map<String, dynamic> _$RecordTransferCommandOutputToJson(
  RecordTransferCommandOutput instance,
) => <String, dynamic>{
  if (instance.appliedRate case final $value?)
    'appliedRate': RecordTransferCommandOutput._write_appliedRate($value),
  'createdAt': ?RecordTransferCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  if (instance.destinationFinancialAccountId case final $value?)
    'destinationFinancialAccountId':
        RecordTransferCommandOutput._write_destinationFinancialAccountId(
          $value,
        ),
  if (instance.destinationStatementId case final $value?)
    'destinationStatementId':
        RecordTransferCommandOutput._write_destinationStatementId($value),
  'id': ?instance.id,
  'inboundAmount': ?instance.inboundAmount,
  if (instance.inboundCurrencyCode case final $value?)
    'inboundCurrencyCode':
        RecordTransferCommandOutput._write_inboundCurrencyCode($value),
  'inboundTransactionId': ?instance.inboundTransactionId,
  'occurredOn': ?instance.occurredOn,
  'originFinancialAccountId': ?instance.originFinancialAccountId,
  'outboundAmount': ?instance.outboundAmount,
  if (instance.outboundCurrencyCode case final $value?)
    'outboundCurrencyCode':
        RecordTransferCommandOutput._write_outboundCurrencyCode($value),
  'outboundTransactionId': ?instance.outboundTransactionId,
  if (instance.rateDate case final $value?)
    'rateDate': RecordTransferCommandOutput._write_rateDate($value),
};
