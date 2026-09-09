// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'audit_outcome.dart';

part 'audit_entry_output.g.dart';

@JsonSerializable()
class AuditEntryOutput {
  const AuditEntryOutput({
    this.actorUserId,
    this.entityId,
    this.entityType,
    this.occurredAt,
    this.operation,
    this.outcome,
    this.reason,
  });

  factory AuditEntryOutput.fromJson(Map<String, Object?> json) =>
      _$AuditEntryOutputFromJson(json);

  final String? actorUserId;
  final String? entityId;
  final String? entityType;
  final DateTime? occurredAt;
  final String? operation;
  final AuditOutcome? outcome;
  final String? reason;

  Map<String, Object?> toJson() => _$AuditEntryOutputToJson(this);
}
