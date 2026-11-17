// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_job_output_paginated_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportJobOutputPaginatedOutput$Response
_$ImportJobOutputPaginatedOutput$ResponseFromJson(Map<String, dynamic> json) {
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
  return ImportJobOutputPaginatedOutput$Response(
    data: !json.containsKey('data')
        ? null
        : ImportJobOutputPaginatedOutput$Response._read_data(json['data']),
    errors: !json.containsKey('errors')
        ? null
        : ImportJobOutputPaginatedOutput$Response._read_errors(json['errors']),
    hasNextPage: json['hasNextPage'] as bool?,
    messages: !json.containsKey('messages')
        ? null
        : ImportJobOutputPaginatedOutput$Response._read_messages(
            json['messages'],
          ),
    nextPageToken: !json.containsKey('nextPageToken')
        ? null
        : ImportJobOutputPaginatedOutput$Response._read_nextPageToken(
            json['nextPageToken'],
          ),
    pageNumber: ImportJobOutputPaginatedOutput$Response._read_pageNumber(
      json['pageNumber'],
    ),
    pageSize: ImportJobOutputPaginatedOutput$Response._read_pageSize(
      json['pageSize'],
    ),
    success: json['success'] as bool?,
    timestamp: ImportJobOutputPaginatedOutput$Response._read_timestamp(
      json['timestamp'],
    ),
    totalItems: ImportJobOutputPaginatedOutput$Response._read_totalItems(
      json['totalItems'],
    ),
    totalPages: ImportJobOutputPaginatedOutput$Response._read_totalPages(
      json['totalPages'],
    ),
  );
}

Map<String, dynamic> _$ImportJobOutputPaginatedOutput$ResponseToJson(
  ImportJobOutputPaginatedOutput$Response instance,
) => <String, dynamic>{
  if (instance.data case final $value?)
    'data': ImportJobOutputPaginatedOutput$Response._write_data($value),
  if (instance.errors case final $value?)
    'errors': ImportJobOutputPaginatedOutput$Response._write_errors($value),
  'hasNextPage': ?instance.hasNextPage,
  if (instance.messages case final $value?)
    'messages': ImportJobOutputPaginatedOutput$Response._write_messages($value),
  if (instance.nextPageToken case final $value?)
    'nextPageToken':
        ImportJobOutputPaginatedOutput$Response._write_nextPageToken($value),
  'pageNumber': ?ImportJobOutputPaginatedOutput$Response._write_pageNumber(
    instance.pageNumber,
  ),
  'pageSize': ?ImportJobOutputPaginatedOutput$Response._write_pageSize(
    instance.pageSize,
  ),
  'success': ?instance.success,
  'timestamp': ?ImportJobOutputPaginatedOutput$Response._write_timestamp(
    instance.timestamp,
  ),
  'totalItems': ?ImportJobOutputPaginatedOutput$Response._write_totalItems(
    instance.totalItems,
  ),
  'totalPages': ?ImportJobOutputPaginatedOutput$Response._write_totalPages(
    instance.totalPages,
  ),
};
