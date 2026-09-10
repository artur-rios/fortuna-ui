// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'withdraw_processing_consent_command_output.g.dart';

@JsonSerializable()
class WithdrawProcessingConsentCommandOutput {
  const WithdrawProcessingConsentCommandOutput({
    this.purpose,
    this.revokedConnections,
    this.stoppedSynchronizations,
  });

  factory WithdrawProcessingConsentCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$WithdrawProcessingConsentCommandOutputFromJson(json);

  final String? purpose;
  final int? revokedConnections;
  final int? stoppedSynchronizations;

  Map<String, Object?> toJson() =>
      _$WithdrawProcessingConsentCommandOutputToJson(this);
}
