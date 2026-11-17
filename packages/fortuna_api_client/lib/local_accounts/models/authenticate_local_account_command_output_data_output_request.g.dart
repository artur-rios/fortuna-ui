// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticate_local_account_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticateLocalAccountCommandOutputDataOutput$Request
_$AuthenticateLocalAccountCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return AuthenticateLocalAccountCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : AuthenticateLocalAccountCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : AuthenticateLocalAccountCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : AuthenticateLocalAccountCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        AuthenticateLocalAccountCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$AuthenticateLocalAccountCommandOutputDataOutput$RequestToJson(
  AuthenticateLocalAccountCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        AuthenticateLocalAccountCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        AuthenticateLocalAccountCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?AuthenticateLocalAccountCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
