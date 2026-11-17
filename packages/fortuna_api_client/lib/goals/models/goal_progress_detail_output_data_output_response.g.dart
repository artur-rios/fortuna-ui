// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_progress_detail_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalProgressDetailOutputDataOutput$Response
_$GoalProgressDetailOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return GoalProgressDetailOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : GoalProgressDetailOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : GoalProgressDetailOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : GoalProgressDetailOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp: GoalProgressDetailOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$GoalProgressDetailOutputDataOutput$ResponseToJson(
  GoalProgressDetailOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': GoalProgressDetailOutputDataOutput$Response._write_errors($value),
  if (instance.messages case final $value?)
    'messages': GoalProgressDetailOutputDataOutput$Response._write_messages(
      $value,
    ),
  'success': ?instance.success,
  'timestamp': ?GoalProgressDetailOutputDataOutput$Response._write_timestamp(
    instance.timestamp,
  ),
};
