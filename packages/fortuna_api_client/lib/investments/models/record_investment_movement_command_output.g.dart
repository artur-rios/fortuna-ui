// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_investment_movement_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordInvestmentMovementCommandOutput
_$RecordInvestmentMovementCommandOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'amount',
      'appliedRate',
      'createdAt',
      'currencyCode',
      'financialAccountId',
      'fundingAmount',
      'fundingCurrencyCode',
      'id',
      'investmentId',
      'movementType',
      'occurredOn',
      'outboundTransactionId',
      'position',
      'rateDate',
      'transferId',
      'updatedAt',
    ],
    disallowNullValues: const [
      'amount',
      'createdAt',
      'id',
      'investmentId',
      'movementType',
      'occurredOn',
      'position',
      'updatedAt',
    ],
  );
  return RecordInvestmentMovementCommandOutput(
    amount: json['amount'] as String?,
    appliedRate: json['appliedRate'] as String?,
    createdAt: RecordInvestmentMovementCommandOutput._read_createdAt(
      json['createdAt'],
    ),
    currencyCode: json['currencyCode'] as String?,
    financialAccountId: json['financialAccountId'] as String?,
    fundingAmount: json['fundingAmount'] as String?,
    fundingCurrencyCode: json['fundingCurrencyCode'] as String?,
    id: json['id'] as String?,
    investmentId: json['investmentId'] as String?,
    movementType: RecordInvestmentMovementCommandOutput._read_movementType(
      json['movementType'],
    ),
    occurredOn: json['occurredOn'] as String?,
    outboundTransactionId: json['outboundTransactionId'] as String?,
    position: json['position'] as String?,
    rateDate: json['rateDate'] as String?,
    transferId: json['transferId'] as String?,
    updatedAt: RecordInvestmentMovementCommandOutput._read_updatedAt(
      json['updatedAt'],
    ),
  );
}

Map<String, dynamic> _$RecordInvestmentMovementCommandOutputToJson(
  RecordInvestmentMovementCommandOutput instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  'appliedRate': ?instance.appliedRate,
  'createdAt': ?RecordInvestmentMovementCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  'currencyCode': ?instance.currencyCode,
  'financialAccountId': ?instance.financialAccountId,
  'fundingAmount': ?instance.fundingAmount,
  'fundingCurrencyCode': ?instance.fundingCurrencyCode,
  'id': ?instance.id,
  'investmentId': ?instance.investmentId,
  'movementType': ?RecordInvestmentMovementCommandOutput._write_movementType(
    instance.movementType,
  ),
  'occurredOn': ?instance.occurredOn,
  'outboundTransactionId': ?instance.outboundTransactionId,
  'position': ?instance.position,
  'rateDate': ?instance.rateDate,
  'transferId': ?instance.transferId,
  'updatedAt': ?RecordInvestmentMovementCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};
