// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counterparty_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounterpartyCommandOutput _$CounterpartyCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'createdAt',
      'id',
      'isDeleted',
      'name',
      'reused',
      'updatedAt',
    ],
    disallowNullValues: const [
      'createdAt',
      'id',
      'isDeleted',
      'reused',
      'updatedAt',
    ],
  );
  return CounterpartyCommandOutput(
    createdAt: CounterpartyCommandOutput._read_createdAt(json['createdAt']),
    id: json['id'] as String?,
    isDeleted: json['isDeleted'] as bool?,
    name: !json.containsKey('name')
        ? null
        : CounterpartyCommandOutput._read_name(json['name']),
    reused: json['reused'] as bool?,
    updatedAt: CounterpartyCommandOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$CounterpartyCommandOutputToJson(
  CounterpartyCommandOutput instance,
) => <String, dynamic>{
  'createdAt': ?CounterpartyCommandOutput._write_createdAt(instance.createdAt),
  'id': ?instance.id,
  'isDeleted': ?instance.isDeleted,
  if (instance.name case final $value?)
    'name': CounterpartyCommandOutput._write_name($value),
  'reused': ?instance.reused,
  'updatedAt': ?CounterpartyCommandOutput._write_updatedAt(instance.updatedAt),
};
