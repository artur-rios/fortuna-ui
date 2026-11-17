// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investment_output_paginated_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvestmentOutputPaginatedOutput$Response
_$InvestmentOutputPaginatedOutput$ResponseFromJson(Map<String, dynamic> json) {
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
  return InvestmentOutputPaginatedOutput$Response(
    data: !json.containsKey('data')
        ? null
        : InvestmentOutputPaginatedOutput$Response._read_data(json['data']),
    errors: !json.containsKey('errors')
        ? null
        : InvestmentOutputPaginatedOutput$Response._read_errors(json['errors']),
    hasNextPage: json['hasNextPage'] as bool?,
    messages: !json.containsKey('messages')
        ? null
        : InvestmentOutputPaginatedOutput$Response._read_messages(
            json['messages'],
          ),
    nextPageToken: !json.containsKey('nextPageToken')
        ? null
        : InvestmentOutputPaginatedOutput$Response._read_nextPageToken(
            json['nextPageToken'],
          ),
    pageNumber: InvestmentOutputPaginatedOutput$Response._read_pageNumber(
      json['pageNumber'],
    ),
    pageSize: InvestmentOutputPaginatedOutput$Response._read_pageSize(
      json['pageSize'],
    ),
    success: json['success'] as bool?,
    timestamp: InvestmentOutputPaginatedOutput$Response._read_timestamp(
      json['timestamp'],
    ),
    totalItems: InvestmentOutputPaginatedOutput$Response._read_totalItems(
      json['totalItems'],
    ),
    totalPages: InvestmentOutputPaginatedOutput$Response._read_totalPages(
      json['totalPages'],
    ),
  );
}

Map<String, dynamic> _$InvestmentOutputPaginatedOutput$ResponseToJson(
  InvestmentOutputPaginatedOutput$Response instance,
) => <String, dynamic>{
  if (instance.data case final $value?)
    'data': InvestmentOutputPaginatedOutput$Response._write_data($value),
  if (instance.errors case final $value?)
    'errors': InvestmentOutputPaginatedOutput$Response._write_errors($value),
  'hasNextPage': ?instance.hasNextPage,
  if (instance.messages case final $value?)
    'messages': InvestmentOutputPaginatedOutput$Response._write_messages(
      $value,
    ),
  if (instance.nextPageToken case final $value?)
    'nextPageToken':
        InvestmentOutputPaginatedOutput$Response._write_nextPageToken($value),
  'pageNumber': ?InvestmentOutputPaginatedOutput$Response._write_pageNumber(
    instance.pageNumber,
  ),
  'pageSize': ?InvestmentOutputPaginatedOutput$Response._write_pageSize(
    instance.pageSize,
  ),
  'success': ?instance.success,
  'timestamp': ?InvestmentOutputPaginatedOutput$Response._write_timestamp(
    instance.timestamp,
  ),
  'totalItems': ?InvestmentOutputPaginatedOutput$Response._write_totalItems(
    instance.totalItems,
  ),
  'totalPages': ?InvestmentOutputPaginatedOutput$Response._write_totalPages(
    instance.totalPages,
  ),
};
