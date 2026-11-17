// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_through_api_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginThroughApiCommandOutputDataOutput$Request
_$LoginThroughApiCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return LoginThroughApiCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : LoginThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: LoginThroughApiCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$LoginThroughApiCommandOutputDataOutput$RequestToJson(
  LoginThroughApiCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp': ?LoginThroughApiCommandOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};
