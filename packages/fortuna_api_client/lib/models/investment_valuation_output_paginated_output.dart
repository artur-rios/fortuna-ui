// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'investment_valuation_output.dart';

part 'investment_valuation_output_paginated_output.g.dart';

@JsonSerializable()
class InvestmentValuationOutputPaginatedOutput {
  const InvestmentValuationOutputPaginatedOutput({
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

  factory InvestmentValuationOutputPaginatedOutput.fromJson(
    Map<String, Object?> json,
  ) => _$InvestmentValuationOutputPaginatedOutputFromJson(json);

  final List<InvestmentValuationOutput>? data;
  final List<String>? errors;
  final List<String>? messages;
  final int? pageNumber;
  final int? pageSize;
  final bool? success;
  final DateTime? timestamp;
  final int? totalItems;
  final int? totalPages;

  Map<String, Object?> toJson() =>
      _$InvestmentValuationOutputPaginatedOutputToJson(this);
}
