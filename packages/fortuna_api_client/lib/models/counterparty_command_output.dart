// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'counterparty_command_output.g.dart';

@JsonSerializable()
class CounterpartyCommandOutput {
  const CounterpartyCommandOutput({
    this.createdAt,
    this.id,
    this.isDeleted,
    this.name,
    this.reused,
    this.updatedAt,
  });

  factory CounterpartyCommandOutput.fromJson(Map<String, Object?> json) =>
      _$CounterpartyCommandOutputFromJson(json);

  final DateTime? createdAt;
  final String? id;
  final bool? isDeleted;
  final String? name;
  final bool? reused;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$CounterpartyCommandOutputToJson(this);
}
