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
    entityId: !json.containsKey('entityId')
        ? null
        : AuditEntryOutput._read_entityId(json['entityId']),
    entityType: !json.containsKey('entityType')
        ? null
        : AuditEntryOutput._read_entityType(json['entityType']),
    occurredAt: AuditEntryOutput._read_occurredAt(json['occurredAt']),
    operation: !json.containsKey('operation')
        ? null
        : AuditEntryOutput._read_operation(json['operation']),
    outcome: AuditEntryOutput._read_outcome(json['outcome']),
    reason: !json.containsKey('reason')
        ? null
        : AuditEntryOutput._read_reason(json['reason']),
    subjectReference: json['subjectReference'] as String?,
  );
}

Map<String, dynamic> _$AuditEntryOutputToJson(AuditEntryOutput instance) =>
    <String, dynamic>{
      if (instance.entityId case final $value?)
        'entityId': AuditEntryOutput._write_entityId($value),
      if (instance.entityType case final $value?)
        'entityType': AuditEntryOutput._write_entityType($value),
      'occurredAt': ?AuditEntryOutput._write_occurredAt(instance.occurredAt),
      if (instance.operation case final $value?)
        'operation': AuditEntryOutput._write_operation($value),
      'outcome': ?AuditEntryOutput._write_outcome(instance.outcome),
      if (instance.reason case final $value?)
        'reason': AuditEntryOutput._write_reason($value),
      'subjectReference': ?instance.subjectReference,
    };
