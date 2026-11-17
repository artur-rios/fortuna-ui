// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_resource_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalResourceOutput _$GoalResourceOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['id', 'name'],
    disallowNullValues: const ['id'],
  );
  return GoalResourceOutput(
    id: json['id'] as String?,
    name: !json.containsKey('name')
        ? null
        : GoalResourceOutput._read_name(json['name']),
  );
}

Map<String, dynamic> _$GoalResourceOutputToJson(GoalResourceOutput instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      if (instance.name case final $value?)
        'name': GoalResourceOutput._write_name($value),
    };
