// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_personal_data_export_command_output_data_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestPersonalDataExportCommandOutputDataOutput
_$RequestPersonalDataExportCommandOutputDataOutputFromJson(
  Map<String, dynamic> json,
) => RequestPersonalDataExportCommandOutputDataOutput(
  data: json['data'] == null
      ? null
      : RequestPersonalDataExportCommandOutput.fromJson(
          json['data'] as Map<String, dynamic>,
        ),
  errors: (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
  messages: (json['messages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  success: json['success'] as bool?,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$RequestPersonalDataExportCommandOutputDataOutputToJson(
  RequestPersonalDataExportCommandOutputDataOutput instance,
) => <String, dynamic>{
  'data': instance.data,
  'errors': instance.errors,
  'messages': instance.messages,
  'success': instance.success,
  'timestamp': instance.timestamp?.toIso8601String(),
};
