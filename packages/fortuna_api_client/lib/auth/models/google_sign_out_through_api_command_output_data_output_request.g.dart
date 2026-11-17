// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_sign_out_through_api_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleSignOutThroughApiCommandOutputDataOutput$Request
_$GoogleSignOutThroughApiCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return GoogleSignOutThroughApiCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : GoogleSignOutThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp:
        GoogleSignOutThroughApiCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$GoogleSignOutThroughApiCommandOutputDataOutput$RequestToJson(
  GoogleSignOutThroughApiCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?GoogleSignOutThroughApiCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
