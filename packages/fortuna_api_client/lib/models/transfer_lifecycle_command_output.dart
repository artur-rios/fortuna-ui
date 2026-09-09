// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'transfer_lifecycle_command_output.g.dart';

@JsonSerializable()
class TransferLifecycleCommandOutput {
  const TransferLifecycleCommandOutput({this.id});

  factory TransferLifecycleCommandOutput.fromJson(Map<String, Object?> json) =>
      _$TransferLifecycleCommandOutputFromJson(json);

  final String? id;

  Map<String, Object?> toJson() => _$TransferLifecycleCommandOutputToJson(this);
}
