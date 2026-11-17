// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operational_health_service_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OperationalHealthServiceOutput _$OperationalHealthServiceOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'name',
      'oldestPendingSeconds',
      'queueDepth',
      'reason',
      'status',
    ],
  );
  return OperationalHealthServiceOutput(
    name: json['name'] as String?,
    oldestPendingSeconds:
        OperationalHealthServiceOutput._read_oldestPendingSeconds(
          json['oldestPendingSeconds'],
        ),
    queueDepth: OperationalHealthServiceOutput._read_queueDepth(
      json['queueDepth'],
    ),
    reason: json['reason'] as String?,
    status: json['status'] as String?,
  );
}

Map<String, dynamic> _$OperationalHealthServiceOutputToJson(
  OperationalHealthServiceOutput instance,
) => <String, dynamic>{
  'name': ?instance.name,
  'oldestPendingSeconds':
      ?OperationalHealthServiceOutput._write_oldestPendingSeconds(
        instance.oldestPendingSeconds,
      ),
  'queueDepth': ?OperationalHealthServiceOutput._write_queueDepth(
    instance.queueDepth,
  ),
  'reason': ?instance.reason,
  'status': ?instance.status,
};
