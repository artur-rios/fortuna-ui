// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_aggregation_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionAggregationOutput _$TransactionAggregationOutputFromJson(
  Map<String, dynamic> json,
) => TransactionAggregationOutput(
  buckets: (json['buckets'] as List<dynamic>?)
      ?.map(
        (e) => TransactionAggregationBucketOutput.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  dimension: json['dimension'] as String?,
  displayCurrencyCode: json['displayCurrencyCode'] as String?,
  from: json['from'] == null ? null : DateTime.parse(json['from'] as String),
  granularity: json['granularity'] as String?,
  isFullyConverted: json['isFullyConverted'] as bool?,
  to: json['to'] == null ? null : DateTime.parse(json['to'] as String),
);

Map<String, dynamic> _$TransactionAggregationOutputToJson(
  TransactionAggregationOutput instance,
) => <String, dynamic>{
  'buckets': instance.buckets,
  'dimension': instance.dimension,
  'displayCurrencyCode': instance.displayCurrencyCode,
  'from': instance.from?.toIso8601String(),
  'granularity': instance.granularity,
  'isFullyConverted': instance.isFullyConverted,
  'to': instance.to?.toIso8601String(),
};
