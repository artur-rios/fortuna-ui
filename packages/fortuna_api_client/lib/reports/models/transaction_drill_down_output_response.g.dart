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
      'transaction',
    ],
  );
  return TransactionDrillDownOutput$Response(
    buckets: !json.containsKey('buckets')
        ? null
        : TransactionDrillDownOutput$Response._read_buckets(json['buckets']),
    dimension: !json.containsKey('dimension')
        ? null
        : TransactionDrillDownOutput$Response._read_dimension(
            json['dimension'],
          ),
    mayDifferFromChart: json['mayDifferFromChart'] as bool?,
    mode: !json.containsKey('mode')
        ? null
        : TransactionDrillDownOutput$Response._read_mode(json['mode']),
    pageNumber: TransactionDrillDownOutput$Response._read_pageNumber(
      json['pageNumber'],
    ),
    pageSize: TransactionDrillDownOutput$Response._read_pageSize(
      json['pageSize'],
    ),
    sourceDimension: !json.containsKey('sourceDimension')
        ? null
        : TransactionDrillDownOutput$Response._read_sourceDimension(
            json['sourceDimension'],
          ),
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
    transactions: !json.containsKey('transactions')
        ? null
        : TransactionDrillDownOutput$Response._read_transactions(
            json['transactions'],
          ),
  );
}

Map<String, dynamic> _$TransactionDrillDownOutput$ResponseToJson(
  TransactionDrillDownOutput$Response instance,
) => <String, dynamic>{
  if (instance.buckets case final $value?)
    'buckets': TransactionDrillDownOutput$Response._write_buckets($value),
  if (instance.dimension case final $value?)
    'dimension': TransactionDrillDownOutput$Response._write_dimension($value),
  'mayDifferFromChart': ?instance.mayDifferFromChart,
  if (instance.mode case final $value?)
    'mode': TransactionDrillDownOutput$Response._write_mode($value),
  'pageNumber': ?TransactionDrillDownOutput$Response._write_pageNumber(
    instance.pageNumber,
  ),
  'pageSize': ?TransactionDrillDownOutput$Response._write_pageSize(
    instance.pageSize,
  ),
  if (instance.sourceDimension case final $value?)
    'sourceDimension':
        TransactionDrillDownOutput$Response._write_sourceDimension($value),
  'totalItems': ?TransactionDrillDownOutput$Response._write_totalItems(
    instance.totalItems,
  ),
  'totalPages': ?TransactionDrillDownOutput$Response._write_totalPages(
    instance.totalPages,
  ),
  'transaction': ?instance.transaction?.toJson(),
  if (instance.transactions case final $value?)
    'transactions': TransactionDrillDownOutput$Response._write_transactions(
      $value,
    ),
};
