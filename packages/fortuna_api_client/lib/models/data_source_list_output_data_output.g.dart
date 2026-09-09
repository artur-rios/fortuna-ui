// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_source_list_output_data_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataSourceListOutputDataOutput _$DataSourceListOutputDataOutputFromJson(
  Map<String, dynamic> json,
) => DataSourceListOutputDataOutput(
  data: json['data'] == null
      ? null
      : DataSourceListOutput.fromJson(json['data'] as Map<String, dynamic>),
  errors: (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
  messages: (json['messages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  success: json['success'] as bool?,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$DataSourceListOutputDataOutputToJson(
  DataSourceListOutputDataOutput instance,
) => <String, dynamic>{
  'data': instance.data,
  'errors': instance.errors,
  'messages': instance.messages,
  'success': instance.success,
  'timestamp': instance.timestamp?.toIso8601String(),
};
