// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'enable_two_factor_through_api_command_output.g.dart';

@JsonSerializable()
class EnableTwoFactorThroughApiCommandOutput {
  const EnableTwoFactorThroughApiCommandOutput({
    this.emailCodeSent,
    this.otpAuthUri,
  });

  factory EnableTwoFactorThroughApiCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$EnableTwoFactorThroughApiCommandOutputFromJson(json);

  final bool? emailCodeSent;
  final String? otpAuthUri;

  Map<String, Object?> toJson() =>
      _$EnableTwoFactorThroughApiCommandOutputToJson(this);
}
