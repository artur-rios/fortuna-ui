// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counterparty_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounterpartyOutput _$CounterpartyOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['createdAt', 'id', 'isDeleted', 'name', 'updatedAt'],
    disallowNullValues: const ['createdAt', 'id', 'isDeleted', 'updatedAt'],
  );
  return CounterpartyOutput(
    createdAt: CounterpartyOutput._read_createdAt(json['createdAt']),
    id: json['id'] as String?,
    isDeleted: json['isDeleted'] as bool?,
    name: json['name'] as String?,
    updatedAt: CounterpartyOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$CounterpartyOutputToJson(CounterpartyOutput instance) =>
    <String, dynamic>{
      'createdAt': ?CounterpartyOutput._write_createdAt(instance.createdAt),
      'id': ?instance.id,
      'isDeleted': ?instance.isDeleted,
      'name': ?instance.name,
      'updatedAt': ?CounterpartyOutput._write_updatedAt(instance.updatedAt),
    };
