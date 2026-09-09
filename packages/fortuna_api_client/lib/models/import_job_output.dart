// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'import_job_status.dart';
import 'transaction_source_type.dart';

part 'import_job_output.g.dart';

@JsonSerializable()
class ImportJobOutput {
  const ImportJobOutput({
    this.connectionId,
    this.createdAt,
    this.duplicateCount,
    this.failureReason,
    this.id,
    this.importedCount,
    this.periodEnd,
    this.periodStart,
    this.processedCount,
    this.rejectedCount,
    this.sourceType,
    this.status,
    this.updatedAt,
  });

  factory ImportJobOutput.fromJson(Map<String, Object?> json) =>
      _$ImportJobOutputFromJson(json);

  final String? connectionId;
  final DateTime? createdAt;
  final int? duplicateCount;
  final String? failureReason;
  final String? id;
  final int? importedCount;
  final DateTime? periodEnd;
  final DateTime? periodStart;
  final int? processedCount;
  final int? rejectedCount;
  final TransactionSourceType? sourceType;
  final ImportJobStatus? status;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$ImportJobOutputToJson(this);
}
