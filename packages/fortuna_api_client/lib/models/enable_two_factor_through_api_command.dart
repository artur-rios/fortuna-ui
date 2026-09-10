// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'enable_two_factor_through_api_command.g.dart';

@JsonSerializable()
class EnableTwoFactorThroughApiCommand {
  const EnableTwoFactorThroughApiCommand({this.methods});

  factory EnableTwoFactorThroughApiCommand.fromJson(
    Map<String, Object?> json,
  ) => _$EnableTwoFactorThroughApiCommandFromJson(json);

  final List<String>? methods;

  Map<String, Object?> toJson() =>
      _$EnableTwoFactorThroughApiCommandToJson(this);
}
