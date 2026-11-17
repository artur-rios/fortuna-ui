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
    data: (json['data'] as List<dynamic>?)
        ?.map((e) => AuditEntryOutput.fromJson(e as Map<String, dynamic>))
        .toList(),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    nextPageToken: json['nextPageToken'] as String?,
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
  'data': ?instance.data?.map((e) => e.toJson()).toList(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'nextPageToken': ?instance.nextPageToken,
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
