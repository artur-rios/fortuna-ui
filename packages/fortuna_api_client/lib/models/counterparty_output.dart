// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'counterparty_output.g.dart';

@JsonSerializable()
class CounterpartyOutput {
  const CounterpartyOutput({
    this.createdAt,
    this.id,
    this.isDeleted,
    this.name,
    this.updatedAt,
  });

  factory CounterpartyOutput.fromJson(Map<String, Object?> json) =>
      _$CounterpartyOutputFromJson(json);

  final DateTime? createdAt;
  final String? id;
  final bool? isDeleted;
  final String? name;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$CounterpartyOutputToJson(this);
}
