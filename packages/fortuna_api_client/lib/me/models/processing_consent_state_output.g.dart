// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'processing_consent_state_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProcessingConsentStateOutput _$ProcessingConsentStateOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'currentVersion',
      'grantedAt',
      'grantedVersion',
      'isCurrent',
      'purpose',
    ],
    disallowNullValues: const ['isCurrent'],
  );
  return ProcessingConsentStateOutput(
    currentVersion: !json.containsKey('currentVersion')
        ? null
        : ProcessingConsentStateOutput._read_currentVersion(
            json['currentVersion'],
          ),
    grantedAt: !json.containsKey('grantedAt')
        ? null
        : ProcessingConsentStateOutput._read_grantedAt(json['grantedAt']),
    grantedVersion: !json.containsKey('grantedVersion')
        ? null
        : ProcessingConsentStateOutput._read_grantedVersion(
            json['grantedVersion'],
          ),
    isCurrent: json['isCurrent'] as bool?,
    purpose: !json.containsKey('purpose')
        ? null
        : ProcessingConsentStateOutput._read_purpose(json['purpose']),
  );
}

Map<String, dynamic> _$ProcessingConsentStateOutputToJson(
  ProcessingConsentStateOutput instance,
) => <String, dynamic>{
  if (instance.currentVersion case final $value?)
    'currentVersion': ProcessingConsentStateOutput._write_currentVersion(
      $value,
    ),
  if (instance.grantedAt case final $value?)
    'grantedAt': ProcessingConsentStateOutput._write_grantedAt($value),
  if (instance.grantedVersion case final $value?)
    'grantedVersion': ProcessingConsentStateOutput._write_grantedVersion(
      $value,
    ),
  'isCurrent': ?instance.isCurrent,
  if (instance.purpose case final $value?)
    'purpose': ProcessingConsentStateOutput._write_purpose($value),
};
