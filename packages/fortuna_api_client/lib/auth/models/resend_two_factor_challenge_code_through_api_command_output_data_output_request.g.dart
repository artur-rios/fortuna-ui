// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resend_two_factor_challenge_code_through_api_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResendTwoFactorChallengeCodeThroughApiCommandOutputDataOutput$Request
_$ResendTwoFactorChallengeCodeThroughApiCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return ResendTwoFactorChallengeCodeThroughApiCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : ResendTwoFactorChallengeCodeThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : ResendTwoFactorChallengeCodeThroughApiCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : ResendTwoFactorChallengeCodeThroughApiCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        ResendTwoFactorChallengeCodeThroughApiCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$ResendTwoFactorChallengeCodeThroughApiCommandOutputDataOutput$RequestToJson(
  ResendTwoFactorChallengeCodeThroughApiCommandOutputDataOutput$Request
  instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        ResendTwoFactorChallengeCodeThroughApiCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        ResendTwoFactorChallengeCodeThroughApiCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?ResendTwoFactorChallengeCodeThroughApiCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
