// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'erase_user_command.g.dart';

@JsonSerializable()
class EraseUserCommand {
  const EraseUserCommand({this.confirmation});

  factory EraseUserCommand.fromJson(Map<String, Object?> json) =>
      _$EraseUserCommandFromJson(json);

  final String? confirmation;

  Map<String, Object?> toJson() => _$EraseUserCommandToJson(this);
}
