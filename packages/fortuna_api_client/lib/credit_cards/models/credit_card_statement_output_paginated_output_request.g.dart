// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_statement_output_paginated_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCardStatementOutputPaginatedOutput$Request
_$CreditCardStatementOutputPaginatedOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
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
  return CreditCardStatementOutputPaginatedOutput$Request(
    data: !json.containsKey('data')
        ? null
        : CreditCardStatementOutputPaginatedOutput$Request._read_data(
            json['data'],
          ),
    errors: !json.containsKey('errors')
        ? null
        : CreditCardStatementOutputPaginatedOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : CreditCardStatementOutputPaginatedOutput$Request._read_messages(
            json['messages'],
          ),
    nextPageToken: !json.containsKey('nextPageToken')
        ? null
        : CreditCardStatementOutputPaginatedOutput$Request._read_nextPageToken(
            json['nextPageToken'],
          ),
    pageNumber:
        CreditCardStatementOutputPaginatedOutput$Request._read_pageNumber(
          json['pageNumber'],
        ),
    pageSize: CreditCardStatementOutputPaginatedOutput$Request._read_pageSize(
      json['pageSize'],
    ),
    timestamp: CreditCardStatementOutputPaginatedOutput$Request._read_timestamp(
      json['timestamp'],
    ),
    totalItems:
        CreditCardStatementOutputPaginatedOutput$Request._read_totalItems(
          json['totalItems'],
        ),
  );
}

Map<String, dynamic> _$CreditCardStatementOutputPaginatedOutput$RequestToJson(
  CreditCardStatementOutputPaginatedOutput$Request instance,
) => <String, dynamic>{
  if (instance.data case final $value?)
    'data': CreditCardStatementOutputPaginatedOutput$Request._write_data(
      $value,
    ),
  if (instance.errors case final $value?)
    'errors': CreditCardStatementOutputPaginatedOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages':
        CreditCardStatementOutputPaginatedOutput$Request._write_messages(
          $value,
        ),
  if (instance.nextPageToken case final $value?)
    'nextPageToken':
        CreditCardStatementOutputPaginatedOutput$Request._write_nextPageToken(
          $value,
        ),
  'pageNumber':
      ?CreditCardStatementOutputPaginatedOutput$Request._write_pageNumber(
        instance.pageNumber,
      ),
  'pageSize': ?CreditCardStatementOutputPaginatedOutput$Request._write_pageSize(
    instance.pageSize,
  ),
  'timestamp':
      ?CreditCardStatementOutputPaginatedOutput$Request._write_timestamp(
        instance.timestamp,
      ),
  'totalItems':
      ?CreditCardStatementOutputPaginatedOutput$Request._write_totalItems(
        instance.totalItems,
      ),
};
