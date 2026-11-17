// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_investment_valuation_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordInvestmentValuationCommandOutput
_$RecordInvestmentValuationCommandOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'createdAt',
      'currencyCode',
      'id',
      'investmentId',
      'isIndependentlyValued',
      'latestValuationDate',
      'latestValuationValue',
      'position',
      'replacedExisting',
      'updatedAt',
      'value',
      'valuedOn',
    ],
    disallowNullValues: const [
      'createdAt',
      'id',
      'investmentId',
      'isIndependentlyValued',
      'position',
      'replacedExisting',
      'updatedAt',
      'value',
      'valuedOn',
    ],
  );
  return RecordInvestmentValuationCommandOutput(
    createdAt: RecordInvestmentValuationCommandOutput._read_createdAt(
      json['createdAt'],
    ),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : RecordInvestmentValuationCommandOutput._read_currencyCode(
            json['currencyCode'],
          ),
    id: json['id'] as String?,
    investmentId: json['investmentId'] as String?,
    isIndependentlyValued: json['isIndependentlyValued'] as bool?,
    latestValuationDate: !json.containsKey('latestValuationDate')
        ? null
        : RecordInvestmentValuationCommandOutput._read_latestValuationDate(
            json['latestValuationDate'],
          ),
    latestValuationValue: !json.containsKey('latestValuationValue')
        ? null
        : RecordInvestmentValuationCommandOutput._read_latestValuationValue(
            json['latestValuationValue'],
          ),
    position: json['position'] as String?,
    replacedExisting: json['replacedExisting'] as bool?,
    updatedAt: RecordInvestmentValuationCommandOutput._read_updatedAt(
      json['updatedAt'],
    ),
    value: json['value'] as String?,
    valuedOn: json['valuedOn'] as String?,
  );
}

Map<String, dynamic> _$RecordInvestmentValuationCommandOutputToJson(
  RecordInvestmentValuationCommandOutput instance,
) => <String, dynamic>{
  'createdAt': ?RecordInvestmentValuationCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  if (instance.currencyCode case final $value?)
    'currencyCode': RecordInvestmentValuationCommandOutput._write_currencyCode(
      $value,
    ),
  'id': ?instance.id,
  'investmentId': ?instance.investmentId,
  'isIndependentlyValued': ?instance.isIndependentlyValued,
  if (instance.latestValuationDate case final $value?)
    'latestValuationDate':
        RecordInvestmentValuationCommandOutput._write_latestValuationDate(
          $value,
        ),
  if (instance.latestValuationValue case final $value?)
    'latestValuationValue':
        RecordInvestmentValuationCommandOutput._write_latestValuationValue(
          $value,
        ),
  'position': ?instance.position,
  'replacedExisting': ?instance.replacedExisting,
  'updatedAt': ?RecordInvestmentValuationCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
  'value': ?instance.value,
  'valuedOn': ?instance.valuedOn,
};
