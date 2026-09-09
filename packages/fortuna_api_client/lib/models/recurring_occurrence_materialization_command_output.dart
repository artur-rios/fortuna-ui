// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'recurring_occurrence_materialization_command_output.g.dart';

@JsonSerializable()
class RecurringOccurrenceMaterializationCommandOutput {
  const RecurringOccurrenceMaterializationCommandOutput({
    this.error,
    this.isPossibleDuplicate,
    this.occurredOn,
    this.transactionId,
  });

  factory RecurringOccurrenceMaterializationCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$RecurringOccurrenceMaterializationCommandOutputFromJson(json);

  final String? error;
  final bool? isPossibleDuplicate;
  final DateTime? occurredOn;
  final String? transactionId;

  Map<String, Object?> toJson() =>
      _$RecurringOccurrenceMaterializationCommandOutputToJson(this);
}
