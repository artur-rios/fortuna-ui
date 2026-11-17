// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalCommandOutputDataOutput$Request
_$GoalCommandOutputDataOutput$RequestFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return GoalCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : GoalCommandOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : GoalCommandOutputDataOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : GoalCommandOutputDataOutput$Request._read_messages(json['messages']),
    timestamp: GoalCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$GoalCommandOutputDataOutput$RequestToJson(
  GoalCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': GoalCommandOutputDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': GoalCommandOutputDataOutput$Request._write_messages($value),
  'timestamp': ?GoalCommandOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};
