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
    data: !json.containsKey('data')
        ? null
        : AttachmentOutputPaginatedOutput$Request._read_data(json['data']),
    errors: !json.containsKey('errors')
        ? null
        : AttachmentOutputPaginatedOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : AttachmentOutputPaginatedOutput$Request._read_messages(
            json['messages'],
          ),
    nextPageToken: !json.containsKey('nextPageToken')
        ? null
        : AttachmentOutputPaginatedOutput$Request._read_nextPageToken(
            json['nextPageToken'],
          ),
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
  if (instance.data case final $value?)
    'data': AttachmentOutputPaginatedOutput$Request._write_data($value),
  if (instance.errors case final $value?)
    'errors': AttachmentOutputPaginatedOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': AttachmentOutputPaginatedOutput$Request._write_messages($value),
  if (instance.nextPageToken case final $value?)
    'nextPageToken':
        AttachmentOutputPaginatedOutput$Request._write_nextPageToken($value),
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
