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
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return GoalOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : GoalOutput.fromJson(json['data'] as Map<String, dynamic>),
    errors: !json.containsKey('errors')
        ? null
        : GoalOutputDataOutput$Response._read_errors(json['errors']),
    messages: !json.containsKey('messages')
        ? null
        : GoalOutputDataOutput$Response._read_messages(json['messages']),
    success: json['success'] as bool?,
    timestamp: GoalOutputDataOutput$Response._read_timestamp(json['timestamp']),
  );
}

Map<String, dynamic> _$GoalOutputDataOutput$ResponseToJson(
  GoalOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': GoalOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': GoalOutputDataOutput$Response._write_messages($value),
  'success': ?instance.success,
  'timestamp': ?GoalOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};
