// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_statement_output_paginated_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCardStatementOutputPaginatedOutput$Request
_$CreditCardStatementOutputPaginatedOutput$RequestFromJson(
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
  return CreditCardStatementOutputPaginatedOutput$Request(
    data: (json['data'] as List<dynamic>?)
        ?.map(
          (e) => CreditCardStatementOutput.fromJson(e as Map<String, dynamic>),
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
        CreditCardStatementOutputPaginatedOutput$Request._read_pageNumber(
          json['pageNumber'],
        ),
    pageSize: CreditCardStatementOutputPaginatedOutput$Request._read_pageSize(
      json['pageSize'],
    ),
    timestamp: CreditCardStatementOutputPaginatedOutput$Request._read_timestamp(
      json['timestamp'],
    ),
    totalItems:
        CreditCardStatementOutputPaginatedOutput$Request._read_totalItems(
          json['totalItems'],
        ),
  );
}

Map<String, dynamic> _$CreditCardStatementOutputPaginatedOutput$RequestToJson(
  CreditCardStatementOutputPaginatedOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.map((e) => e.toJson()).toList(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'nextPageToken': ?instance.nextPageToken,
  'pageNumber':
      ?CreditCardStatementOutputPaginatedOutput$Request._write_pageNumber(
        instance.pageNumber,
      ),
  'pageSize': ?CreditCardStatementOutputPaginatedOutput$Request._write_pageSize(
    instance.pageSize,
  ),
  'timestamp':
      ?CreditCardStatementOutputPaginatedOutput$Request._write_timestamp(
        instance.timestamp,
      ),
  'totalItems':
      ?CreditCardStatementOutputPaginatedOutput$Request._write_totalItems(
        instance.totalItems,
      ),
};
