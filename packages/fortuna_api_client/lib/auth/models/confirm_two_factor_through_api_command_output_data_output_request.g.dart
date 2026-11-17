// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_two_factor_through_api_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfirmTwoFactorThroughApiCommandOutputDataOutput$Request
_$ConfirmTwoFactorThroughApiCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return ConfirmTwoFactorThroughApiCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : ConfirmTwoFactorThroughApiCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : ConfirmTwoFactorThroughApiCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : ConfirmTwoFactorThroughApiCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp:
        ConfirmTwoFactorThroughApiCommandOutputDataOutput$Request._read_timestamp(
          json['timestamp'],
        ),
  );
}

Map<String, dynamic>
_$ConfirmTwoFactorThroughApiCommandOutputDataOutput$RequestToJson(
  ConfirmTwoFactorThroughApiCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors':
        ConfirmTwoFactorThroughApiCommandOutputDataOutput$Request._write_errors(
          $value,
        ),
  if (instance.messages case final $value?)
    'messages':
        ConfirmTwoFactorThroughApiCommandOutputDataOutput$Request._write_messages(
          $value,
        ),
  'timestamp':
      ?ConfirmTwoFactorThroughApiCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
