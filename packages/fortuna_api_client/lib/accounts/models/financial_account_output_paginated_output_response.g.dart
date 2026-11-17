// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_account_output_paginated_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinancialAccountOutputPaginatedOutput$Response
_$FinancialAccountOutputPaginatedOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
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
  return FinancialAccountOutputPaginatedOutput$Response(
    data: !json.containsKey('data')
        ? null
        : FinancialAccountOutputPaginatedOutput$Response._read_data(
            json['data'],
          ),
    errors: !json.containsKey('errors')
        ? null
        : FinancialAccountOutputPaginatedOutput$Response._read_errors(
            json['errors'],
          ),
    hasNextPage: json['hasNextPage'] as bool?,
    messages: !json.containsKey('messages')
        ? null
        : FinancialAccountOutputPaginatedOutput$Response._read_messages(
            json['messages'],
          ),
    nextPageToken: !json.containsKey('nextPageToken')
        ? null
        : FinancialAccountOutputPaginatedOutput$Response._read_nextPageToken(
            json['nextPageToken'],
          ),
    pageNumber: FinancialAccountOutputPaginatedOutput$Response._read_pageNumber(
      json['pageNumber'],
    ),
    pageSize: FinancialAccountOutputPaginatedOutput$Response._read_pageSize(
      json['pageSize'],
    ),
    success: json['success'] as bool?,
    timestamp: FinancialAccountOutputPaginatedOutput$Response._read_timestamp(
      json['timestamp'],
    ),
    totalItems: FinancialAccountOutputPaginatedOutput$Response._read_totalItems(
      json['totalItems'],
    ),
    totalPages: FinancialAccountOutputPaginatedOutput$Response._read_totalPages(
      json['totalPages'],
    ),
  );
}

Map<String, dynamic> _$FinancialAccountOutputPaginatedOutput$ResponseToJson(
  FinancialAccountOutputPaginatedOutput$Response instance,
) => <String, dynamic>{
  if (instance.data case final $value?)
    'data': FinancialAccountOutputPaginatedOutput$Response._write_data($value),
  if (instance.errors case final $value?)
    'errors': FinancialAccountOutputPaginatedOutput$Response._write_errors(
      $value,
    ),
  'hasNextPage': ?instance.hasNextPage,
  if (instance.messages case final $value?)
    'messages': FinancialAccountOutputPaginatedOutput$Response._write_messages(
      $value,
    ),
  if (instance.nextPageToken case final $value?)
    'nextPageToken':
        FinancialAccountOutputPaginatedOutput$Response._write_nextPageToken(
          $value,
        ),
  'pageNumber':
      ?FinancialAccountOutputPaginatedOutput$Response._write_pageNumber(
        instance.pageNumber,
      ),
  'pageSize': ?FinancialAccountOutputPaginatedOutput$Response._write_pageSize(
    instance.pageSize,
  ),
  'success': ?instance.success,
  'timestamp': ?FinancialAccountOutputPaginatedOutput$Response._write_timestamp(
    instance.timestamp,
  ),
  'totalItems':
      ?FinancialAccountOutputPaginatedOutput$Response._write_totalItems(
        instance.totalItems,
      ),
  'totalPages':
      ?FinancialAccountOutputPaginatedOutput$Response._write_totalPages(
        instance.totalPages,
      ),
};
