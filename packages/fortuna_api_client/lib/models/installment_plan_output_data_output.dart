// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'installment_plan_output.dart';

part 'installment_plan_output_data_output.g.dart';

@JsonSerializable()
class InstallmentPlanOutputDataOutput {
  const InstallmentPlanOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory InstallmentPlanOutputDataOutput.fromJson(Map<String, Object?> json) =>
      _$InstallmentPlanOutputDataOutputFromJson(json);

  final InstallmentPlanOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$InstallmentPlanOutputDataOutputToJson(this);
}
