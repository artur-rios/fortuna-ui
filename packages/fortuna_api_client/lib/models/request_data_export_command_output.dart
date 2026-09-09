// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'data_export_delivery.dart';
import 'data_export_format.dart';

part 'request_data_export_command_output.g.dart';

@JsonSerializable()
class RequestDataExportCommandOutput {
  const RequestDataExportCommandOutput({
    this.contentType,
    this.delivery,
    this.exportId,
    this.fileName,
    this.format,
    this.jobId,
    this.rowCount,
  });

  factory RequestDataExportCommandOutput.fromJson(Map<String, Object?> json) =>
      _$RequestDataExportCommandOutputFromJson(json);

  final String? contentType;
  final DataExportDelivery? delivery;
  final String? exportId;
  final String? fileName;
  final DataExportFormat? format;
  final String? jobId;
  final int? rowCount;

  Map<String, Object?> toJson() => _$RequestDataExportCommandOutputToJson(this);
}
