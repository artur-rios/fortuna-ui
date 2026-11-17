// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalOutputDataOutput$Response _$GoalOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return GoalOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : GoalOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    success: json['success'] as bool?,
    timestamp: GoalOutputDataOutput$Response._read_timestamp(json['timestamp']),
  );
}

Map<String, dynamic> _$GoalOutputDataOutput$ResponseToJson(
  GoalOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp': ?GoalOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};
