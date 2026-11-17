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
    name: !json.containsKey('name')
        ? null
        : OperationalHealthServiceOutput._read_name(json['name']),
    oldestPendingSeconds: !json.containsKey('oldestPendingSeconds')
        ? null
        : OperationalHealthServiceOutput._read_oldestPendingSeconds(
            json['oldestPendingSeconds'],
          ),
    queueDepth: !json.containsKey('queueDepth')
        ? null
        : OperationalHealthServiceOutput._read_queueDepth(json['queueDepth']),
    reason: !json.containsKey('reason')
        ? null
        : OperationalHealthServiceOutput._read_reason(json['reason']),
    status: !json.containsKey('status')
        ? null
        : OperationalHealthServiceOutput._read_status(json['status']),
  );
}

Map<String, dynamic> _$OperationalHealthServiceOutputToJson(
  OperationalHealthServiceOutput instance,
) => <String, dynamic>{
  if (instance.name case final $value?)
    'name': OperationalHealthServiceOutput._write_name($value),
  if (instance.oldestPendingSeconds case final $value?)
    'oldestPendingSeconds':
        OperationalHealthServiceOutput._write_oldestPendingSeconds($value),
  if (instance.queueDepth case final $value?)
    'queueDepth': OperationalHealthServiceOutput._write_queueDepth($value),
  if (instance.reason case final $value?)
    'reason': OperationalHealthServiceOutput._write_reason($value),
  if (instance.status case final $value?)
    'status': OperationalHealthServiceOutput._write_status($value),
};
