// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'recurring_transaction_lifecycle_command_output.g.dart';

@JsonSerializable()
class RecurringTransactionLifecycleCommandOutput {
  const RecurringTransactionLifecycleCommandOutput({
    this.id,
    this.materializedOccurrencesChanged,
  });

  factory RecurringTransactionLifecycleCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$RecurringTransactionLifecycleCommandOutputFromJson(json);

  final String? id;
  final bool? materializedOccurrencesChanged;

  Map<String, Object?> toJson() =>
      _$RecurringTransactionLifecycleCommandOutputToJson(this);
}
