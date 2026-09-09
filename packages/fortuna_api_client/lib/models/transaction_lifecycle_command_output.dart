// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'transaction_lifecycle_command_output.g.dart';

@JsonSerializable()
class TransactionLifecycleCommandOutput {
  const TransactionLifecycleCommandOutput({this.id});

  factory TransactionLifecycleCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$TransactionLifecycleCommandOutputFromJson(json);

  final String? id;

  Map<String, Object?> toJson() =>
      _$TransactionLifecycleCommandOutputToJson(this);
}
