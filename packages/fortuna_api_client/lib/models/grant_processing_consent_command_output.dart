// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'grant_processing_consent_command_output.g.dart';

@JsonSerializable()
class GrantProcessingConsentCommandOutput {
  const GrantProcessingConsentCommandOutput({
    this.grantedAt,
    this.id,
    this.isCurrent,
    this.purpose,
    this.version,
  });

  factory GrantProcessingConsentCommandOutput.fromJson(
    Map<String, Object?> json,
  ) => _$GrantProcessingConsentCommandOutputFromJson(json);

  final DateTime? grantedAt;
  final String? id;
  final bool? isCurrent;
  final String? purpose;
  final String? version;

  Map<String, Object?> toJson() =>
      _$GrantProcessingConsentCommandOutputToJson(this);
}
