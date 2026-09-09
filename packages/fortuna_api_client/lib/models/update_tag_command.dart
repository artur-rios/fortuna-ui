// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'update_tag_command.g.dart';

@JsonSerializable()
class UpdateTagCommand {
  const UpdateTagCommand({this.name});

  factory UpdateTagCommand.fromJson(Map<String, Object?> json) =>
      _$UpdateTagCommandFromJson(json);

  final String? name;

  Map<String, Object?> toJson() => _$UpdateTagCommandToJson(this);
}
