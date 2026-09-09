// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_account_output_data_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinancialAccountOutputDataOutput _$FinancialAccountOutputDataOutputFromJson(
  Map<String, dynamic> json,
) => FinancialAccountOutputDataOutput(
  data: json['data'] == null
      ? null
      : FinancialAccountOutput.fromJson(json['data'] as Map<String, dynamic>),
  errors: (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
  messages: (json['messages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  success: json['success'] as bool?,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$FinancialAccountOutputDataOutputToJson(
  FinancialAccountOutputDataOutput instance,
) => <String, dynamic>{
  'data': instance.data,
  'errors': instance.errors,
  'messages': instance.messages,
  'success': instance.success,
  'timestamp': instance.timestamp?.toIso8601String(),
};
