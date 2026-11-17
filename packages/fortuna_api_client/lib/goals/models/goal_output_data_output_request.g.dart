// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalOutputDataOutput$Request _$GoalOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return GoalOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : GoalOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : GoalOutputDataOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : GoalOutputDataOutput$Request._read_messages(json['messages']),
    timestamp: GoalOutputDataOutput$Request._read_timestamp(json['timestamp']),
  );
}

Map<String, dynamic> _$GoalOutputDataOutput$RequestToJson(
  GoalOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': GoalOutputDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': GoalOutputDataOutput$Request._write_messages($value),
  'timestamp': ?GoalOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};
