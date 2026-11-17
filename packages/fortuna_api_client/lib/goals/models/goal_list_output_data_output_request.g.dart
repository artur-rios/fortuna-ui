// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_list_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalListOutputDataOutput$Request _$GoalListOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return GoalListOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : GoalListOutput$Request.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : GoalListOutputDataOutput$Request._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : GoalListOutputDataOutput$Request._read_messages(json['messages']),
    timestamp: GoalListOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$GoalListOutputDataOutput$RequestToJson(
  GoalListOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': GoalListOutputDataOutput$Request._write_errors($value),
  if (instance.messages case final $value?)
    'messages': GoalListOutputDataOutput$Request._write_messages($value),
  'timestamp': ?GoalListOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};
