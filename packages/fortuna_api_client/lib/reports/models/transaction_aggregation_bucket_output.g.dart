// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_aggregation_bucket_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionAggregationBucketOutput _$TransactionAggregationBucketOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'conversions',
      'drillDownKey',
      'isFullyConverted',
      'label',
      'periodEnd',
      'periodStart',
      'share',
      'total',
    ],
    disallowNullValues: const ['isFullyConverted'],
  );
  return TransactionAggregationBucketOutput(
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
    periodEnd: json['periodEnd'] as String?,
    periodStart: json['periodStart'] as String?,
    share: json['share'] as String?,
    total: json['total'] as String?,
  );
}

Map<String, dynamic> _$TransactionAggregationBucketOutputToJson(
  TransactionAggregationBucketOutput instance,
) => <String, dynamic>{
  'conversions': ?instance.conversions?.map((e) => e.toJson()).toList(),
  'drillDownKey': ?instance.drillDownKey,
  'isFullyConverted': ?instance.isFullyConverted,
  'label': ?instance.label,
  'periodEnd': ?instance.periodEnd,
  'periodStart': ?instance.periodStart,
  'share': ?instance.share,
  'total': ?instance.total,
};
