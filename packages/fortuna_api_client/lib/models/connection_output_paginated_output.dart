// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'connection_output.dart';

part 'connection_output_paginated_output.g.dart';

@JsonSerializable()
class ConnectionOutputPaginatedOutput {
  const ConnectionOutputPaginatedOutput({
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

  factory ConnectionOutputPaginatedOutput.fromJson(Map<String, Object?> json) =>
      _$ConnectionOutputPaginatedOutputFromJson(json);

  final List<ConnectionOutput>? data;
  final List<String>? errors;
  final List<String>? messages;
  final int? pageNumber;
  final int? pageSize;
  final bool? success;
  final DateTime? timestamp;
  final int? totalItems;
  final int? totalPages;

  Map<String, Object?> toJson() =>
      _$ConnectionOutputPaginatedOutputToJson(this);
}
