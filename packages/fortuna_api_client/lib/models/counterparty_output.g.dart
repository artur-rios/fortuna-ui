// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counterparty_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounterpartyOutput _$CounterpartyOutputFromJson(Map<String, dynamic> json) =>
    CounterpartyOutput(
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      id: json['id'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      name: json['name'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CounterpartyOutputToJson(CounterpartyOutput instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt?.toIso8601String(),
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'name': instance.name,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
