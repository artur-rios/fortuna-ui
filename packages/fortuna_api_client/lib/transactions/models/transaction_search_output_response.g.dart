// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_search_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionSearchOutput$Response _$TransactionSearchOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'items',
      'pageNumber',
      'pageSize',
      'totalItems',
      'totalPages',
      'totals',
    ],
    disallowNullValues: const [
      'pageNumber',
      'pageSize',
      'totalItems',
      'totalPages',
      'totals',
    ],
  );
  return TransactionSearchOutput$Response(
    items: !json.containsKey('items')
        ? null
        : TransactionSearchOutput$Response._read_items(json['items']),
    pageNumber: TransactionSearchOutput$Response._read_pageNumber(
      json['pageNumber'],
    ),
    pageSize: TransactionSearchOutput$Response._read_pageSize(json['pageSize']),
    totalItems: TransactionSearchOutput$Response._read_totalItems(
      json['totalItems'],
    ),
    totalPages: TransactionSearchOutput$Response._read_totalPages(
      json['totalPages'],
    ),
    totals: json['totals'] == null
        ? null
        : TransactionTotalsOutput$Response.fromJson(
            json['totals'] as Map<String, dynamic>,
          ),
  );
}

Map<String, dynamic> _$TransactionSearchOutput$ResponseToJson(
  TransactionSearchOutput$Response instance,
) => <String, dynamic>{
  if (instance.items case final $value?)
    'items': TransactionSearchOutput$Response._write_items($value),
  'pageNumber': ?TransactionSearchOutput$Response._write_pageNumber(
    instance.pageNumber,
  ),
  'pageSize': ?TransactionSearchOutput$Response._write_pageSize(
    instance.pageSize,
  ),
  'totalItems': ?TransactionSearchOutput$Response._write_totalItems(
    instance.totalItems,
  ),
  'totalPages': ?TransactionSearchOutput$Response._write_totalPages(
    instance.totalPages,
  ),
  'totals': ?instance.totals?.toJson(),
};
