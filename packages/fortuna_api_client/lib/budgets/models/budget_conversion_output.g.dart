// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_conversion_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetConversionOutput _$BudgetConversionOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'appliedRate',
      'convertedAmount',
      'rateDate',
      'rateSource',
      'sourceAmount',
      'sourceCurrencyCode',
      'unconvertedReason',
    ],
    disallowNullValues: const ['rateSource', 'sourceAmount'],
  );
  return BudgetConversionOutput(
    appliedRate: !json.containsKey('appliedRate')
        ? null
        : BudgetConversionOutput._read_appliedRate(json['appliedRate']),
    convertedAmount: !json.containsKey('convertedAmount')
        ? null
        : BudgetConversionOutput._read_convertedAmount(json['convertedAmount']),
    rateDate: !json.containsKey('rateDate')
        ? null
        : BudgetConversionOutput._read_rateDate(json['rateDate']),
    rateSource: BudgetConversionOutput._read_rateSource(json['rateSource']),
    sourceAmount: json['sourceAmount'] as String?,
    sourceCurrencyCode: !json.containsKey('sourceCurrencyCode')
        ? null
        : BudgetConversionOutput._read_sourceCurrencyCode(
            json['sourceCurrencyCode'],
          ),
    unconvertedReason: !json.containsKey('unconvertedReason')
        ? null
        : BudgetConversionOutput._read_unconvertedReason(
            json['unconvertedReason'],
          ),
  );
}

Map<String, dynamic> _$BudgetConversionOutputToJson(
  BudgetConversionOutput instance,
) => <String, dynamic>{
  if (instance.appliedRate case final $value?)
    'appliedRate': BudgetConversionOutput._write_appliedRate($value),
  if (instance.convertedAmount case final $value?)
    'convertedAmount': BudgetConversionOutput._write_convertedAmount($value),
  if (instance.rateDate case final $value?)
    'rateDate': BudgetConversionOutput._write_rateDate($value),
  'rateSource': ?BudgetConversionOutput._write_rateSource(instance.rateSource),
  'sourceAmount': ?instance.sourceAmount,
  if (instance.sourceCurrencyCode case final $value?)
    'sourceCurrencyCode': BudgetConversionOutput._write_sourceCurrencyCode(
      $value,
    ),
  if (instance.unconvertedReason case final $value?)
    'unconvertedReason': BudgetConversionOutput._write_unconvertedReason(
      $value,
    ),
};
