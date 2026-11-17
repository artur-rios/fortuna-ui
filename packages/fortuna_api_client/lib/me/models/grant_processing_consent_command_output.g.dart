// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grant_processing_consent_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GrantProcessingConsentCommandOutput
_$GrantProcessingConsentCommandOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['grantedAt', 'id', 'isCurrent', 'purpose', 'version'],
    disallowNullValues: const ['grantedAt', 'id', 'isCurrent'],
  );
  return GrantProcessingConsentCommandOutput(
    grantedAt: GrantProcessingConsentCommandOutput._read_grantedAt(
      json['grantedAt'],
    ),
    id: json['id'] as String?,
    isCurrent: json['isCurrent'] as bool?,
    purpose: !json.containsKey('purpose')
        ? null
        : GrantProcessingConsentCommandOutput._read_purpose(json['purpose']),
    version: !json.containsKey('version')
        ? null
        : GrantProcessingConsentCommandOutput._read_version(json['version']),
  );
}

Map<String, dynamic> _$GrantProcessingConsentCommandOutputToJson(
  GrantProcessingConsentCommandOutput instance,
) => <String, dynamic>{
  'grantedAt': ?GrantProcessingConsentCommandOutput._write_grantedAt(
    instance.grantedAt,
  ),
  'id': ?instance.id,
  'isCurrent': ?instance.isCurrent,
  if (instance.purpose case final $value?)
    'purpose': GrantProcessingConsentCommandOutput._write_purpose($value),
  if (instance.version case final $value?)
    'version': GrantProcessingConsentCommandOutput._write_version($value),
};
