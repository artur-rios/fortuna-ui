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
    data: !json.containsKey('data')
        ? null
        : InvestmentValuationOutputPaginatedOutput$Response._read_data(
            json['data'],
          ),
    errors: !json.containsKey('errors')
        ? null
        : InvestmentValuationOutputPaginatedOutput$Response._read_errors(
            json['errors'],
          ),
    hasNextPage: json['hasNextPage'] as bool?,
    messages: !json.containsKey('messages')
        ? null
        : InvestmentValuationOutputPaginatedOutput$Response._read_messages(
            json['messages'],
          ),
    nextPageToken: !json.containsKey('nextPageToken')
        ? null
        : InvestmentValuationOutputPaginatedOutput$Response._read_nextPageToken(
            json['nextPageToken'],
          ),
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
  if (instance.data case final $value?)
    'data': InvestmentValuationOutputPaginatedOutput$Response._write_data(
      $value,
    ),
  if (instance.errors case final $value?)
    'errors': InvestmentValuationOutputPaginatedOutput$Response._write_errors(
      $value,
    ),
  'hasNextPage': ?instance.hasNextPage,
  if (instance.messages case final $value?)
    'messages':
        InvestmentValuationOutputPaginatedOutput$Response._write_messages(
          $value,
        ),
  if (instance.nextPageToken case final $value?)
    'nextPageToken':
        InvestmentValuationOutputPaginatedOutput$Response._write_nextPageToken(
          $value,
        ),
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
