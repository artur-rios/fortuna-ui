// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_aggregation_bucket_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionAggregationBucketOutput _$TransactionAggregationBucketOutputFromJson(
  Map<String, dynamic> json,
) => TransactionAggregationBucketOutput(
  conversions: (json['conversions'] as List<dynamic>?)
      ?.map(
        (e) => TransactionAggregationConversionOutput.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  drillDownKey: json['drillDownKey'] as String?,
  isFullyConverted: json['isFullyConverted'] as bool?,
  label: json['label'] as String?,
  periodEnd: json['periodEnd'] == null
      ? null
      : DateTime.parse(json['periodEnd'] as String),
  periodStart: json['periodStart'] == null
      ? null
      : DateTime.parse(json['periodStart'] as String),
  share: (json['share'] as num?)?.toDouble(),
  total: (json['total'] as num?)?.toDouble(),
);

Map<String, dynamic> _$TransactionAggregationBucketOutputToJson(
  TransactionAggregationBucketOutput instance,
) => <String, dynamic>{
  'conversions': instance.conversions,
  'drillDownKey': instance.drillDownKey,
  'isFullyConverted': instance.isFullyConverted,
  'label': instance.label,
  'periodEnd': instance.periodEnd?.toIso8601String(),
  'periodStart': instance.periodStart?.toIso8601String(),
  'share': instance.share,
  'total': instance.total,
};
