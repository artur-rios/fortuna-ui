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
    disallowNullValues: const ['timestamp'],
  );
  return ResendTwoFactorChallengeCodeThroughApiCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : ResendTwoFactorChallengeCodeThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?ResendTwoFactorChallengeCodeThroughApiCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
