// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'import_excel_workbook_command_output.dart';

part 'import_excel_workbook_command_output_data_output.g.dart';

@JsonSerializable()
class ImportExcelWorkbookCommandOutputDataOutput {
  const ImportExcelWorkbookCommandOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory ImportExcelWorkbookCommandOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$ImportExcelWorkbookCommandOutputDataOutputFromJson(json);

  final ImportExcelWorkbookCommandOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$ImportExcelWorkbookCommandOutputDataOutputToJson(this);
}
