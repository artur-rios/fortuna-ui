// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'investment_lifecycle_command_output.g.dart';

@JsonSerializable()
class InvestmentLifecycleCommandOutput {
  const InvestmentLifecycleCommandOutput({this.id});

  factory InvestmentLifecycleCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$InvestmentLifecycleCommandOutputFromJson(json);

  final String? id;

  Map<String, Object?> toJson() =>
      _$InvestmentLifecycleCommandOutputToJson(this);
}
