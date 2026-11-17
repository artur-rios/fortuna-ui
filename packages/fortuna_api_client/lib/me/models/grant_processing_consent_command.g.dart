// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grant_processing_consent_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GrantProcessingConsentCommand _$GrantProcessingConsentCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['purpose', 'version']);
  return GrantProcessingConsentCommand(
    purpose: !json.containsKey('purpose')
        ? null
        : GrantProcessingConsentCommand._read_purpose(json['purpose']),
    version: !json.containsKey('version')
        ? null
        : GrantProcessingConsentCommand._read_version(json['version']),
  );
}

Map<String, dynamic> _$GrantProcessingConsentCommandToJson(
  GrantProcessingConsentCommand instance,
) => <String, dynamic>{
  if (instance.purpose case final $value?)
    'purpose': GrantProcessingConsentCommand._write_purpose($value),
  if (instance.version case final $value?)
    'version': GrantProcessingConsentCommand._write_version($value),
};
