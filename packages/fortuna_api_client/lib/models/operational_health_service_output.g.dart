// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operational_health_service_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OperationalHealthServiceOutput _$OperationalHealthServiceOutputFromJson(
  Map<String, dynamic> json,
) => OperationalHealthServiceOutput(
  name: json['name'] as String?,
  oldestPendingSeconds: (json['oldestPendingSeconds'] as num?)?.toInt(),
  queueDepth: (json['queueDepth'] as num?)?.toInt(),
  status: json['status'] as String?,
);

Map<String, dynamic> _$OperationalHealthServiceOutputToJson(
  OperationalHealthServiceOutput instance,
) => <String, dynamic>{
  'name': instance.name,
  'oldestPendingSeconds': instance.oldestPendingSeconds,
  'queueDepth': instance.queueDepth,
  'status': instance.status,
};
