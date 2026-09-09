// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'synchronize_connection_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SynchronizeConnectionCommand _$SynchronizeConnectionCommandFromJson(
  Map<String, dynamic> json,
) => SynchronizeConnectionCommand(
  periodEnd: json['periodEnd'] == null
      ? null
      : DateTime.parse(json['periodEnd'] as String),
  periodStart: json['periodStart'] == null
      ? null
      : DateTime.parse(json['periodStart'] as String),
);

Map<String, dynamic> _$SynchronizeConnectionCommandToJson(
  SynchronizeConnectionCommand instance,
) => <String, dynamic>{
  'periodEnd': instance.periodEnd?.toIso8601String(),
  'periodStart': instance.periodStart?.toIso8601String(),
};
