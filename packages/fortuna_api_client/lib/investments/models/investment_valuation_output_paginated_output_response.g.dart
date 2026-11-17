// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investment_valuation_output_paginated_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvestmentValuationOutputPaginatedOutput$Response
_$InvestmentValuationOutputPaginatedOutput$ResponseFromJson(
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
  return InvestmentValuationOutputPaginatedOutput$Response(
    data: (json['data'] as List<dynamic>?)
        ?.map(
          (e) => InvestmentValuationOutput.fromJson(e as Map<String, dynamic>),
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
        InvestmentValuationOutputPaginatedOutput$Response._read_pageNumber(
          json['pageNumber'],
        ),
    pageSize: InvestmentValuationOutputPaginatedOutput$Response._read_pageSize(
      json['pageSize'],
    ),
    success: json['success'] as bool?,
    timestamp:
        InvestmentValuationOutputPaginatedOutput$Response._read_timestamp(
          json['timestamp'],
        ),
    totalItems:
        InvestmentValuationOutputPaginatedOutput$Response._read_totalItems(
          json['totalItems'],
        ),
    totalPages:
        InvestmentValuationOutputPaginatedOutput$Response._read_totalPages(
          json['totalPages'],
        ),
  );
}

Map<String, dynamic> _$InvestmentValuationOutputPaginatedOutput$ResponseToJson(
  InvestmentValuationOutputPaginatedOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.map((e) => e.toJson()).toList(),
  'errors': ?instance.errors,
  'hasNextPage': ?instance.hasNextPage,
  'messages': ?instance.messages,
  'nextPageToken': ?instance.nextPageToken,
  'pageNumber':
      ?InvestmentValuationOutputPaginatedOutput$Response._write_pageNumber(
        instance.pageNumber,
      ),
  'pageSize':
      ?InvestmentValuationOutputPaginatedOutput$Response._write_pageSize(
        instance.pageSize,
      ),
  'success': ?instance.success,
  'timestamp':
      ?InvestmentValuationOutputPaginatedOutput$Response._write_timestamp(
        instance.timestamp,
      ),
  'totalItems':
      ?InvestmentValuationOutputPaginatedOutput$Response._write_totalItems(
        instance.totalItems,
      ),
  'totalPages':
      ?InvestmentValuationOutputPaginatedOutput$Response._write_totalPages(
        instance.totalPages,
      ),
};
