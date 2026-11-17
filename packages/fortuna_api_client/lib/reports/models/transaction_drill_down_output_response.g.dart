// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_drill_down_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionDrillDownOutput$Response
_$TransactionDrillDownOutput$ResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'buckets',
      'dimension',
      'mayDifferFromChart',
      'mode',
      'pageNumber',
      'pageSize',
      'sourceDimension',
      'totalItems',
      'totalPages',
      'transaction',
      'transactions',
    ],
    disallowNullValues: const [
      'mayDifferFromChart',
      'pageNumber',
      'pageSize',
      'totalItems',
      'totalPages',
    ],
  );
  return TransactionDrillDownOutput$Response(
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
    pageNumber: TransactionDrillDownOutput$Response._read_pageNumber(
      json['pageNumber'],
    ),
    pageSize: TransactionDrillDownOutput$Response._read_pageSize(
      json['pageSize'],
    ),
    sourceDimension: json['sourceDimension'] as String?,
    totalItems: TransactionDrillDownOutput$Response._read_totalItems(
      json['totalItems'],
    ),
    totalPages: TransactionDrillDownOutput$Response._read_totalPages(
      json['totalPages'],
    ),
    transaction: json['transaction'] == null
        ? null
        : TransactionOutput.fromJson(
            json['transaction'] as Map<String, dynamic>,
          ),
    transactions: (json['transactions'] as List<dynamic>?)
        ?.map((e) => TransactionOutput.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$TransactionDrillDownOutput$ResponseToJson(
  TransactionDrillDownOutput$Response instance,
) => <String, dynamic>{
  'buckets': ?instance.buckets?.map((e) => e.toJson()).toList(),
  'dimension': ?instance.dimension,
  'mayDifferFromChart': ?instance.mayDifferFromChart,
  'mode': ?instance.mode,
  'pageNumber': ?TransactionDrillDownOutput$Response._write_pageNumber(
    instance.pageNumber,
  ),
  'pageSize': ?TransactionDrillDownOutput$Response._write_pageSize(
    instance.pageSize,
  ),
  'sourceDimension': ?instance.sourceDimension,
  'totalItems': ?TransactionDrillDownOutput$Response._write_totalItems(
    instance.totalItems,
  ),
  'totalPages': ?TransactionDrillDownOutput$Response._write_totalPages(
    instance.totalPages,
  ),
  'transaction': ?instance.transaction?.toJson(),
  'transactions': ?instance.transactions?.map((e) => e.toJson()).toList(),
};
