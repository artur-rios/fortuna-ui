// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'import_job_status.dart';
import 'transaction_source_type.dart';

part 'retry_import_job_command_output.g.dart';

@JsonSerializable()
class RetryImportJobCommandOutput {
  const RetryImportJobCommandOutput({
    this.createdAt,
    this.duplicateCount,
    this.id,
    this.importedCount,
    this.periodEnd,
    this.periodStart,
    this.rejectedCount,
    this.sourceType,
    this.status,
    this.updatedAt,
  });

  factory RetryImportJobCommandOutput.fromJson(Map<String, Object?> json) =>
      _$RetryImportJobCommandOutputFromJson(json);

  final DateTime? createdAt;
  final int? duplicateCount;
  final String? id;
  final int? importedCount;
  final DateTime? periodEnd;
  final DateTime? periodStart;
  final int? rejectedCount;
  final TransactionSourceType? sourceType;
  final ImportJobStatus? status;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$RetryImportJobCommandOutputToJson(this);
}
