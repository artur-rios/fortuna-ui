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
    disallowNullValues: const ['timestamp'],
  );
  return AuthenticateLocalAccountCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : AuthenticateLocalAccountCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
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
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?AuthenticateLocalAccountCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
