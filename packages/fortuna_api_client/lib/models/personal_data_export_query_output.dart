// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'data_export_status.dart';

part 'personal_data_export_query_output.g.dart';

@JsonSerializable()
class PersonalDataExportQueryOutput {
  const PersonalDataExportQueryOutput({
    this.contentType,
    this.createdAt,
    this.expiresAt,
    this.failureReason,
    this.fileName,
    this.jobId,
    this.progress,
    this.status,
    this.updatedAt,
  });

  factory PersonalDataExportQueryOutput.fromJson(Map<String, Object?> json) =>
      _$PersonalDataExportQueryOutputFromJson(json);

  final String? contentType;
  final DateTime? createdAt;
  final DateTime? expiresAt;
  final String? failureReason;
  final String? fileName;
  final String? jobId;
  final int? progress;
  final DataExportStatus? status;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$PersonalDataExportQueryOutputToJson(this);
}
