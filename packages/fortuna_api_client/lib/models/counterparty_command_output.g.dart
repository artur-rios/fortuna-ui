// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counterparty_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounterpartyCommandOutput _$CounterpartyCommandOutputFromJson(
  Map<String, dynamic> json,
) => CounterpartyCommandOutput(
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  id: json['id'] as String?,
  isDeleted: json['isDeleted'] as bool?,
  name: json['name'] as String?,
  reused: json['reused'] as bool?,
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$CounterpartyCommandOutputToJson(
  CounterpartyCommandOutput instance,
) => <String, dynamic>{
  'createdAt': instance.createdAt?.toIso8601String(),
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'name': instance.name,
  'reused': instance.reused,
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
