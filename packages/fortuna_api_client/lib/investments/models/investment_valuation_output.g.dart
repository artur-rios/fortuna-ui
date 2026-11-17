// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investment_valuation_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvestmentValuationOutput _$InvestmentValuationOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'createdAt',
      'currencyCode',
      'id',
      'investmentId',
      'updatedAt',
      'value',
      'valuedOn',
    ],
    disallowNullValues: const [
      'createdAt',
      'id',
      'investmentId',
      'updatedAt',
      'value',
      'valuedOn',
    ],
  );
  return InvestmentValuationOutput(
    createdAt: InvestmentValuationOutput._read_createdAt(json['createdAt']),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : InvestmentValuationOutput._read_currencyCode(json['currencyCode']),
    id: json['id'] as String?,
    investmentId: json['investmentId'] as String?,
    updatedAt: InvestmentValuationOutput._read_updatedAt(json['updatedAt']),
    value: json['value'] as String?,
    valuedOn: json['valuedOn'] as String?,
  );
}

Map<String, dynamic> _$InvestmentValuationOutputToJson(
  InvestmentValuationOutput instance,
) => <String, dynamic>{
  'createdAt': ?InvestmentValuationOutput._write_createdAt(instance.createdAt),
  if (instance.currencyCode case final $value?)
    'currencyCode': InvestmentValuationOutput._write_currencyCode($value),
  'id': ?instance.id,
  'investmentId': ?instance.investmentId,
  'updatedAt': ?InvestmentValuationOutput._write_updatedAt(instance.updatedAt),
  'value': ?instance.value,
  'valuedOn': ?instance.valuedOn,
};
