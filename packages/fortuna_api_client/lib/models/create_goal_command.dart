// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'create_goal_command.g.dart';

@JsonSerializable()
class CreateGoalCommand {
  const CreateGoalCommand({
    this.accountIds,
    this.currencyCode,
    this.investmentIds,
    this.name,
    this.targetAmount,
    this.targetDate,
  });

  factory CreateGoalCommand.fromJson(Map<String, Object?> json) =>
      _$CreateGoalCommandFromJson(json);

  final List<String>? accountIds;
  final String? currencyCode;
  final List<String>? investmentIds;
  final String? name;
  final String? targetAmount;
  final DateTime? targetDate;

  Map<String, Object?> toJson() => _$CreateGoalCommandToJson(this);
}
