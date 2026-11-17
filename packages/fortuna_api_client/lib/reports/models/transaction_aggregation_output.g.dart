// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_aggregation_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionAggregationOutput _$TransactionAggregationOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'buckets',
      'dimension',
      'displayCurrencyCode',
      'from',
      'granularity',
      'isFullyConverted',
      'missingRates',
      'to',
    ],
    disallowNullValues: const ['from', 'isFullyConverted', 'to'],
  );
  return TransactionAggregationOutput(
    buckets: !json.containsKey('buckets')
        ? null
        : TransactionAggregationOutput._read_buckets(json['buckets']),
    dimension: !json.containsKey('dimension')
        ? null
        : TransactionAggregationOutput._read_dimension(json['dimension']),
    displayCurrencyCode: !json.containsKey('displayCurrencyCode')
        ? null
        : TransactionAggregationOutput._read_displayCurrencyCode(
            json['displayCurrencyCode'],
          ),
    from: json['from'] as String?,
    granularity: !json.containsKey('granularity')
        ? null
        : TransactionAggregationOutput._read_granularity(json['granularity']),
    isFullyConverted: json['isFullyConverted'] as bool?,
    missingRates: !json.containsKey('missingRates')
        ? null
        : TransactionAggregationOutput._read_missingRates(json['missingRates']),
    to: json['to'] as String?,
  );
}

Map<String, dynamic> _$TransactionAggregationOutputToJson(
  TransactionAggregationOutput instance,
) => <String, dynamic>{
  if (instance.buckets case final $value?)
    'buckets': TransactionAggregationOutput._write_buckets($value),
  if (instance.dimension case final $value?)
    'dimension': TransactionAggregationOutput._write_dimension($value),
  if (instance.displayCurrencyCode case final $value?)
    'displayCurrencyCode':
        TransactionAggregationOutput._write_displayCurrencyCode($value),
  'from': ?instance.from,
  if (instance.granularity case final $value?)
    'granularity': TransactionAggregationOutput._write_granularity($value),
  'isFullyConverted': ?instance.isFullyConverted,
  if (instance.missingRates case final $value?)
    'missingRates': TransactionAggregationOutput._write_missingRates($value),
  'to': ?instance.to,
};
