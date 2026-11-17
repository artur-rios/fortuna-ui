// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_account_output_paginated_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinancialAccountOutputPaginatedOutput$Request
_$FinancialAccountOutputPaginatedOutput$RequestFromJson(
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
  return FinancialAccountOutputPaginatedOutput$Request(
    data: !json.containsKey('data')
        ? null
        : FinancialAccountOutputPaginatedOutput$Request._read_data(
            json['data'],
          ),
    errors: !json.containsKey('errors')
        ? null
        : FinancialAccountOutputPaginatedOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : FinancialAccountOutputPaginatedOutput$Request._read_messages(
            json['messages'],
          ),
    nextPageToken: !json.containsKey('nextPageToken')
        ? null
        : FinancialAccountOutputPaginatedOutput$Request._read_nextPageToken(
            json['nextPageToken'],
          ),
    pageNumber: FinancialAccountOutputPaginatedOutput$Request._read_pageNumber(
      json['pageNumber'],
    ),
    pageSize: FinancialAccountOutputPaginatedOutput$Request._read_pageSize(
      json['pageSize'],
    ),
    timestamp: FinancialAccountOutputPaginatedOutput$Request._read_timestamp(
      json['timestamp'],
    ),
    totalItems: FinancialAccountOutputPaginatedOutput$Request._read_totalItems(
      json['totalItems'],
    ),
  );
}

Map<String, dynamic> _$FinancialAccountOutputPaginatedOutput$RequestToJson(
  FinancialAccountOutputPaginatedOutput$Request instance,
) => <String, dynamic>{
  if (instance.data case final $value?)
    'data': FinancialAccountOutputPaginatedOutput$Request._write_data($value),
  if (instance.errors case final $value?)
    'errors': FinancialAccountOutputPaginatedOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages': FinancialAccountOutputPaginatedOutput$Request._write_messages(
      $value,
    ),
  if (instance.nextPageToken case final $value?)
    'nextPageToken':
        FinancialAccountOutputPaginatedOutput$Request._write_nextPageToken(
          $value,
        ),
  'pageNumber':
      ?FinancialAccountOutputPaginatedOutput$Request._write_pageNumber(
        instance.pageNumber,
      ),
  'pageSize': ?FinancialAccountOutputPaginatedOutput$Request._write_pageSize(
    instance.pageSize,
  ),
  'timestamp': ?FinancialAccountOutputPaginatedOutput$Request._write_timestamp(
    instance.timestamp,
  ),
  'totalItems':
      ?FinancialAccountOutputPaginatedOutput$Request._write_totalItems(
        instance.totalItems,
      ),
};
