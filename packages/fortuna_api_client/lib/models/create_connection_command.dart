// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'create_connection_command.g.dart';

@JsonSerializable()
class CreateConnectionCommand {
  const CreateConnectionCommand({this.dataSource, this.externalReference});

  factory CreateConnectionCommand.fromJson(Map<String, Object?> json) =>
      _$CreateConnectionCommandFromJson(json);

  final String? dataSource;
  final String? externalReference;

  Map<String, Object?> toJson() => _$CreateConnectionCommandToJson(this);
}
