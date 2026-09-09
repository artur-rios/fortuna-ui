// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'reassign_category_transactions_command_output.g.dart';

@JsonSerializable()
class ReassignCategoryTransactionsCommandOutput {
  const ReassignCategoryTransactionsCommandOutput({
    this.id,
    this.includeDescendants,
    this.reassignedCount,
    this.targetCategoryId,
  });

  factory ReassignCategoryTransactionsCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$ReassignCategoryTransactionsCommandOutputFromJson(json);

  final String? id;
  final bool? includeDescendants;
  final int? reassignedCount;
  final String? targetCategoryId;

  Map<String, Object?> toJson() =>
      _$ReassignCategoryTransactionsCommandOutputToJson(this);
}
