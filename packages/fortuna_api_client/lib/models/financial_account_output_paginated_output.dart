// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'financial_account_output.dart';

part 'financial_account_output_paginated_output.g.dart';

@JsonSerializable()
class FinancialAccountOutputPaginatedOutput {
  const FinancialAccountOutputPaginatedOutput({
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

  factory FinancialAccountOutputPaginatedOutput.fromJson(
    Map<String, Object?> json,
  ) => _$FinancialAccountOutputPaginatedOutputFromJson(json);

  final List<FinancialAccountOutput>? data;
  final List<String>? errors;
  final List<String>? messages;
  final int? pageNumber;
  final int? pageSize;
  final bool? success;
  final DateTime? timestamp;
  final int? totalItems;
  final int? totalPages;

  Map<String, Object?> toJson() =>
      _$FinancialAccountOutputPaginatedOutputToJson(this);
}
