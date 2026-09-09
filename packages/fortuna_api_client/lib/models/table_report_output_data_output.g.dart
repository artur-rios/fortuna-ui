// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_report_output_data_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableReportOutputDataOutput _$TableReportOutputDataOutputFromJson(
  Map<String, dynamic> json,
) => TableReportOutputDataOutput(
  data: json['data'] == null
      ? null
      : TableReportOutput.fromJson(json['data'] as Map<String, dynamic>),
  errors: (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
  messages: (json['messages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  success: json['success'] as bool?,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$TableReportOutputDataOutputToJson(
  TableReportOutputDataOutput instance,
) => <String, dynamic>{
  'data': instance.data,
  'errors': instance.errors,
  'messages': instance.messages,
  'success': instance.success,
  'timestamp': instance.timestamp?.toIso8601String(),
};
