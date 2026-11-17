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
    data: !json.containsKey('data')
        ? null
        : CreditCardOutputPaginatedOutput$Request._read_data(json['data']),
    errors: !json.containsKey('errors')
        ? null
        : CreditCardOutputPaginatedOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : CreditCardOutputPaginatedOutput$Request._read_messages(
            json['messages'],
          ),
    nextPageToken: !json.containsKey('nextPageToken')
        ? null
        : CreditCardOutputPaginatedOutput$Request._read_nextPageToken(
            json['nextPageToken'],
          ),
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
  if (instance.data case final $value?)
    'data': CreditCardOutputPaginatedOutput$Request._write_data($value),
  if (instance.errors case final $value?)
    'errors': CreditCardOutputPaginatedOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': CreditCardOutputPaginatedOutput$Request._write_messages($value),
  if (instance.nextPageToken case final $value?)
    'nextPageToken':
        CreditCardOutputPaginatedOutput$Request._write_nextPageToken($value),
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
