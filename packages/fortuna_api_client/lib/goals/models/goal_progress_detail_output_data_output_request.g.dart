// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_progress_detail_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalProgressDetailOutputDataOutput$Request
_$GoalProgressDetailOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return GoalProgressDetailOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : GoalProgressDetailOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: GoalProgressDetailOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$GoalProgressDetailOutputDataOutput$RequestToJson(
  GoalProgressDetailOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp': ?GoalProgressDetailOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};
