// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'data_export_format.dart';
import 'data_export_status.dart';

part 'retrieve_data_export_query_output.g.dart';

@JsonSerializable()
class RetrieveDataExportQueryOutput {
  const RetrieveDataExportQueryOutput({
    this.contentType,
    this.createdAt,
    this.expiresAt,
    this.failureReason,
    this.fileName,
    this.format,
    this.id,
    this.jobId,
    this.rowCount,
    this.status,
    this.updatedAt,
  });

  factory RetrieveDataExportQueryOutput.fromJson(Map<String, Object?> json) =>
      _$RetrieveDataExportQueryOutputFromJson(json);

  final String? contentType;
  final DateTime? createdAt;
  final DateTime? expiresAt;
  final String? failureReason;
  final String? fileName;
  final DataExportFormat? format;
  final String? id;
  final String? jobId;
  final int? rowCount;
  final DataExportStatus? status;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$RetrieveDataExportQueryOutputToJson(this);
}
