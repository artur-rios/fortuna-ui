// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_drill_down_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionDrillDownOutput _$TransactionDrillDownOutputFromJson(
  Map<String, dynamic> json,
) => TransactionDrillDownOutput(
  buckets: (json['buckets'] as List<dynamic>?)
      ?.map(
        (e) => TransactionAggregationBucketOutput.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  dimension: json['dimension'] as String?,
  mayDifferFromChart: json['mayDifferFromChart'] as bool?,
  mode: json['mode'] as String?,
  pageNumber: (json['pageNumber'] as num?)?.toInt(),
  pageSize: (json['pageSize'] as num?)?.toInt(),
  sourceDimension: json['sourceDimension'] as String?,
  totalItems: (json['totalItems'] as num?)?.toInt(),
  totalPages: (json['totalPages'] as num?)?.toInt(),
  transaction: json['transaction'] == null
      ? null
      : TransactionOutput.fromJson(json['transaction'] as Map<String, dynamic>),
  transactions: (json['transactions'] as List<dynamic>?)
      ?.map((e) => TransactionOutput.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TransactionDrillDownOutputToJson(
  TransactionDrillDownOutput instance,
) => <String, dynamic>{
  'buckets': instance.buckets,
  'dimension': instance.dimension,
  'mayDifferFromChart': instance.mayDifferFromChart,
  'mode': instance.mode,
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
  'sourceDimension': instance.sourceDimension,
  'totalItems': instance.totalItems,
  'totalPages': instance.totalPages,
  'transaction': instance.transaction,
  'transactions': instance.transactions,
};
