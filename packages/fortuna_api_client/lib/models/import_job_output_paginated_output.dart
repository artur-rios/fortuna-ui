// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'import_job_output.dart';

part 'import_job_output_paginated_output.g.dart';

@JsonSerializable()
class ImportJobOutputPaginatedOutput {
  const ImportJobOutputPaginatedOutput({
    this.data,
    this.errors,
    this.messages,
    this.pageNumber,
    this.pageSize,
    this.success,
    this.timestamp,
    this.totalItems,
    this.totalPages,
  });

  factory ImportJobOutputPaginatedOutput.fromJson(Map<String, Object?> json) =>
      _$ImportJobOutputPaginatedOutputFromJson(json);

  final List<ImportJobOutput>? data;
  final List<String>? errors;
  final List<String>? messages;
  final int? pageNumber;
  final int? pageSize;
  final bool? success;
  final DateTime? timestamp;
  final int? totalItems;
  final int? totalPages;

  Map<String, Object?> toJson() => _$ImportJobOutputPaginatedOutputToJson(this);
}
