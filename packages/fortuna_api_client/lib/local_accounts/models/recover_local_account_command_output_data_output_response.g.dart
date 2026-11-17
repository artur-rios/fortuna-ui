// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recover_local_account_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecoverLocalAccountCommandOutputDataOutput$Response
_$RecoverLocalAccountCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return RecoverLocalAccountCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : RecoverLocalAccountCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RecoverLocalAccountCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RecoverLocalAccountCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        RecoverLocalAccountCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$RecoverLocalAccountCommandOutputDataOutput$ResponseToJson(
  RecoverLocalAccountCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': RecoverLocalAccountCommandOutputDataOutput$Response._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages':
        RecoverLocalAccountCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?RecoverLocalAccountCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
