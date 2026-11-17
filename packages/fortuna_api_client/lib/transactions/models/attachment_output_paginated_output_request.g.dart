// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_output_paginated_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttachmentOutputPaginatedOutput$Request
_$AttachmentOutputPaginatedOutput$RequestFromJson(Map<String, dynamic> json) {
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
  return AttachmentOutputPaginatedOutput$Request(
    data: (json['data'] as List<dynamic>?)
        ?.map((e) => AttachmentOutput.fromJson(e as Map<String, dynamic>))
        .toList(),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    nextPageToken: json['nextPageToken'] as String?,
    pageNumber: AttachmentOutputPaginatedOutput$Request._read_pageNumber(
      json['pageNumber'],
    ),
    pageSize: AttachmentOutputPaginatedOutput$Request._read_pageSize(
      json['pageSize'],
    ),
    timestamp: AttachmentOutputPaginatedOutput$Request._read_timestamp(
      json['timestamp'],
    ),
    totalItems: AttachmentOutputPaginatedOutput$Request._read_totalItems(
      json['totalItems'],
    ),
  );
}

Map<String, dynamic> _$AttachmentOutputPaginatedOutput$RequestToJson(
  AttachmentOutputPaginatedOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.map((e) => e.toJson()).toList(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'nextPageToken': ?instance.nextPageToken,
  'pageNumber': ?AttachmentOutputPaginatedOutput$Request._write_pageNumber(
    instance.pageNumber,
  ),
  'pageSize': ?AttachmentOutputPaginatedOutput$Request._write_pageSize(
    instance.pageSize,
  ),
  'timestamp': ?AttachmentOutputPaginatedOutput$Request._write_timestamp(
    instance.timestamp,
  ),
  'totalItems': ?AttachmentOutputPaginatedOutput$Request._write_totalItems(
    instance.totalItems,
  ),
};
