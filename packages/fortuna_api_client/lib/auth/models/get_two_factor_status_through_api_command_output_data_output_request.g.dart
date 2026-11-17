// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_two_factor_status_through_api_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetTwoFactorStatusThroughApiCommandOutputDataOutput$Request
_$GetTwoFactorStatusThroughApiCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return GetTwoFactorStatusThroughApiCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : GetTwoFactorStatusThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp:
        GetTwoFactorStatusThroughApiCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$GetTwoFactorStatusThroughApiCommandOutputDataOutput$RequestToJson(
  GetTwoFactorStatusThroughApiCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?GetTwoFactorStatusThroughApiCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
