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
    data: (json['data'] as List<dynamic>?)
        ?.map((e) => ImportedRecordOutput.fromJson(e as Map<String, dynamic>))
        .toList(),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    nextPageToken: json['nextPageToken'] as String?,
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
  'data': ?instance.data?.map((e) => e.toJson()).toList(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'nextPageToken': ?instance.nextPageToken,
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
