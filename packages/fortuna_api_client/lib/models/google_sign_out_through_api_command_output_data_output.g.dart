// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_sign_out_through_api_command_output_data_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleSignOutThroughApiCommandOutputDataOutput
_$GoogleSignOutThroughApiCommandOutputDataOutputFromJson(
  Map<String, dynamic> json,
) => GoogleSignOutThroughApiCommandOutputDataOutput(
  data: json['data'],
  errors: (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
  messages: (json['messages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  success: json['success'] as bool?,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$GoogleSignOutThroughApiCommandOutputDataOutputToJson(
  GoogleSignOutThroughApiCommandOutputDataOutput instance,
) => <String, dynamic>{
  'data': instance.data,
  'errors': instance.errors,
  'messages': instance.messages,
  'success': instance.success,
  'timestamp': instance.timestamp?.toIso8601String(),
};
