// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_account_output_paginated_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinancialAccountOutputPaginatedOutput
_$FinancialAccountOutputPaginatedOutputFromJson(
  Map<String, dynamic> json,
) => FinancialAccountOutputPaginatedOutput(
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => FinancialAccountOutput.fromJson(e as Map<String, dynamic>))
      .toList(),
  errors: (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
  messages: (json['messages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  pageNumber: (json['pageNumber'] as num?)?.toInt(),
  pageSize: (json['pageSize'] as num?)?.toInt(),
  success: json['success'] as bool?,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
  totalItems: (json['totalItems'] as num?)?.toInt(),
  totalPages: (json['totalPages'] as num?)?.toInt(),
);

Map<String, dynamic> _$FinancialAccountOutputPaginatedOutputToJson(
  FinancialAccountOutputPaginatedOutput instance,
) => <String, dynamic>{
  'data': instance.data,
  'errors': instance.errors,
  'messages': instance.messages,
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
  'success': instance.success,
  'timestamp': instance.timestamp?.toIso8601String(),
  'totalItems': instance.totalItems,
  'totalPages': instance.totalPages,
};
