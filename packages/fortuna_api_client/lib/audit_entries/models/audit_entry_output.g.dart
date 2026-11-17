// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_entry_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditEntryOutput _$AuditEntryOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'entityId',
      'entityType',
      'occurredAt',
      'operation',
      'outcome',
      'reason',
      'subjectReference',
    ],
    disallowNullValues: const ['occurredAt', 'outcome', 'subjectReference'],
  );
  return AuditEntryOutput(
    entityId: json['entityId'] as String?,
    entityType: json['entityType'] as String?,
    occurredAt: AuditEntryOutput._read_occurredAt(json['occurredAt']),
    operation: json['operation'] as String?,
    outcome: AuditEntryOutput._read_outcome(json['outcome']),
    reason: json['reason'] as String?,
    subjectReference: json['subjectReference'] as String?,
  );
}

Map<String, dynamic> _$AuditEntryOutputToJson(AuditEntryOutput instance) =>
    <String, dynamic>{
      'entityId': ?instance.entityId,
      'entityType': ?instance.entityType,
      'occurredAt': ?AuditEntryOutput._write_occurredAt(instance.occurredAt),
      'operation': ?instance.operation,
      'outcome': ?AuditEntryOutput._write_outcome(instance.outcome),
      'reason': ?instance.reason,
      'subjectReference': ?instance.subjectReference,
    };
