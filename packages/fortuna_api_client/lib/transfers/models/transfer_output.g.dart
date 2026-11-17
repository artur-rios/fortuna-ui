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
    appliedRate: json['appliedRate'] as String?,
    createdAt: TransferOutput._read_createdAt(json['createdAt']),
    destinationCreditCardId: json['destinationCreditCardId'] as String?,
    destinationFinancialAccountId:
        json['destinationFinancialAccountId'] as String?,
    destinationInvestmentId: json['destinationInvestmentId'] as String?,
    destinationStatementId: json['destinationStatementId'] as String?,
    id: json['id'] as String?,
    inboundAmount: json['inboundAmount'] as String?,
    inboundCurrencyCode: json['inboundCurrencyCode'] as String?,
    inboundInvestmentMovementId: json['inboundInvestmentMovementId'] as String?,
    inboundIsDeleted: json['inboundIsDeleted'] as bool?,
    inboundTransactionId: json['inboundTransactionId'] as String?,
    isDeleted: json['isDeleted'] as bool?,
    occurredOn: json['occurredOn'] as String?,
    originFinancialAccountId: json['originFinancialAccountId'] as String?,
    outboundAmount: json['outboundAmount'] as String?,
    outboundCurrencyCode: json['outboundCurrencyCode'] as String?,
    outboundIsDeleted: json['outboundIsDeleted'] as bool?,
    outboundTransactionId: json['outboundTransactionId'] as String?,
    rateDate: json['rateDate'] as String?,
    updatedAt: TransferOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$TransferOutputToJson(TransferOutput instance) =>
    <String, dynamic>{
      'appliedRate': ?instance.appliedRate,
      'createdAt': ?TransferOutput._write_createdAt(instance.createdAt),
      'destinationCreditCardId': ?instance.destinationCreditCardId,
      'destinationFinancialAccountId': ?instance.destinationFinancialAccountId,
      'destinationInvestmentId': ?instance.destinationInvestmentId,
      'destinationStatementId': ?instance.destinationStatementId,
      'id': ?instance.id,
      'inboundAmount': ?instance.inboundAmount,
      'inboundCurrencyCode': ?instance.inboundCurrencyCode,
      'inboundInvestmentMovementId': ?instance.inboundInvestmentMovementId,
      'inboundIsDeleted': ?instance.inboundIsDeleted,
      'inboundTransactionId': ?instance.inboundTransactionId,
      'isDeleted': ?instance.isDeleted,
      'occurredOn': ?instance.occurredOn,
      'originFinancialAccountId': ?instance.originFinancialAccountId,
      'outboundAmount': ?instance.outboundAmount,
      'outboundCurrencyCode': ?instance.outboundCurrencyCode,
      'outboundIsDeleted': ?instance.outboundIsDeleted,
      'outboundTransactionId': ?instance.outboundTransactionId,
      'rateDate': ?instance.rateDate,
      'updatedAt': ?TransferOutput._write_updatedAt(instance.updatedAt),
    };
