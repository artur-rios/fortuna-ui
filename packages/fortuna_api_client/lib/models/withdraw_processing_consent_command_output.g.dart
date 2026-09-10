// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdraw_processing_consent_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WithdrawProcessingConsentCommandOutput
_$WithdrawProcessingConsentCommandOutputFromJson(Map<String, dynamic> json) =>
    WithdrawProcessingConsentCommandOutput(
      purpose: json['purpose'] as String?,
      revokedConnections: (json['revokedConnections'] as num?)?.toInt(),
      stoppedSynchronizations: (json['stoppedSynchronizations'] as num?)
          ?.toInt(),
    );

Map<String, dynamic> _$WithdrawProcessingConsentCommandOutputToJson(
  WithdrawProcessingConsentCommandOutput instance,
) => <String, dynamic>{
  'purpose': instance.purpose,
  'revokedConnections': instance.revokedConnections,
  'stoppedSynchronizations': instance.stoppedSynchronizations,
};
