// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'recurring_occurrence_materialization_command_output.dart';

part 'recurring_rule_materialization_command_output.g.dart';

@JsonSerializable()
class RecurringRuleMaterializationCommandOutput {
  const RecurringRuleMaterializationCommandOutput({
    this.createdCount,
    this.isComplete,
    this.occurrences,
    this.possibleDuplicateCount,
    this.ruleId,
    this.skipReason,
  });

  factory RecurringRuleMaterializationCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$RecurringRuleMaterializationCommandOutputFromJson(json);

  final int? createdCount;
  final bool? isComplete;
  final List<RecurringOccurrenceMaterializationCommandOutput>? occurrences;
  final int? possibleDuplicateCount;
  final String? ruleId;
  final String? skipReason;

  Map<String, Object?> toJson() =>
      _$RecurringRuleMaterializationCommandOutputToJson(this);
}
