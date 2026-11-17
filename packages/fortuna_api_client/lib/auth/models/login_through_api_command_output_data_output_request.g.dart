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
    disallowNullValues: const ['data', 'timestamp'],
  );
  return LoginThroughApiCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : LoginThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : LoginThroughApiCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : LoginThroughApiCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: LoginThroughApiCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$LoginThroughApiCommandOutputDataOutput$RequestToJson(
  LoginThroughApiCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': LoginThroughApiCommandOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages': LoginThroughApiCommandOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp': ?LoginThroughApiCommandOutputDataOutput$Request._write_timestamp(
    instance.timestamp,
  ),
};
