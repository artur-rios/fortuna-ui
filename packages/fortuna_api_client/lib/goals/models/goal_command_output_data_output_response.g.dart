// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalCommandOutputDataOutput$Response
_$GoalCommandOutputDataOutput$ResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return GoalCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : GoalCommandOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : GoalCommandOutputDataOutput$Response._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : GoalCommandOutputDataOutput$Response._read_messages(json['messages']),
    success: json['success'] as bool?,
    timestamp: GoalCommandOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$GoalCommandOutputDataOutput$ResponseToJson(
  GoalCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': GoalCommandOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': GoalCommandOutputDataOutput$Response._write_messages($value),
  'success': ?instance.success,
  'timestamp': ?GoalCommandOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};
