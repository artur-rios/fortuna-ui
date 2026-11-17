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
    disallowNullValues: const ['data', 'timestamp'],
  );
  return GetTwoFactorStatusThroughApiCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : GetTwoFactorStatusThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : GetTwoFactorStatusThroughApiCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : GetTwoFactorStatusThroughApiCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
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
  if (instance.errors case final $value?)
    'errors':
        GetTwoFactorStatusThroughApiCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        GetTwoFactorStatusThroughApiCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?GetTwoFactorStatusThroughApiCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
