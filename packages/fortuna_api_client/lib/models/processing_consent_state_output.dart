// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'processing_consent_state_output.g.dart';

@JsonSerializable()
class ProcessingConsentStateOutput {
  const ProcessingConsentStateOutput({
    this.currentVersion,
    this.grantedAt,
    this.grantedVersion,
    this.isCurrent,
    this.purpose,
  });

  factory ProcessingConsentStateOutput.fromJson(Map<String, Object?> json) =>
      _$ProcessingConsentStateOutputFromJson(json);

  final String? currentVersion;
  final DateTime? grantedAt;
  final String? grantedVersion;
  final bool? isCurrent;
  final String? purpose;

  Map<String, Object?> toJson() => _$ProcessingConsentStateOutputToJson(this);
}
