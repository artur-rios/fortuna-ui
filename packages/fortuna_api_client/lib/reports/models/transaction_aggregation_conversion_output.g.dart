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
    disallowNullValues: const ['figureDate', 'rateSource', 'sourceAmount'],
  );
  return TransactionAggregationConversionOutput(
    appliedRate: !json.containsKey('appliedRate')
        ? null
        : TransactionAggregationConversionOutput._read_appliedRate(
            json['appliedRate'],
          ),
    displayAmount: !json.containsKey('displayAmount')
        ? null
        : TransactionAggregationConversionOutput._read_displayAmount(
            json['displayAmount'],
          ),
    figureDate: json['figureDate'] as String?,
    rateDate: !json.containsKey('rateDate')
        ? null
        : TransactionAggregationConversionOutput._read_rateDate(
            json['rateDate'],
          ),
    rateSource: TransactionAggregationConversionOutput._read_rateSource(
      json['rateSource'],
    ),
    sourceAmount: json['sourceAmount'] as String?,
    sourceCurrencyCode: !json.containsKey('sourceCurrencyCode')
        ? null
        : TransactionAggregationConversionOutput._read_sourceCurrencyCode(
            json['sourceCurrencyCode'],
          ),
    unconvertedReason: !json.containsKey('unconvertedReason')
        ? null
        : TransactionAggregationConversionOutput._read_unconvertedReason(
            json['unconvertedReason'],
          ),
  );
}

Map<String, dynamic> _$TransactionAggregationConversionOutputToJson(
  TransactionAggregationConversionOutput instance,
) => <String, dynamic>{
  if (instance.appliedRate case final $value?)
    'appliedRate': TransactionAggregationConversionOutput._write_appliedRate(
      $value,
    ),
  if (instance.displayAmount case final $value?)
    'displayAmount':
        TransactionAggregationConversionOutput._write_displayAmount($value),
  'figureDate': ?instance.figureDate,
  if (instance.rateDate case final $value?)
    'rateDate': TransactionAggregationConversionOutput._write_rateDate($value),
  'rateSource': ?TransactionAggregationConversionOutput._write_rateSource(
    instance.rateSource,
  ),
  'sourceAmount': ?instance.sourceAmount,
  if (instance.sourceCurrencyCode case final $value?)
    'sourceCurrencyCode':
        TransactionAggregationConversionOutput._write_sourceCurrencyCode(
          $value,
        ),
  if (instance.unconvertedReason case final $value?)
    'unconvertedReason':
        TransactionAggregationConversionOutput._write_unconvertedReason($value),
};
