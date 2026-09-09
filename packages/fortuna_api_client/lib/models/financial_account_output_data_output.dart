// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'financial_account_output.dart';

part 'financial_account_output_data_output.g.dart';

@JsonSerializable()
class FinancialAccountOutputDataOutput {
  const FinancialAccountOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory FinancialAccountOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$FinancialAccountOutputDataOutputFromJson(json);

  final FinancialAccountOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$FinancialAccountOutputDataOutputToJson(this);
}
