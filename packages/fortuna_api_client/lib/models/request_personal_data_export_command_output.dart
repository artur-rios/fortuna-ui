// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'data_export_status.dart';

part 'request_personal_data_export_command_output.g.dart';

@JsonSerializable()
class RequestPersonalDataExportCommandOutput {
  const RequestPersonalDataExportCommandOutput({
    this.expiresAt,
    this.jobId,
    this.progress,
    this.status,
  });

  factory RequestPersonalDataExportCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$RequestPersonalDataExportCommandOutputFromJson(json);

  final DateTime? expiresAt;
  final String? jobId;
  final int? progress;
  final DataExportStatus? status;

  Map<String, Object?> toJson() =>
      _$RequestPersonalDataExportCommandOutputToJson(this);
}
