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
    currentVersion: json['currentVersion'] as String?,
    grantedAt: ProcessingConsentStateOutput._read_grantedAt(json['grantedAt']),
    grantedVersion: json['grantedVersion'] as String?,
    isCurrent: json['isCurrent'] as bool?,
    purpose: json['purpose'] as String?,
  );
}

Map<String, dynamic> _$ProcessingConsentStateOutputToJson(
  ProcessingConsentStateOutput instance,
) => <String, dynamic>{
  'currentVersion': ?instance.currentVersion,
  'grantedAt': ?ProcessingConsentStateOutput._write_grantedAt(
    instance.grantedAt,
  ),
  'grantedVersion': ?instance.grantedVersion,
  'isCurrent': ?instance.isCurrent,
  'purpose': ?instance.purpose,
};
