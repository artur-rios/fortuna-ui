// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'counterparty_merge_command_output.g.dart';

@JsonSerializable()
class CounterpartyMergeCommandOutput {
  const CounterpartyMergeCommandOutput({
    this.id,
    this.reassignedTransactionCount,
    this.sourceId,
    this.targetId,
  });

  factory CounterpartyMergeCommandOutput.fromJson(Map<String, Object?> json) =>
      _$CounterpartyMergeCommandOutputFromJson(json);

  final String? id;
  final int? reassignedTransactionCount;
  final String? sourceId;
  final String? targetId;

  Map<String, Object?> toJson() => _$CounterpartyMergeCommandOutputToJson(this);
}
