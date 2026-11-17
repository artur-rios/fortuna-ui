// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdraw_processing_consent_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WithdrawProcessingConsentCommandOutput
_$WithdrawProcessingConsentCommandOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'purpose',
      'revokedConnections',
      'stoppedSynchronizations',
    ],
    disallowNullValues: const ['revokedConnections', 'stoppedSynchronizations'],
  );
  return WithdrawProcessingConsentCommandOutput(
    purpose: !json.containsKey('purpose')
        ? null
        : WithdrawProcessingConsentCommandOutput._read_purpose(json['purpose']),
    revokedConnections:
        WithdrawProcessingConsentCommandOutput._read_revokedConnections(
          json['revokedConnections'],
        ),
    stoppedSynchronizations:
        WithdrawProcessingConsentCommandOutput._read_stoppedSynchronizations(
          json['stoppedSynchronizations'],
        ),
  );
}

Map<String, dynamic> _$WithdrawProcessingConsentCommandOutputToJson(
  WithdrawProcessingConsentCommandOutput instance,
) => <String, dynamic>{
  if (instance.purpose case final $value?)
    'purpose': WithdrawProcessingConsentCommandOutput._write_purpose($value),
  'revokedConnections':
      ?WithdrawProcessingConsentCommandOutput._write_revokedConnections(
        instance.revokedConnections,
      ),
  'stoppedSynchronizations':
      ?WithdrawProcessingConsentCommandOutput._write_stoppedSynchronizations(
        instance.stoppedSynchronizations,
      ),
};
