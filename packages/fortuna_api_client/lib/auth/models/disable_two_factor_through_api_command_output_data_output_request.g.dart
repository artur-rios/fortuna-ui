// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disable_two_factor_through_api_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DisableTwoFactorThroughApiCommandOutputDataOutput$Request
_$DisableTwoFactorThroughApiCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return DisableTwoFactorThroughApiCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : DisableTwoFactorThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp:
        DisableTwoFactorThroughApiCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$DisableTwoFactorThroughApiCommandOutputDataOutput$RequestToJson(
  DisableTwoFactorThroughApiCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?DisableTwoFactorThroughApiCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
