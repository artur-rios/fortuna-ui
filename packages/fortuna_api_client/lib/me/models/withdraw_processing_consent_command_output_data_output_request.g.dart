// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdraw_processing_consent_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WithdrawProcessingConsentCommandOutputDataOutput$Request
_$WithdrawProcessingConsentCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return WithdrawProcessingConsentCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : WithdrawProcessingConsentCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : WithdrawProcessingConsentCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : WithdrawProcessingConsentCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        WithdrawProcessingConsentCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$WithdrawProcessingConsentCommandOutputDataOutput$RequestToJson(
  WithdrawProcessingConsentCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        WithdrawProcessingConsentCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        WithdrawProcessingConsentCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?WithdrawProcessingConsentCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
