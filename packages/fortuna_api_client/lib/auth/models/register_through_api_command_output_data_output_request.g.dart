// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_through_api_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterThroughApiCommandOutputDataOutput$Request
_$RegisterThroughApiCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return RegisterThroughApiCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : RegisterThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : RegisterThroughApiCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : RegisterThroughApiCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        RegisterThroughApiCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic> _$RegisterThroughApiCommandOutputDataOutput$RequestToJson(
  RegisterThroughApiCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': RegisterThroughApiCommandOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages':
        RegisterThroughApiCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?RegisterThroughApiCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
