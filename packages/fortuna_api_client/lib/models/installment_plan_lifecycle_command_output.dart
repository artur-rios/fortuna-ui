// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'installment_plan_lifecycle_command_output.g.dart';

@JsonSerializable()
class InstallmentPlanLifecycleCommandOutput {
  const InstallmentPlanLifecycleCommandOutput({this.id});

  factory InstallmentPlanLifecycleCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$InstallmentPlanLifecycleCommandOutputFromJson(json);

  final String? id;

  Map<String, Object?> toJson() =>
      _$InstallmentPlanLifecycleCommandOutputToJson(this);
}
