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
    items: (json['items'] as List<dynamic>?)
        ?.map((e) => TransactionOutput.fromJson(e as Map<String, dynamic>))
        .toList(),
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
  'items': ?instance.items?.map((e) => e.toJson()).toList(),
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
