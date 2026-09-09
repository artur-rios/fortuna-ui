// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'materialize_recurring_transactions_command.g.dart';

@JsonSerializable()
class MaterializeRecurringTransactionsCommand {
  const MaterializeRecurringTransactionsCommand({this.ownerId});

  factory MaterializeRecurringTransactionsCommand.fromJson(
    Map<String, Object?> json,
  ) => _$MaterializeRecurringTransactionsCommandFromJson(json);

  final String? ownerId;

  Map<String, Object?> toJson() =>
      _$MaterializeRecurringTransactionsCommandToJson(this);
}
