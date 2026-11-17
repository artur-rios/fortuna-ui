// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_entry_output_paginated_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditEntryOutputPaginatedOutput$Request
_$AuditEntryOutputPaginatedOutput$RequestFromJson(Map<String, dynamic> json) {
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
  return AuditEntryOutputPaginatedOutput$Request(
    data: !json.containsKey('data')
        ? null
        : AuditEntryOutputPaginatedOutput$Request._read_data(json['data']),
    errors: !json.containsKey('errors')
        ? null
        : AuditEntryOutputPaginatedOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : AuditEntryOutputPaginatedOutput$Request._read_messages(
            json['messages'],
          ),
    nextPageToken: !json.containsKey('nextPageToken')
        ? null
        : AuditEntryOutputPaginatedOutput$Request._read_nextPageToken(
            json['nextPageToken'],
          ),
    pageNumber: AuditEntryOutputPaginatedOutput$Request._read_pageNumber(
      json['pageNumber'],
    ),
    pageSize: AuditEntryOutputPaginatedOutput$Request._read_pageSize(
      json['pageSize'],
    ),
    timestamp: AuditEntryOutputPaginatedOutput$Request._read_timestamp(
      json['timestamp'],
    ),
    totalItems: AuditEntryOutputPaginatedOutput$Request._read_totalItems(
      json['totalItems'],
    ),
  );
}

Map<String, dynamic> _$AuditEntryOutputPaginatedOutput$RequestToJson(
  AuditEntryOutputPaginatedOutput$Request instance,
) => <String, dynamic>{
  if (instance.data case final $value?)
    'data': AuditEntryOutputPaginatedOutput$Request._write_data($value),
  if (instance.errors case final $value?)
    'errors': AuditEntryOutputPaginatedOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': AuditEntryOutputPaginatedOutput$Request._write_messages($value),
  if (instance.nextPageToken case final $value?)
    'nextPageToken':
        AuditEntryOutputPaginatedOutput$Request._write_nextPageToken($value),
  'pageNumber': ?AuditEntryOutputPaginatedOutput$Request._write_pageNumber(
    instance.pageNumber,
  ),
  'pageSize': ?AuditEntryOutputPaginatedOutput$Request._write_pageSize(
    instance.pageSize,
  ),
  'timestamp': ?AuditEntryOutputPaginatedOutput$Request._write_timestamp(
    instance.timestamp,
  ),
  'totalItems': ?AuditEntryOutputPaginatedOutput$Request._write_totalItems(
    instance.totalItems,
  ),
};
