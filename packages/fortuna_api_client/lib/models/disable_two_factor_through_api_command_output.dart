// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'disable_two_factor_through_api_command_output.g.dart';

@JsonSerializable()
class DisableTwoFactorThroughApiCommandOutput {
  const DisableTwoFactorThroughApiCommandOutput({this.disabled});

  factory DisableTwoFactorThroughApiCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$DisableTwoFactorThroughApiCommandOutputFromJson(json);

  final bool? disabled;

  Map<String, Object?> toJson() =>
      _$DisableTwoFactorThroughApiCommandOutputToJson(this);
}
