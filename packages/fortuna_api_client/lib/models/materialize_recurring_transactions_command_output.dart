// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'recurring_rule_materialization_command_output.dart';

part 'materialize_recurring_transactions_command_output.g.dart';

@JsonSerializable()
class MaterializeRecurringTransactionsCommandOutput {
  const MaterializeRecurringTransactionsCommandOutput({
    this.createdCount,
    this.materializedThrough,
    this.possibleDuplicateCount,
    this.rules,
  });

  factory MaterializeRecurringTransactionsCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$MaterializeRecurringTransactionsCommandOutputFromJson(json);

  final int? createdCount;
  final DateTime? materializedThrough;
  final int? possibleDuplicateCount;
  final List<RecurringRuleMaterializationCommandOutput>? rules;

  Map<String, Object?> toJson() =>
      _$MaterializeRecurringTransactionsCommandOutputToJson(this);
}
