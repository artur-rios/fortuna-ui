// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'budget_output.dart';

part 'budget_output_data_output.g.dart';

@JsonSerializable()
class BudgetOutputDataOutput {
  const BudgetOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory BudgetOutputDataOutput.fromJson(Map<String, Object?> json) =>
      _$BudgetOutputDataOutputFromJson(json);

  final BudgetOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() => _$BudgetOutputDataOutputToJson(this);
}
