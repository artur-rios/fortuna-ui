// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_sign_in_through_api_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleSignInThroughApiCommandOutputDataOutput$Response
_$GoogleSignInThroughApiCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return GoogleSignInThroughApiCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : GoogleSignInThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : GoogleSignInThroughApiCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : GoogleSignInThroughApiCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        GoogleSignInThroughApiCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$GoogleSignInThroughApiCommandOutputDataOutput$ResponseToJson(
  GoogleSignInThroughApiCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        GoogleSignInThroughApiCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        GoogleSignInThroughApiCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?GoogleSignInThroughApiCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
