// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_entry_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditEntryOutput _$AuditEntryOutputFromJson(Map<String, dynamic> json) =>
    AuditEntryOutput(
      actorUserId: json['actorUserId'] as String?,
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
    );

Map<String, dynamic> _$AuditEntryOutputToJson(AuditEntryOutput instance) =>
    <String, dynamic>{
      'actorUserId': instance.actorUserId,
      'entityId': instance.entityId,
      'entityType': instance.entityType,
      'occurredAt': instance.occurredAt?.toIso8601String(),
      'operation': instance.operation,
      'outcome': instance.outcome,
      'reason': instance.reason,
    };
