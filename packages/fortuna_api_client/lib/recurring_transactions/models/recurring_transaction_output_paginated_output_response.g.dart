// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_transaction_output_paginated_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecurringTransactionOutputPaginatedOutput$Response
_$RecurringTransactionOutputPaginatedOutput$ResponseFromJson(
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
  return RecurringTransactionOutputPaginatedOutput$Response(
    data: (json['data'] as List<dynamic>?)
        ?.map(
          (e) => RecurringTransactionOutput.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    hasNextPage: json['hasNextPage'] as bool?,
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    nextPageToken: json['nextPageToken'] as String?,
    pageNumber:
        RecurringTransactionOutputPaginatedOutput$Response._read_pageNumber(
          json['pageNumber'],
        ),
    pageSize: RecurringTransactionOutputPaginatedOutput$Response._read_pageSize(
      json['pageSize'],
    ),
    success: json['success'] as bool?,
    timestamp:
        RecurringTransactionOutputPaginatedOutput$Response._read_timestamp(
          json['timestamp'],
        ),
    totalItems:
        RecurringTransactionOutputPaginatedOutput$Response._read_totalItems(
          json['totalItems'],
        ),
    totalPages:
        RecurringTransactionOutputPaginatedOutput$Response._read_totalPages(
          json['totalPages'],
        ),
  );
}

Map<String, dynamic> _$RecurringTransactionOutputPaginatedOutput$ResponseToJson(
  RecurringTransactionOutputPaginatedOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.map((e) => e.toJson()).toList(),
  'errors': ?instance.errors,
  'hasNextPage': ?instance.hasNextPage,
  'messages': ?instance.messages,
  'nextPageToken': ?instance.nextPageToken,
  'pageNumber':
      ?RecurringTransactionOutputPaginatedOutput$Response._write_pageNumber(
        instance.pageNumber,
      ),
  'pageSize':
      ?RecurringTransactionOutputPaginatedOutput$Response._write_pageSize(
        instance.pageSize,
      ),
  'success': ?instance.success,
  'timestamp':
      ?RecurringTransactionOutputPaginatedOutput$Response._write_timestamp(
        instance.timestamp,
      ),
  'totalItems':
      ?RecurringTransactionOutputPaginatedOutput$Response._write_totalItems(
        instance.totalItems,
      ),
  'totalPages':
      ?RecurringTransactionOutputPaginatedOutput$Response._write_totalPages(
        instance.totalPages,
      ),
};
