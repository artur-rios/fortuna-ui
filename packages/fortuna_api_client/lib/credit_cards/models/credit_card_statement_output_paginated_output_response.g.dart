// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_statement_output_paginated_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCardStatementOutputPaginatedOutput$Response
_$CreditCardStatementOutputPaginatedOutput$ResponseFromJson(
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
  return CreditCardStatementOutputPaginatedOutput$Response(
    data: (json['data'] as List<dynamic>?)
        ?.map(
          (e) => CreditCardStatementOutput.fromJson(e as Map<String, dynamic>),
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
        CreditCardStatementOutputPaginatedOutput$Response._read_pageNumber(
          json['pageNumber'],
        ),
    pageSize: CreditCardStatementOutputPaginatedOutput$Response._read_pageSize(
      json['pageSize'],
    ),
    success: json['success'] as bool?,
    timestamp:
        CreditCardStatementOutputPaginatedOutput$Response._read_timestamp(
          json['timestamp'],
        ),
    totalItems:
        CreditCardStatementOutputPaginatedOutput$Response._read_totalItems(
          json['totalItems'],
        ),
    totalPages:
        CreditCardStatementOutputPaginatedOutput$Response._read_totalPages(
          json['totalPages'],
        ),
  );
}

Map<String, dynamic> _$CreditCardStatementOutputPaginatedOutput$ResponseToJson(
  CreditCardStatementOutputPaginatedOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.map((e) => e.toJson()).toList(),
  'errors': ?instance.errors,
  'hasNextPage': ?instance.hasNextPage,
  'messages': ?instance.messages,
  'nextPageToken': ?instance.nextPageToken,
  'pageNumber':
      ?CreditCardStatementOutputPaginatedOutput$Response._write_pageNumber(
        instance.pageNumber,
      ),
  'pageSize':
      ?CreditCardStatementOutputPaginatedOutput$Response._write_pageSize(
        instance.pageSize,
      ),
  'success': ?instance.success,
  'timestamp':
      ?CreditCardStatementOutputPaginatedOutput$Response._write_timestamp(
        instance.timestamp,
      ),
  'totalItems':
      ?CreditCardStatementOutputPaginatedOutput$Response._write_totalItems(
        instance.totalItems,
      ),
  'totalPages':
      ?CreditCardStatementOutputPaginatedOutput$Response._write_totalPages(
        instance.totalPages,
      ),
};
