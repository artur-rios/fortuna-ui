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
    disallowNullValues: const ['sourceAmount'],
  );
  return BudgetConversionOutput(
    appliedRate: json['appliedRate'] as String?,
    convertedAmount: json['convertedAmount'] as String?,
    rateDate: json['rateDate'] as String?,
    rateSource: BudgetConversionOutput._read_rateSource(json['rateSource']),
    sourceAmount: json['sourceAmount'] as String?,
    sourceCurrencyCode: json['sourceCurrencyCode'] as String?,
    unconvertedReason: json['unconvertedReason'] as String?,
  );
}

Map<String, dynamic> _$BudgetConversionOutputToJson(
  BudgetConversionOutput instance,
) => <String, dynamic>{
  'appliedRate': ?instance.appliedRate,
  'convertedAmount': ?instance.convertedAmount,
  'rateDate': ?instance.rateDate,
  'rateSource': ?BudgetConversionOutput._write_rateSource(instance.rateSource),
  'sourceAmount': ?instance.sourceAmount,
  'sourceCurrencyCode': ?instance.sourceCurrencyCode,
  'unconvertedReason': ?instance.unconvertedReason,
};
