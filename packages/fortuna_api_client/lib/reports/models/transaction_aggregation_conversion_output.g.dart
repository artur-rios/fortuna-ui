// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_aggregation_conversion_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionAggregationConversionOutput
_$TransactionAggregationConversionOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'appliedRate',
      'displayAmount',
      'figureDate',
      'rateDate',
      'rateSource',
      'sourceAmount',
      'sourceCurrencyCode',
      'unconvertedReason',
    ],
    disallowNullValues: const ['figureDate', 'sourceAmount'],
  );
  return TransactionAggregationConversionOutput(
    appliedRate: json['appliedRate'] as String?,
    displayAmount: json['displayAmount'] as String?,
    figureDate: json['figureDate'] as String?,
    rateDate: json['rateDate'] as String?,
    rateSource: TransactionAggregationConversionOutput._read_rateSource(
      json['rateSource'],
    ),
    sourceAmount: json['sourceAmount'] as String?,
    sourceCurrencyCode: json['sourceCurrencyCode'] as String?,
    unconvertedReason: json['unconvertedReason'] as String?,
  );
}

Map<String, dynamic> _$TransactionAggregationConversionOutputToJson(
  TransactionAggregationConversionOutput instance,
) => <String, dynamic>{
  'appliedRate': ?instance.appliedRate,
  'displayAmount': ?instance.displayAmount,
  'figureDate': ?instance.figureDate,
  'rateDate': ?instance.rateDate,
  'rateSource': ?TransactionAggregationConversionOutput._write_rateSource(
    instance.rateSource,
  ),
  'sourceAmount': ?instance.sourceAmount,
  'sourceCurrencyCode': ?instance.sourceCurrencyCode,
  'unconvertedReason': ?instance.unconvertedReason,
};
