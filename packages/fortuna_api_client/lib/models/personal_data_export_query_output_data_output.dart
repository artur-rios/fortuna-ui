// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'personal_data_export_query_output.dart';

part 'personal_data_export_query_output_data_output.g.dart';

@JsonSerializable()
class PersonalDataExportQueryOutputDataOutput {
  const PersonalDataExportQueryOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory PersonalDataExportQueryOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$PersonalDataExportQueryOutputDataOutputFromJson(json);

  final PersonalDataExportQueryOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$PersonalDataExportQueryOutputDataOutputToJson(this);
}
