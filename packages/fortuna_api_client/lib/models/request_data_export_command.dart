// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'data_export_filter_input.dart';
import 'data_export_sort_input.dart';

part 'request_data_export_command.g.dart';

@JsonSerializable()
class RequestDataExportCommand {
  const RequestDataExportCommand({
    this.columns,
    this.displayCurrencyCode,
    this.filters,
    this.format,
    this.locale,
    this.recordSet,
    this.sorts,
  });

  factory RequestDataExportCommand.fromJson(Map<String, Object?> json) =>
      _$RequestDataExportCommandFromJson(json);

  final List<String>? columns;
  final String? displayCurrencyCode;
  final List<DataExportFilterInput>? filters;
  final String? format;
  final String? locale;
  final String? recordSet;
  final List<DataExportSortInput>? sorts;

  Map<String, Object?> toJson() => _$RequestDataExportCommandToJson(this);
}
