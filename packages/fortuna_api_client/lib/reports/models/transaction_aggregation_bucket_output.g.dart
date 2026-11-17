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
    conversions: !json.containsKey('conversions')
        ? null
        : TransactionAggregationBucketOutput._read_conversions(
            json['conversions'],
          ),
    drillDownKey: !json.containsKey('drillDownKey')
        ? null
        : TransactionAggregationBucketOutput._read_drillDownKey(
            json['drillDownKey'],
          ),
    isFullyConverted: json['isFullyConverted'] as bool?,
    label: !json.containsKey('label')
        ? null
        : TransactionAggregationBucketOutput._read_label(json['label']),
    periodEnd: !json.containsKey('periodEnd')
        ? null
        : TransactionAggregationBucketOutput._read_periodEnd(json['periodEnd']),
    periodStart: !json.containsKey('periodStart')
        ? null
        : TransactionAggregationBucketOutput._read_periodStart(
            json['periodStart'],
          ),
    share: !json.containsKey('share')
        ? null
        : TransactionAggregationBucketOutput._read_share(json['share']),
    total: !json.containsKey('total')
        ? null
        : TransactionAggregationBucketOutput._read_total(json['total']),
  );
}

Map<String, dynamic> _$TransactionAggregationBucketOutputToJson(
  TransactionAggregationBucketOutput instance,
) => <String, dynamic>{
  if (instance.conversions case final $value?)
    'conversions': TransactionAggregationBucketOutput._write_conversions(
      $value,
    ),
  if (instance.drillDownKey case final $value?)
    'drillDownKey': TransactionAggregationBucketOutput._write_drillDownKey(
      $value,
    ),
  'isFullyConverted': ?instance.isFullyConverted,
  if (instance.label case final $value?)
    'label': TransactionAggregationBucketOutput._write_label($value),
  if (instance.periodEnd case final $value?)
    'periodEnd': TransactionAggregationBucketOutput._write_periodEnd($value),
  if (instance.periodStart case final $value?)
    'periodStart': TransactionAggregationBucketOutput._write_periodStart(
      $value,
    ),
  if (instance.share case final $value?)
    'share': TransactionAggregationBucketOutput._write_share($value),
  if (instance.total case final $value?)
    'total': TransactionAggregationBucketOutput._write_total($value),
};
