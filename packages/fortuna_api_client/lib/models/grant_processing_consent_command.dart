// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'grant_processing_consent_command.g.dart';

@JsonSerializable()
class GrantProcessingConsentCommand {
  const GrantProcessingConsentCommand({this.purpose, this.version});

  factory GrantProcessingConsentCommand.fromJson(Map<String, Object?> json) =>
      _$GrantProcessingConsentCommandFromJson(json);

  final String? purpose;
  final String? version;

  Map<String, Object?> toJson() => _$GrantProcessingConsentCommandToJson(this);
}
