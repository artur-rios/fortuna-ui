// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'attachment_output.dart';

part 'attachment_output_paginated_output.g.dart';

@JsonSerializable()
class AttachmentOutputPaginatedOutput {
  const AttachmentOutputPaginatedOutput({
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

  factory AttachmentOutputPaginatedOutput.fromJson(Map<String, Object?> json) =>
      _$AttachmentOutputPaginatedOutputFromJson(json);

  final List<AttachmentOutput>? data;
  final List<String>? errors;
  final List<String>? messages;
  final int? pageNumber;
  final int? pageSize;
  final bool? success;
  final DateTime? timestamp;
  final int? totalItems;
  final int? totalPages;

  Map<String, Object?> toJson() =>
      _$AttachmentOutputPaginatedOutputToJson(this);
}
