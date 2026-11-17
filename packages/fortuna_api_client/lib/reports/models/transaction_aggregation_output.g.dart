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
    buckets: (json['buckets'] as List<dynamic>?)
        ?.map(
          (e) => TransactionAggregationBucketOutput.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList(),
    dimension: json['dimension'] as String?,
    displayCurrencyCode: json['displayCurrencyCode'] as String?,
    from: json['from'] as String?,
    granularity: json['granularity'] as String?,
    isFullyConverted: json['isFullyConverted'] as bool?,
    missingRates: (json['missingRates'] as List<dynamic>?)
        ?.map(
          (e) => MissingExchangeRateOutput.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
    to: json['to'] as String?,
  );
}

Map<String, dynamic> _$TransactionAggregationOutputToJson(
  TransactionAggregationOutput instance,
) => <String, dynamic>{
  'buckets': ?instance.buckets?.map((e) => e.toJson()).toList(),
  'dimension': ?instance.dimension,
  'displayCurrencyCode': ?instance.displayCurrencyCode,
  'from': ?instance.from,
  'granularity': ?instance.granularity,
  'isFullyConverted': ?instance.isFullyConverted,
  'missingRates': ?instance.missingRates?.map((e) => e.toJson()).toList(),
  'to': ?instance.to,
};
