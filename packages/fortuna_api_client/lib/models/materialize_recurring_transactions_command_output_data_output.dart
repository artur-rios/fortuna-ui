// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'materialize_recurring_transactions_command_output.dart';

part 'materialize_recurring_transactions_command_output_data_output.g.dart';

@JsonSerializable()
class MaterializeRecurringTransactionsCommandOutputDataOutput {
  const MaterializeRecurringTransactionsCommandOutputDataOutput({
    this.data,
    this.errors,
    this.messages,
    this.success,
    this.timestamp,
  });

  factory MaterializeRecurringTransactionsCommandOutputDataOutput.fromJson(
    Map<String, Object?> json,
  ) => _$MaterializeRecurringTransactionsCommandOutputDataOutputFromJson(json);

  final MaterializeRecurringTransactionsCommandOutput? data;
  final List<String>? errors;
  final List<String>? messages;
  final bool? success;
  final DateTime? timestamp;

  Map<String, Object?> toJson() =>
      _$MaterializeRecurringTransactionsCommandOutputDataOutputToJson(this);
}
