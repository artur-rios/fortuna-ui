// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'processing_consent_state_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProcessingConsentStateOutput _$ProcessingConsentStateOutputFromJson(
  Map<String, dynamic> json,
) => ProcessingConsentStateOutput(
  currentVersion: json['currentVersion'] as String?,
  grantedAt: json['grantedAt'] == null
      ? null
      : DateTime.parse(json['grantedAt'] as String),
  grantedVersion: json['grantedVersion'] as String?,
  isCurrent: json['isCurrent'] as bool?,
  purpose: json['purpose'] as String?,
);

Map<String, dynamic> _$ProcessingConsentStateOutputToJson(
  ProcessingConsentStateOutput instance,
) => <String, dynamic>{
  'currentVersion': instance.currentVersion,
  'grantedAt': instance.grantedAt?.toIso8601String(),
  'grantedVersion': instance.grantedVersion,
  'isCurrent': instance.isCurrent,
  'purpose': instance.purpose,
};
