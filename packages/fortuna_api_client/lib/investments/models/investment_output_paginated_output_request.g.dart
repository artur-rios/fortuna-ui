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
    data: !json.containsKey('data')
        ? null
        : InvestmentOutputPaginatedOutput$Request._read_data(json['data']),
    errors: !json.containsKey('errors')
        ? null
        : InvestmentOutputPaginatedOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : InvestmentOutputPaginatedOutput$Request._read_messages(
            json['messages'],
          ),
    nextPageToken: !json.containsKey('nextPageToken')
        ? null
        : InvestmentOutputPaginatedOutput$Request._read_nextPageToken(
            json['nextPageToken'],
          ),
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
  if (instance.data case final $value?)
    'data': InvestmentOutputPaginatedOutput$Request._write_data($value),
  if (instance.errors case final $value?)
    'errors': InvestmentOutputPaginatedOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': InvestmentOutputPaginatedOutput$Request._write_messages($value),
  if (instance.nextPageToken case final $value?)
    'nextPageToken':
        InvestmentOutputPaginatedOutput$Request._write_nextPageToken($value),
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
