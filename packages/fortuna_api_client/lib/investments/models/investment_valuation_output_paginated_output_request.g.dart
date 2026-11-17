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
    data: !json.containsKey('data')
        ? null
        : InvestmentValuationOutputPaginatedOutput$Request._read_data(
            json['data'],
          ),
    errors: !json.containsKey('errors')
        ? null
        : InvestmentValuationOutputPaginatedOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : InvestmentValuationOutputPaginatedOutput$Request._read_messages(
            json['messages'],
          ),
    nextPageToken: !json.containsKey('nextPageToken')
        ? null
        : InvestmentValuationOutputPaginatedOutput$Request._read_nextPageToken(
            json['nextPageToken'],
          ),
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
  if (instance.data case final $value?)
    'data': InvestmentValuationOutputPaginatedOutput$Request._write_data(
      $value,
    ),
  if (instance.errors case final $value?)
    'errors': InvestmentValuationOutputPaginatedOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages':
        InvestmentValuationOutputPaginatedOutput$Request._write_messages(
          $value,
        ),
  if (instance.nextPageToken case final $value?)
    'nextPageToken':
        InvestmentValuationOutputPaginatedOutput$Request._write_nextPageToken(
          $value,
        ),
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
