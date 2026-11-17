// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'synchronize_connection_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SynchronizeConnectionCommandOutputDataOutput$Response
_$SynchronizeConnectionCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return SynchronizeConnectionCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : SynchronizeConnectionCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : SynchronizeConnectionCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : SynchronizeConnectionCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp:
        SynchronizeConnectionCommandOutputDataOutput$Response._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$SynchronizeConnectionCommandOutputDataOutput$ResponseToJson(
  SynchronizeConnectionCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        SynchronizeConnectionCommandOutputDataOutput$Response._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        SynchronizeConnectionCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?SynchronizeConnectionCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
