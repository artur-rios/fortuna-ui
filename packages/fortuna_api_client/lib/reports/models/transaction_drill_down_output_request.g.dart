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
      'transaction',
    ],
  );
  return TransactionDrillDownOutput$Request(
    buckets: !json.containsKey('buckets')
        ? null
        : TransactionDrillDownOutput$Request._read_buckets(json['buckets']),
    dimension: !json.containsKey('dimension')
        ? null
        : TransactionDrillDownOutput$Request._read_dimension(json['dimension']),
    mayDifferFromChart: json['mayDifferFromChart'] as bool?,
    mode: !json.containsKey('mode')
        ? null
        : TransactionDrillDownOutput$Request._read_mode(json['mode']),
    pageNumber: TransactionDrillDownOutput$Request._read_pageNumber(
      json['pageNumber'],
    ),
    pageSize: TransactionDrillDownOutput$Request._read_pageSize(
      json['pageSize'],
    ),
    sourceDimension: !json.containsKey('sourceDimension')
        ? null
        : TransactionDrillDownOutput$Request._read_sourceDimension(
            json['sourceDimension'],
          ),
    totalItems: TransactionDrillDownOutput$Request._read_totalItems(
      json['totalItems'],
    ),
    transaction: json['transaction'] == null
        ? null
        : TransactionOutput.fromJson(
            json['transaction'] as Map<String, dynamic>,
          ),
    transactions: !json.containsKey('transactions')
        ? null
        : TransactionDrillDownOutput$Request._read_transactions(
            json['transactions'],
          ),
  );
}

Map<String, dynamic> _$TransactionDrillDownOutput$RequestToJson(
  TransactionDrillDownOutput$Request instance,
) => <String, dynamic>{
  if (instance.buckets case final $value?)
    'buckets': TransactionDrillDownOutput$Request._write_buckets($value),
  if (instance.dimension case final $value?)
    'dimension': TransactionDrillDownOutput$Request._write_dimension($value),
  'mayDifferFromChart': ?instance.mayDifferFromChart,
  if (instance.mode case final $value?)
    'mode': TransactionDrillDownOutput$Request._write_mode($value),
  'pageNumber': ?TransactionDrillDownOutput$Request._write_pageNumber(
    instance.pageNumber,
  ),
  'pageSize': ?TransactionDrillDownOutput$Request._write_pageSize(
    instance.pageSize,
  ),
  if (instance.sourceDimension case final $value?)
    'sourceDimension':
        TransactionDrillDownOutput$Request._write_sourceDimension($value),
  'totalItems': ?TransactionDrillDownOutput$Request._write_totalItems(
    instance.totalItems,
  ),
  'transaction': ?instance.transaction?.toJson(),
  if (instance.transactions case final $value?)
    'transactions': TransactionDrillDownOutput$Request._write_transactions(
      $value,
    ),
};
