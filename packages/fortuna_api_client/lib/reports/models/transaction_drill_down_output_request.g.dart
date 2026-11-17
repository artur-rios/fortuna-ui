// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_drill_down_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionDrillDownOutput$Request _$TransactionDrillDownOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
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
      'transaction',
      'transactions',
    ],
    disallowNullValues: const [
      'mayDifferFromChart',
      'pageNumber',
      'pageSize',
      'totalItems',
    ],
  );
  return TransactionDrillDownOutput$Request(
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
    pageNumber: TransactionDrillDownOutput$Request._read_pageNumber(
      json['pageNumber'],
    ),
    pageSize: TransactionDrillDownOutput$Request._read_pageSize(
      json['pageSize'],
    ),
    sourceDimension: json['sourceDimension'] as String?,
    totalItems: TransactionDrillDownOutput$Request._read_totalItems(
      json['totalItems'],
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

Map<String, dynamic> _$TransactionDrillDownOutput$RequestToJson(
  TransactionDrillDownOutput$Request instance,
) => <String, dynamic>{
  'buckets': ?instance.buckets?.map((e) => e.toJson()).toList(),
  'dimension': ?instance.dimension,
  'mayDifferFromChart': ?instance.mayDifferFromChart,
  'mode': ?instance.mode,
  'pageNumber': ?TransactionDrillDownOutput$Request._write_pageNumber(
    instance.pageNumber,
  ),
  'pageSize': ?TransactionDrillDownOutput$Request._write_pageSize(
    instance.pageSize,
  ),
  'sourceDimension': ?instance.sourceDimension,
  'totalItems': ?TransactionDrillDownOutput$Request._write_totalItems(
    instance.totalItems,
  ),
  'transaction': ?instance.transaction?.toJson(),
  'transactions': ?instance.transactions?.map((e) => e.toJson()).toList(),
};
