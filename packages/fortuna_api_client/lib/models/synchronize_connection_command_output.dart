// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'import_job_status.dart';

part 'synchronize_connection_command_output.g.dart';

@JsonSerializable()
class SynchronizeConnectionCommandOutput {
  const SynchronizeConnectionCommandOutput({
    this.importJobId,
    this.periodEnd,
    this.periodStart,
    this.status,
  });

  factory SynchronizeConnectionCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$SynchronizeConnectionCommandOutputFromJson(json);

  final String? importJobId;
  final DateTime? periodEnd;
  final DateTime? periodStart;
  final ImportJobStatus? status;

  Map<String, Object?> toJson() =>
      _$SynchronizeConnectionCommandOutputToJson(this);
}
