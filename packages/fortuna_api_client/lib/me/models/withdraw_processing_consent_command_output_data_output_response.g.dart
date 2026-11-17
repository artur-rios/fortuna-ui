// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdraw_processing_consent_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WithdrawProcessingConsentCommandOutputDataOutput$Response
_$WithdrawProcessingConsentCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return WithdrawProcessingConsentCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : WithdrawProcessingConsentCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : WithdrawProcessingConsentCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : WithdrawProcessingConsentCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        WithdrawProcessingConsentCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$WithdrawProcessingConsentCommandOutputDataOutput$ResponseToJson(
  WithdrawProcessingConsentCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        WithdrawProcessingConsentCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        WithdrawProcessingConsentCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?WithdrawProcessingConsentCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
