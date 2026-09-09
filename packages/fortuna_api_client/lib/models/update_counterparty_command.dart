// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'update_counterparty_command.g.dart';

@JsonSerializable()
class UpdateCounterpartyCommand {
  const UpdateCounterpartyCommand({this.name});

  factory UpdateCounterpartyCommand.fromJson(Map<String, Object?> json) =>
      _$UpdateCounterpartyCommandFromJson(json);

  final String? name;

  Map<String, Object?> toJson() => _$UpdateCounterpartyCommandToJson(this);
}
