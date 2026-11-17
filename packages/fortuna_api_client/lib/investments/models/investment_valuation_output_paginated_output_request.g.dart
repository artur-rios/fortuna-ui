// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investment_valuation_output_paginated_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvestmentValuationOutputPaginatedOutput$Request
_$InvestmentValuationOutputPaginatedOutput$RequestFromJson(
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
  return InvestmentValuationOutputPaginatedOutput$Request(
    data: (json['data'] as List<dynamic>?)
        ?.map(
          (e) => InvestmentValuationOutput.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    nextPageToken: json['nextPageToken'] as String?,
    pageNumber:
        InvestmentValuationOutputPaginatedOutput$Request._read_pageNumber(
          json['pageNumber'],
        ),
    pageSize: InvestmentValuationOutputPaginatedOutput$Request._read_pageSize(
      json['pageSize'],
    ),
    timestamp: InvestmentValuationOutputPaginatedOutput$Request._read_timestamp(
      json['timestamp'],
    ),
    totalItems:
        InvestmentValuationOutputPaginatedOutput$Request._read_totalItems(
          json['totalItems'],
        ),
  );
}

Map<String, dynamic> _$InvestmentValuationOutputPaginatedOutput$RequestToJson(
  InvestmentValuationOutputPaginatedOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.map((e) => e.toJson()).toList(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'nextPageToken': ?instance.nextPageToken,
  'pageNumber':
      ?InvestmentValuationOutputPaginatedOutput$Request._write_pageNumber(
        instance.pageNumber,
      ),
  'pageSize': ?InvestmentValuationOutputPaginatedOutput$Request._write_pageSize(
    instance.pageSize,
  ),
  'timestamp':
      ?InvestmentValuationOutputPaginatedOutput$Request._write_timestamp(
        instance.timestamp,
      ),
  'totalItems':
      ?InvestmentValuationOutputPaginatedOutput$Request._write_totalItems(
        instance.totalItems,
      ),
};
