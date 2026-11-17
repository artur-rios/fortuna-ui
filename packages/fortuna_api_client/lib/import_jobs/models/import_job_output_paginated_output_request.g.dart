// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_job_output_paginated_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportJobOutputPaginatedOutput$Request
_$ImportJobOutputPaginatedOutput$RequestFromJson(Map<String, dynamic> json) {
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
  return ImportJobOutputPaginatedOutput$Request(
    data: !json.containsKey('data')
        ? null
        : ImportJobOutputPaginatedOutput$Request._read_data(json['data']),
    errors: !json.containsKey('errors')
        ? null
        : ImportJobOutputPaginatedOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : ImportJobOutputPaginatedOutput$Request._read_messages(
            json['messages'],
          ),
    nextPageToken: !json.containsKey('nextPageToken')
        ? null
        : ImportJobOutputPaginatedOutput$Request._read_nextPageToken(
            json['nextPageToken'],
          ),
    pageNumber: ImportJobOutputPaginatedOutput$Request._read_pageNumber(
      json['pageNumber'],
    ),
    pageSize: ImportJobOutputPaginatedOutput$Request._read_pageSize(
      json['pageSize'],
    ),
    timestamp: ImportJobOutputPaginatedOutput$Request._read_timestamp(
      json['timestamp'],
    ),
    totalItems: ImportJobOutputPaginatedOutput$Request._read_totalItems(
      json['totalItems'],
    ),
  );
}

Map<String, dynamic> _$ImportJobOutputPaginatedOutput$RequestToJson(
  ImportJobOutputPaginatedOutput$Request instance,
) => <String, dynamic>{
  if (instance.data case final $value?)
    'data': ImportJobOutputPaginatedOutput$Request._write_data($value),
  if (instance.errors case final $value?)
    'errors': ImportJobOutputPaginatedOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': ImportJobOutputPaginatedOutput$Request._write_messages($value),
  if (instance.nextPageToken case final $value?)
    'nextPageToken':
        ImportJobOutputPaginatedOutput$Request._write_nextPageToken($value),
  'pageNumber': ?ImportJobOutputPaginatedOutput$Request._write_pageNumber(
    instance.pageNumber,
  ),
  'pageSize': ?ImportJobOutputPaginatedOutput$Request._write_pageSize(
    instance.pageSize,
  ),
  'timestamp': ?ImportJobOutputPaginatedOutput$Request._write_timestamp(
    instance.timestamp,
  ),
  'totalItems': ?ImportJobOutputPaginatedOutput$Request._write_totalItems(
    instance.totalItems,
  ),
};
