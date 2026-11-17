// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_transaction_output_paginated_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecurringTransactionOutputPaginatedOutput$Request
_$RecurringTransactionOutputPaginatedOutput$RequestFromJson(
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
  return RecurringTransactionOutputPaginatedOutput$Request(
    data: !json.containsKey('data')
        ? null
        : RecurringTransactionOutputPaginatedOutput$Request._read_data(
            json['data'],
          ),
    errors: !json.containsKey('errors')
        ? null
        : RecurringTransactionOutputPaginatedOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RecurringTransactionOutputPaginatedOutput$Request._read_messages(
            json['messages'],
          ),
    nextPageToken: !json.containsKey('nextPageToken')
        ? null
        : RecurringTransactionOutputPaginatedOutput$Request._read_nextPageToken(
            json['nextPageToken'],
          ),
    pageNumber:
        RecurringTransactionOutputPaginatedOutput$Request._read_pageNumber(
          json['pageNumber'],
        ),
    pageSize: RecurringTransactionOutputPaginatedOutput$Request._read_pageSize(
      json['pageSize'],
    ),
    timestamp:
        RecurringTransactionOutputPaginatedOutput$Request._read_timestamp(
          json['timestamp'],
        ),
    totalItems:
        RecurringTransactionOutputPaginatedOutput$Request._read_totalItems(
          json['totalItems'],
        ),
  );
}

Map<String, dynamic> _$RecurringTransactionOutputPaginatedOutput$RequestToJson(
  RecurringTransactionOutputPaginatedOutput$Request instance,
) => <String, dynamic>{
  if (instance.data case final $value?)
    'data': RecurringTransactionOutputPaginatedOutput$Request._write_data(
      $value,
    ),
  if (instance.errors case final $value?)
    'errors': RecurringTransactionOutputPaginatedOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages':
        RecurringTransactionOutputPaginatedOutput$Request._write_messages(
          $value,
        ),
  if (instance.nextPageToken case final $value?)
    'nextPageToken':
        RecurringTransactionOutputPaginatedOutput$Request._write_nextPageToken(
          $value,
        ),
  'pageNumber':
      ?RecurringTransactionOutputPaginatedOutput$Request._write_pageNumber(
        instance.pageNumber,
      ),
  'pageSize':
      ?RecurringTransactionOutputPaginatedOutput$Request._write_pageSize(
        instance.pageSize,
      ),
  'timestamp':
      ?RecurringTransactionOutputPaginatedOutput$Request._write_timestamp(
        instance.timestamp,
      ),
  'totalItems':
      ?RecurringTransactionOutputPaginatedOutput$Request._write_totalItems(
        instance.totalItems,
      ),
};
