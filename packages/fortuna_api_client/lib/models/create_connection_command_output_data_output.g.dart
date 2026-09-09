// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_connection_command_output_data_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateConnectionCommandOutputDataOutput
_$CreateConnectionCommandOutputDataOutputFromJson(Map<String, dynamic> json) =>
    CreateConnectionCommandOutputDataOutput(
      data: json['data'] == null
          ? null
          : CreateConnectionCommandOutput.fromJson(
              json['data'] as Map<String, dynamic>,
            ),
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      success: json['success'] as bool?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$CreateConnectionCommandOutputDataOutputToJson(
  CreateConnectionCommandOutputDataOutput instance,
) => <String, dynamic>{
  'data': instance.data,
  'errors': instance.errors,
  'messages': instance.messages,
  'success': instance.success,
  'timestamp': instance.timestamp?.toIso8601String(),
};
