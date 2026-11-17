// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_output_paginated_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCardOutputPaginatedOutput$Request
_$CreditCardOutputPaginatedOutput$RequestFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'data',
      'errors',
      'messages',
      'nextPageToken',
      'pageNumber',
      'pageSize',
      'timestamp',
      'totalItems',
    ],
    disallowNullValues: const [
      'pageNumber',
      'pageSize',
      'timestamp',
      'totalItems',
    ],
  );
  return CreditCardOutputPaginatedOutput$Request(
    data: (json['data'] as List<dynamic>?)
        ?.map((e) => CreditCardOutput.fromJson(e as Map<String, dynamic>))
        .toList(),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    nextPageToken: json['nextPageToken'] as String?,
    pageNumber: CreditCardOutputPaginatedOutput$Request._read_pageNumber(
      json['pageNumber'],
    ),
    pageSize: CreditCardOutputPaginatedOutput$Request._read_pageSize(
      json['pageSize'],
    ),
    timestamp: CreditCardOutputPaginatedOutput$Request._read_timestamp(
      json['timestamp'],
    ),
    totalItems: CreditCardOutputPaginatedOutput$Request._read_totalItems(
      json['totalItems'],
    ),
  );
}

Map<String, dynamic> _$CreditCardOutputPaginatedOutput$RequestToJson(
  CreditCardOutputPaginatedOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.map((e) => e.toJson()).toList(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'nextPageToken': ?instance.nextPageToken,
  'pageNumber': ?CreditCardOutputPaginatedOutput$Request._write_pageNumber(
    instance.pageNumber,
  ),
  'pageSize': ?CreditCardOutputPaginatedOutput$Request._write_pageSize(
    instance.pageSize,
  ),
  'timestamp': ?CreditCardOutputPaginatedOutput$Request._write_timestamp(
    instance.timestamp,
  ),
  'totalItems': ?CreditCardOutputPaginatedOutput$Request._write_totalItems(
    instance.totalItems,
  ),
};
