// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_output_paginated_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCardOutputPaginatedOutput$Response
_$CreditCardOutputPaginatedOutput$ResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'data',
      'errors',
      'hasNextPage',
      'messages',
      'nextPageToken',
      'pageNumber',
      'pageSize',
      'success',
      'timestamp',
      'totalItems',
      'totalPages',
    ],
    disallowNullValues: const [
      'hasNextPage',
      'pageNumber',
      'pageSize',
      'success',
      'timestamp',
      'totalItems',
      'totalPages',
    ],
  );
  return CreditCardOutputPaginatedOutput$Response(
    data: !json.containsKey('data')
        ? null
        : CreditCardOutputPaginatedOutput$Response._read_data(json['data']),
    errors: !json.containsKey('errors')
        ? null
        : CreditCardOutputPaginatedOutput$Response._read_errors(json['errors']),
    hasNextPage: json['hasNextPage'] as bool?,
    messages: !json.containsKey('messages')
        ? null
        : CreditCardOutputPaginatedOutput$Response._read_messages(
            json['messages'],
          ),
    nextPageToken: !json.containsKey('nextPageToken')
        ? null
        : CreditCardOutputPaginatedOutput$Response._read_nextPageToken(
            json['nextPageToken'],
          ),
    pageNumber: CreditCardOutputPaginatedOutput$Response._read_pageNumber(
      json['pageNumber'],
    ),
    pageSize: CreditCardOutputPaginatedOutput$Response._read_pageSize(
      json['pageSize'],
    ),
    success: json['success'] as bool?,
    timestamp: CreditCardOutputPaginatedOutput$Response._read_timestamp(
      json['timestamp'],
    ),
    totalItems: CreditCardOutputPaginatedOutput$Response._read_totalItems(
      json['totalItems'],
    ),
    totalPages: CreditCardOutputPaginatedOutput$Response._read_totalPages(
      json['totalPages'],
    ),
  );
}

Map<String, dynamic> _$CreditCardOutputPaginatedOutput$ResponseToJson(
  CreditCardOutputPaginatedOutput$Response instance,
) => <String, dynamic>{
  if (instance.data case final $value?)
    'data': CreditCardOutputPaginatedOutput$Response._write_data($value),
  if (instance.errors case final $value?)
    'errors': CreditCardOutputPaginatedOutput$Response._write_errors($value),
  'hasNextPage': ?instance.hasNextPage,
  if (instance.messages case final $value?)
    'messages': CreditCardOutputPaginatedOutput$Response._write_messages(
      $value,
    ),
  if (instance.nextPageToken case final $value?)
    'nextPageToken':
        CreditCardOutputPaginatedOutput$Response._write_nextPageToken($value),
  'pageNumber': ?CreditCardOutputPaginatedOutput$Response._write_pageNumber(
    instance.pageNumber,
  ),
  'pageSize': ?CreditCardOutputPaginatedOutput$Response._write_pageSize(
    instance.pageSize,
  ),
  'success': ?instance.success,
  'timestamp': ?CreditCardOutputPaginatedOutput$Response._write_timestamp(
    instance.timestamp,
  ),
  'totalItems': ?CreditCardOutputPaginatedOutput$Response._write_totalItems(
    instance.totalItems,
  ),
  'totalPages': ?CreditCardOutputPaginatedOutput$Response._write_totalPages(
    instance.totalPages,
  ),
};
