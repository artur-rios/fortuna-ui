// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disable_two_factor_through_api_command_output_data_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DisableTwoFactorThroughApiCommandOutputDataOutput
_$DisableTwoFactorThroughApiCommandOutputDataOutputFromJson(
  Map<String, dynamic> json,
) => DisableTwoFactorThroughApiCommandOutputDataOutput(
  data: json['data'] == null
      ? null
      : DisableTwoFactorThroughApiCommandOutput.fromJson(
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

Map<String, dynamic> _$DisableTwoFactorThroughApiCommandOutputDataOutputToJson(
  DisableTwoFactorThroughApiCommandOutputDataOutput instance,
) => <String, dynamic>{
  'data': instance.data,
  'errors': instance.errors,
  'messages': instance.messages,
  'success': instance.success,
  'timestamp': instance.timestamp?.toIso8601String(),
};
