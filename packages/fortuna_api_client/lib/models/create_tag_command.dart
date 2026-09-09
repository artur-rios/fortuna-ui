// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'create_tag_command.g.dart';

@JsonSerializable()
class CreateTagCommand {
  const CreateTagCommand({this.name});

  factory CreateTagCommand.fromJson(Map<String, Object?> json) =>
      _$CreateTagCommandFromJson(json);

  final String? name;

  Map<String, Object?> toJson() => _$CreateTagCommandToJson(this);
}
