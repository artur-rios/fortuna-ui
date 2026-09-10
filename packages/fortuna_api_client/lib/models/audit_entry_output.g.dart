// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_entry_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditEntryOutput _$AuditEntryOutputFromJson(Map<String, dynamic> json) =>
    AuditEntryOutput(
      entityId: json['entityId'] as String?,
      entityType: json['entityType'] as String?,
      occurredAt: json['occurredAt'] == null
          ? null
          : DateTime.parse(json['occurredAt'] as String),
      operation: json['operation'] as String?,
      outcome: json['outcome'] == null
          ? null
          : AuditOutcome.fromJson((json['outcome'] as num).toInt()),
      reason: json['reason'] as String?,
      subjectReference: json['subjectReference'] as String?,
    );

Map<String, dynamic> _$AuditEntryOutputToJson(AuditEntryOutput instance) =>
    <String, dynamic>{
      'entityId': instance.entityId,
      'entityType': instance.entityType,
      'occurredAt': instance.occurredAt?.toIso8601String(),
      'operation': instance.operation,
      'outcome': _$AuditOutcomeEnumMap[instance.outcome],
      'reason': instance.reason,
      'subjectReference': instance.subjectReference,
    };

const _$AuditOutcomeEnumMap = {
  AuditOutcome.value1: 1,
  AuditOutcome.value2: 2,
  AuditOutcome.$unknown: r'$unknown',
};
