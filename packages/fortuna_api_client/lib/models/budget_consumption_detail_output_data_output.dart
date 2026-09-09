// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'budget_consumption_detail_output.dart';

part 'budget_consumption_detail_output_data_output.g.dart';

@JsonSerializable()
class BudgetConsumptionDetailOutputDataOutput {
  const BudgetConsumptionDetailOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory BudgetConsumptionDetailOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$BudgetConsumptionDetailOutputDataOutputFromJson(json);

  final BudgetConsumptionDetailOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$BudgetConsumptionDetailOutputDataOutputToJson(this);
}
