// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_output_paginated_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCardOutputPaginatedOutput _$CreditCardOutputPaginatedOutputFromJson(
  Map<String, dynamic> json,
) => CreditCardOutputPaginatedOutput(
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => CreditCardOutput.fromJson(e as Map<String, dynamic>))
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

Map<String, dynamic> _$CreditCardOutputPaginatedOutputToJson(
  CreditCardOutputPaginatedOutput instance,
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
