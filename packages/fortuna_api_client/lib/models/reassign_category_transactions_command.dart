// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'reassign_category_transactions_command.g.dart';

@JsonSerializable()
class ReassignCategoryTransactionsCommand {
  const ReassignCategoryTransactionsCommand({
    this.includeDescendants,
    this.targetCategoryId,
  });

  factory ReassignCategoryTransactionsCommand.fromJson(
    Map<String, Object?> json,
  ) => _$ReassignCategoryTransactionsCommandFromJson(json);

  final bool? includeDescendants;
  final String? targetCategoryId;

  Map<String, Object?> toJson() =>
      _$ReassignCategoryTransactionsCommandToJson(this);
}
