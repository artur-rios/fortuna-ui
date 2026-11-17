// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferOutput _$TransferOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'appliedRate',
      'createdAt',
      'destinationCreditCardId',
      'destinationFinancialAccountId',
      'destinationInvestmentId',
      'destinationStatementId',
      'id',
      'inboundAmount',
      'inboundCurrencyCode',
      'inboundInvestmentMovementId',
      'inboundIsDeleted',
      'inboundTransactionId',
      'isDeleted',
      'occurredOn',
      'originFinancialAccountId',
      'outboundAmount',
      'outboundCurrencyCode',
      'outboundIsDeleted',
      'outboundTransactionId',
      'rateDate',
      'updatedAt',
    ],
    disallowNullValues: const [
      'createdAt',
      'id',
      'inboundAmount',
      'inboundIsDeleted',
      'isDeleted',
      'occurredOn',
      'originFinancialAccountId',
      'outboundAmount',
      'outboundIsDeleted',
      'outboundTransactionId',
      'updatedAt',
    ],
  );
  return TransferOutput(
    appliedRate: !json.containsKey('appliedRate')
        ? null
        : TransferOutput._read_appliedRate(json['appliedRate']),
    createdAt: TransferOutput._read_createdAt(json['createdAt']),
    destinationCreditCardId: !json.containsKey('destinationCreditCardId')
        ? null
        : TransferOutput._read_destinationCreditCardId(
            json['destinationCreditCardId'],
          ),
    destinationFinancialAccountId:
        !json.containsKey('destinationFinancialAccountId')
        ? null
        : TransferOutput._read_destinationFinancialAccountId(
            json['destinationFinancialAccountId'],
          ),
    destinationInvestmentId: !json.containsKey('destinationInvestmentId')
        ? null
        : TransferOutput._read_destinationInvestmentId(
            json['destinationInvestmentId'],
          ),
    destinationStatementId: !json.containsKey('destinationStatementId')
        ? null
        : TransferOutput._read_destinationStatementId(
            json['destinationStatementId'],
          ),
    id: json['id'] as String?,
    inboundAmount: json['inboundAmount'] as String?,
    inboundCurrencyCode: !json.containsKey('inboundCurrencyCode')
        ? null
        : TransferOutput._read_inboundCurrencyCode(json['inboundCurrencyCode']),
    inboundInvestmentMovementId:
        !json.containsKey('inboundInvestmentMovementId')
        ? null
        : TransferOutput._read_inboundInvestmentMovementId(
            json['inboundInvestmentMovementId'],
          ),
    inboundIsDeleted: json['inboundIsDeleted'] as bool?,
    inboundTransactionId: !json.containsKey('inboundTransactionId')
        ? null
        : TransferOutput._read_inboundTransactionId(
            json['inboundTransactionId'],
          ),
    isDeleted: json['isDeleted'] as bool?,
    occurredOn: json['occurredOn'] as String?,
    originFinancialAccountId: json['originFinancialAccountId'] as String?,
    outboundAmount: json['outboundAmount'] as String?,
    outboundCurrencyCode: !json.containsKey('outboundCurrencyCode')
        ? null
        : TransferOutput._read_outboundCurrencyCode(
            json['outboundCurrencyCode'],
          ),
    outboundIsDeleted: json['outboundIsDeleted'] as bool?,
    outboundTransactionId: json['outboundTransactionId'] as String?,
    rateDate: !json.containsKey('rateDate')
        ? null
        : TransferOutput._read_rateDate(json['rateDate']),
    updatedAt: TransferOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$TransferOutputToJson(
  TransferOutput instance,
) => <String, dynamic>{
  if (instance.appliedRate case final $value?)
    'appliedRate': TransferOutput._write_appliedRate($value),
  'createdAt': ?TransferOutput._write_createdAt(instance.createdAt),
  if (instance.destinationCreditCardId case final $value?)
    'destinationCreditCardId': TransferOutput._write_destinationCreditCardId(
      $value,
    ),
  if (instance.destinationFinancialAccountId case final $value?)
    'destinationFinancialAccountId':
        TransferOutput._write_destinationFinancialAccountId($value),
  if (instance.destinationInvestmentId case final $value?)
    'destinationInvestmentId': TransferOutput._write_destinationInvestmentId(
      $value,
    ),
  if (instance.destinationStatementId case final $value?)
    'destinationStatementId': TransferOutput._write_destinationStatementId(
      $value,
    ),
  'id': ?instance.id,
  'inboundAmount': ?instance.inboundAmount,
  if (instance.inboundCurrencyCode case final $value?)
    'inboundCurrencyCode': TransferOutput._write_inboundCurrencyCode($value),
  if (instance.inboundInvestmentMovementId case final $value?)
    'inboundInvestmentMovementId':
        TransferOutput._write_inboundInvestmentMovementId($value),
  'inboundIsDeleted': ?instance.inboundIsDeleted,
  if (instance.inboundTransactionId case final $value?)
    'inboundTransactionId': TransferOutput._write_inboundTransactionId($value),
  'isDeleted': ?instance.isDeleted,
  'occurredOn': ?instance.occurredOn,
  'originFinancialAccountId': ?instance.originFinancialAccountId,
  'outboundAmount': ?instance.outboundAmount,
  if (instance.outboundCurrencyCode case final $value?)
    'outboundCurrencyCode': TransferOutput._write_outboundCurrencyCode($value),
  'outboundIsDeleted': ?instance.outboundIsDeleted,
  'outboundTransactionId': ?instance.outboundTransactionId,
  if (instance.rateDate case final $value?)
    'rateDate': TransferOutput._write_rateDate($value),
  'updatedAt': ?TransferOutput._write_updatedAt(instance.updatedAt),
};
