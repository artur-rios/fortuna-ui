// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'synchronize_connection_command.g.dart';

@JsonSerializable()
class SynchronizeConnectionCommand {
  const SynchronizeConnectionCommand({this.periodEnd, this.periodStart});

  factory SynchronizeConnectionCommand.fromJson(Map<String, Object?> json) =>
      _$SynchronizeConnectionCommandFromJson(json);

  final DateTime? periodEnd;
  final DateTime? periodStart;

  Map<String, Object?> toJson() => _$SynchronizeConnectionCommandToJson(this);
}
