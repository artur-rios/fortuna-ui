// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investment_output_paginated_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvestmentOutputPaginatedOutput$Request
_$InvestmentOutputPaginatedOutput$RequestFromJson(Map<String, dynamic> json) {
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
  return InvestmentOutputPaginatedOutput$Request(
    data: (json['data'] as List<dynamic>?)
        ?.map((e) => InvestmentOutput.fromJson(e as Map<String, dynamic>))
        .toList(),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    nextPageToken: json['nextPageToken'] as String?,
    pageNumber: InvestmentOutputPaginatedOutput$Request._read_pageNumber(
      json['pageNumber'],
    ),
    pageSize: InvestmentOutputPaginatedOutput$Request._read_pageSize(
      json['pageSize'],
    ),
    timestamp: InvestmentOutputPaginatedOutput$Request._read_timestamp(
      json['timestamp'],
    ),
    totalItems: InvestmentOutputPaginatedOutput$Request._read_totalItems(
      json['totalItems'],
    ),
  );
}

Map<String, dynamic> _$InvestmentOutputPaginatedOutput$RequestToJson(
  InvestmentOutputPaginatedOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.map((e) => e.toJson()).toList(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'nextPageToken': ?instance.nextPageToken,
  'pageNumber': ?InvestmentOutputPaginatedOutput$Request._write_pageNumber(
    instance.pageNumber,
  ),
  'pageSize': ?InvestmentOutputPaginatedOutput$Request._write_pageSize(
    instance.pageSize,
  ),
  'timestamp': ?InvestmentOutputPaginatedOutput$Request._write_timestamp(
    instance.timestamp,
  ),
  'totalItems': ?InvestmentOutputPaginatedOutput$Request._write_totalItems(
    instance.totalItems,
  ),
};
