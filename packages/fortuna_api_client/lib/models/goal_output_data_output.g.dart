// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_output_data_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalOutputDataOutput _$GoalOutputDataOutputFromJson(
  Map<String, dynamic> json,
) => GoalOutputDataOutput(
  data: json['data'] == null
      ? null
      : GoalOutput.fromJson(json['data'] as Map<String, dynamic>),
  errors: (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
  messages: (json['messages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  success: json['success'] as bool?,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$GoalOutputDataOutputToJson(
  GoalOutputDataOutput instance,
) => <String, dynamic>{
  'data': instance.data,
  'errors': instance.errors,
  'messages': instance.messages,
  'success': instance.success,
  'timestamp': instance.timestamp?.toIso8601String(),
};
