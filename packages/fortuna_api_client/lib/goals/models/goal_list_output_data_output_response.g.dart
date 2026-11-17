// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_list_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalListOutputDataOutput$Response _$GoalListOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return GoalListOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : GoalListOutput$Response.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : GoalListOutputDataOutput$Response._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : GoalListOutputDataOutput$Response._read_messages(json['messages']),
    success: json['success'] as bool?,
    timestamp: GoalListOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$GoalListOutputDataOutput$ResponseToJson(
  GoalListOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': GoalListOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': GoalListOutputDataOutput$Response._write_messages($value),
  'success': ?instance.success,
  'timestamp': ?GoalListOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};
