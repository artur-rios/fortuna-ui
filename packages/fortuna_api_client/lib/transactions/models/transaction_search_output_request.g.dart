// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_search_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionSearchOutput$Request _$TransactionSearchOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'items',
      'pageNumber',
      'pageSize',
      'totalItems',
      'totals',
    ],
    disallowNullValues: const [
      'pageNumber',
      'pageSize',
      'totalItems',
      'totals',
    ],
  );
  return TransactionSearchOutput$Request(
    items: (json['items'] as List<dynamic>?)
        ?.map((e) => TransactionOutput.fromJson(e as Map<String, dynamic>))
        .toList(),
    pageNumber: TransactionSearchOutput$Request._read_pageNumber(
      json['pageNumber'],
    ),
    pageSize: TransactionSearchOutput$Request._read_pageSize(json['pageSize']),
    totalItems: TransactionSearchOutput$Request._read_totalItems(
      json['totalItems'],
    ),
    totals: json['totals'] == null
        ? null
        : TransactionTotalsOutput$Request.fromJson(
            json['totals'] as Map<String, dynamic>,
          ),
  );
}

Map<String, dynamic> _$TransactionSearchOutput$RequestToJson(
  TransactionSearchOutput$Request instance,
) => <String, dynamic>{
  'items': ?instance.items?.map((e) => e.toJson()).toList(),
  'pageNumber': ?TransactionSearchOutput$Request._write_pageNumber(
    instance.pageNumber,
  ),
  'pageSize': ?TransactionSearchOutput$Request._write_pageSize(
    instance.pageSize,
  ),
  'totalItems': ?TransactionSearchOutput$Request._write_totalItems(
    instance.totalItems,
  ),
  'totals': ?instance.totals?.toJson(),
};
