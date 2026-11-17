// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_sign_in_through_api_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleSignInThroughApiCommandOutputDataOutput$Request
_$GoogleSignInThroughApiCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return GoogleSignInThroughApiCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : GoogleSignInThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp:
        GoogleSignInThroughApiCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$GoogleSignInThroughApiCommandOutputDataOutput$RequestToJson(
  GoogleSignInThroughApiCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?GoogleSignInThroughApiCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
