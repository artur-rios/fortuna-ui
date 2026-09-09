// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'create_counterparty_command.g.dart';

@JsonSerializable()
class CreateCounterpartyCommand {
  const CreateCounterpartyCommand({this.name});

  factory CreateCounterpartyCommand.fromJson(Map<String, Object?> json) =>
      _$CreateCounterpartyCommandFromJson(json);

  final String? name;

  Map<String, Object?> toJson() => _$CreateCounterpartyCommandToJson(this);
}
