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
    appliedRate: !json.containsKey('appliedRate')
        ? null
        : RecordInvestmentMovementCommandOutput._read_appliedRate(
            json['appliedRate'],
          ),
    createdAt: RecordInvestmentMovementCommandOutput._read_createdAt(
      json['createdAt'],
    ),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : RecordInvestmentMovementCommandOutput._read_currencyCode(
            json['currencyCode'],
          ),
    financialAccountId: !json.containsKey('financialAccountId')
        ? null
        : RecordInvestmentMovementCommandOutput._read_financialAccountId(
            json['financialAccountId'],
          ),
    fundingAmount: !json.containsKey('fundingAmount')
        ? null
        : RecordInvestmentMovementCommandOutput._read_fundingAmount(
            json['fundingAmount'],
          ),
    fundingCurrencyCode: !json.containsKey('fundingCurrencyCode')
        ? null
        : RecordInvestmentMovementCommandOutput._read_fundingCurrencyCode(
            json['fundingCurrencyCode'],
          ),
    id: json['id'] as String?,
    investmentId: json['investmentId'] as String?,
    movementType: RecordInvestmentMovementCommandOutput._read_movementType(
      json['movementType'],
    ),
    occurredOn: json['occurredOn'] as String?,
    outboundTransactionId: !json.containsKey('outboundTransactionId')
        ? null
        : RecordInvestmentMovementCommandOutput._read_outboundTransactionId(
            json['outboundTransactionId'],
          ),
    position: json['position'] as String?,
    rateDate: !json.containsKey('rateDate')
        ? null
        : RecordInvestmentMovementCommandOutput._read_rateDate(
            json['rateDate'],
          ),
    transferId: !json.containsKey('transferId')
        ? null
        : RecordInvestmentMovementCommandOutput._read_transferId(
            json['transferId'],
          ),
    updatedAt: RecordInvestmentMovementCommandOutput._read_updatedAt(
      json['updatedAt'],
    ),
  );
}

Map<String, dynamic> _$RecordInvestmentMovementCommandOutputToJson(
  RecordInvestmentMovementCommandOutput instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  if (instance.appliedRate case final $value?)
    'appliedRate': RecordInvestmentMovementCommandOutput._write_appliedRate(
      $value,
    ),
  'createdAt': ?RecordInvestmentMovementCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  if (instance.currencyCode case final $value?)
    'currencyCode': RecordInvestmentMovementCommandOutput._write_currencyCode(
      $value,
    ),
  if (instance.financialAccountId case final $value?)
    'financialAccountId':
        RecordInvestmentMovementCommandOutput._write_financialAccountId($value),
  if (instance.fundingAmount case final $value?)
    'fundingAmount': RecordInvestmentMovementCommandOutput._write_fundingAmount(
      $value,
    ),
  if (instance.fundingCurrencyCode case final $value?)
    'fundingCurrencyCode':
        RecordInvestmentMovementCommandOutput._write_fundingCurrencyCode(
          $value,
        ),
  'id': ?instance.id,
  'investmentId': ?instance.investmentId,
  'movementType': ?RecordInvestmentMovementCommandOutput._write_movementType(
    instance.movementType,
  ),
  'occurredOn': ?instance.occurredOn,
  if (instance.outboundTransactionId case final $value?)
    'outboundTransactionId':
        RecordInvestmentMovementCommandOutput._write_outboundTransactionId(
          $value,
        ),
  'position': ?instance.position,
  if (instance.rateDate case final $value?)
    'rateDate': RecordInvestmentMovementCommandOutput._write_rateDate($value),
  if (instance.transferId case final $value?)
    'transferId': RecordInvestmentMovementCommandOutput._write_transferId(
      $value,
    ),
  'updatedAt': ?RecordInvestmentMovementCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};
