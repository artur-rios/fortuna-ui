// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'import_job_status.dart';

part 'import_excel_workbook_command_output.g.dart';

@JsonSerializable()
class ImportExcelWorkbookCommandOutput {
  const ImportExcelWorkbookCommandOutput({this.importJobId, this.status});

  factory ImportExcelWorkbookCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$ImportExcelWorkbookCommandOutputFromJson(json);

  final String? importJobId;
  final ImportJobStatus? status;

  Map<String, Object?> toJson() =>
      _$ImportExcelWorkbookCommandOutputToJson(this);
}
