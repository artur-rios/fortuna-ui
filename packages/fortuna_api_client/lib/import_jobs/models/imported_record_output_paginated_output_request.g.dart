// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imported_record_output_paginated_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportedRecordOutputPaginatedOutput$Request
_$ImportedRecordOutputPaginatedOutput$RequestFromJson(
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
  return ImportedRecordOutputPaginatedOutput$Request(
    data: !json.containsKey('data')
        ? null
        : ImportedRecordOutputPaginatedOutput$Request._read_data(json['data']),
    errors: !json.containsKey('errors')
        ? null
        : ImportedRecordOutputPaginatedOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : ImportedRecordOutputPaginatedOutput$Request._read_messages(
            json['messages'],
          ),
    nextPageToken: !json.containsKey('nextPageToken')
        ? null
        : ImportedRecordOutputPaginatedOutput$Request._read_nextPageToken(
            json['nextPageToken'],
          ),
    pageNumber: ImportedRecordOutputPaginatedOutput$Request._read_pageNumber(
      json['pageNumber'],
    ),
    pageSize: ImportedRecordOutputPaginatedOutput$Request._read_pageSize(
      json['pageSize'],
    ),
    timestamp: ImportedRecordOutputPaginatedOutput$Request._read_timestamp(
      json['timestamp'],
    ),
    totalItems: ImportedRecordOutputPaginatedOutput$Request._read_totalItems(
      json['totalItems'],
    ),
  );
}

Map<String, dynamic> _$ImportedRecordOutputPaginatedOutput$RequestToJson(
  ImportedRecordOutputPaginatedOutput$Request instance,
) => <String, dynamic>{
  if (instance.data case final $value?)
    'data': ImportedRecordOutputPaginatedOutput$Request._write_data($value),
  if (instance.errors case final $value?)
    'errors': ImportedRecordOutputPaginatedOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': ImportedRecordOutputPaginatedOutput$Request._write_messages(
      $value,
    ),
  if (instance.nextPageToken case final $value?)
    'nextPageToken':
        ImportedRecordOutputPaginatedOutput$Request._write_nextPageToken(
          $value,
        ),
  'pageNumber': ?ImportedRecordOutputPaginatedOutput$Request._write_pageNumber(
    instance.pageNumber,
  ),
  'pageSize': ?ImportedRecordOutputPaginatedOutput$Request._write_pageSize(
    instance.pageSize,
  ),
  'timestamp': ?ImportedRecordOutputPaginatedOutput$Request._write_timestamp(
    instance.timestamp,
  ),
  'totalItems': ?ImportedRecordOutputPaginatedOutput$Request._write_totalItems(
    instance.totalItems,
  ),
};
