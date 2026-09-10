// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grant_processing_consent_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GrantProcessingConsentCommandOutput
_$GrantProcessingConsentCommandOutputFromJson(Map<String, dynamic> json) =>
    GrantProcessingConsentCommandOutput(
      grantedAt: json['grantedAt'] == null
          ? null
          : DateTime.parse(json['grantedAt'] as String),
      id: json['id'] as String?,
      isCurrent: json['isCurrent'] as bool?,
      purpose: json['purpose'] as String?,
      version: json['version'] as String?,
    );

Map<String, dynamic> _$GrantProcessingConsentCommandOutputToJson(
  GrantProcessingConsentCommandOutput instance,
) => <String, dynamic>{
  'grantedAt': instance.grantedAt?.toIso8601String(),
  'id': instance.id,
  'isCurrent': instance.isCurrent,
  'purpose': instance.purpose,
  'version': instance.version,
};
