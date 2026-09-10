// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'get_two_factor_status_through_api_command_output.g.dart';

@JsonSerializable()
class GetTwoFactorStatusThroughApiCommandOutput {
  const GetTwoFactorStatusThroughApiCommandOutput({
    this.appEnabled,
    this.emailEnabled,
    this.isActive,
    this.remainingRecoveryCodes,
  });

  factory GetTwoFactorStatusThroughApiCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$GetTwoFactorStatusThroughApiCommandOutputFromJson(json);

  final bool? appEnabled;
  final bool? emailEnabled;
  final bool? isActive;
  final int? remainingRecoveryCodes;

  Map<String, Object?> toJson() =>
      _$GetTwoFactorStatusThroughApiCommandOutputToJson(this);
}
