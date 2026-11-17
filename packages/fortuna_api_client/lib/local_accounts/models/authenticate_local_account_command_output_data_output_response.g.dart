// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticate_local_account_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticateLocalAccountCommandOutputDataOutput$Response
_$AuthenticateLocalAccountCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return AuthenticateLocalAccountCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : AuthenticateLocalAccountCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : AuthenticateLocalAccountCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : AuthenticateLocalAccountCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        AuthenticateLocalAccountCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$AuthenticateLocalAccountCommandOutputDataOutput$ResponseToJson(
  AuthenticateLocalAccountCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        AuthenticateLocalAccountCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        AuthenticateLocalAccountCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?AuthenticateLocalAccountCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
