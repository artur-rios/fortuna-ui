// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'financial_account_lifecycle_command_output.g.dart';

@JsonSerializable()
class FinancialAccountLifecycleCommandOutput {
  const FinancialAccountLifecycleCommandOutput({this.id});

  factory FinancialAccountLifecycleCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$FinancialAccountLifecycleCommandOutputFromJson(json);

  final String? id;

  Map<String, Object?> toJson() =>
      _$FinancialAccountLifecycleCommandOutputToJson(this);
}
