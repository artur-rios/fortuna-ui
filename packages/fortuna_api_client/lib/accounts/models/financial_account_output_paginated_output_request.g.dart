// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_account_output_paginated_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinancialAccountOutputPaginatedOutput$Request
_$FinancialAccountOutputPaginatedOutput$RequestFromJson(
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
  return FinancialAccountOutputPaginatedOutput$Request(
    data: (json['data'] as List<dynamic>?)
        ?.map((e) => FinancialAccountOutput.fromJson(e as Map<String, dynamic>))
        .toList(),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    nextPageToken: json['nextPageToken'] as String?,
    pageNumber: FinancialAccountOutputPaginatedOutput$Request._read_pageNumber(
      json['pageNumber'],
    ),
    pageSize: FinancialAccountOutputPaginatedOutput$Request._read_pageSize(
      json['pageSize'],
    ),
    timestamp: FinancialAccountOutputPaginatedOutput$Request._read_timestamp(
      json['timestamp'],
    ),
    totalItems: FinancialAccountOutputPaginatedOutput$Request._read_totalItems(
      json['totalItems'],
    ),
  );
}

Map<String, dynamic> _$FinancialAccountOutputPaginatedOutput$RequestToJson(
  FinancialAccountOutputPaginatedOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.map((e) => e.toJson()).toList(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'nextPageToken': ?instance.nextPageToken,
  'pageNumber':
      ?FinancialAccountOutputPaginatedOutput$Request._write_pageNumber(
        instance.pageNumber,
      ),
  'pageSize': ?FinancialAccountOutputPaginatedOutput$Request._write_pageSize(
    instance.pageSize,
  ),
  'timestamp': ?FinancialAccountOutputPaginatedOutput$Request._write_timestamp(
    instance.timestamp,
  ),
  'totalItems':
      ?FinancialAccountOutputPaginatedOutput$Request._write_totalItems(
        instance.totalItems,
      ),
};
