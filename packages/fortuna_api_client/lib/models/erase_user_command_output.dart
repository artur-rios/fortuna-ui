// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'erase_user_command_output.g.dart';

@JsonSerializable()
class EraseUserCommandOutput {
  const EraseUserCommandOutput({
    this.erased,
    this.irreversible,
    this.revokedConnections,
  });

  factory EraseUserCommandOutput.fromJson(Map<String, Object?> json) =>
      _$EraseUserCommandOutputFromJson(json);

  final Map<String, int>? erased;
  final bool? irreversible;
  final int? revokedConnections;

  Map<String, Object?> toJson() => _$EraseUserCommandOutputToJson(this);
}
