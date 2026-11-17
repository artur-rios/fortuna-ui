// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_credit_card_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCreditCardCommandOutputDataOutput$Request
_$UpdateCreditCardCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return UpdateCreditCardCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : UpdateCreditCardCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : UpdateCreditCardCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : UpdateCreditCardCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: UpdateCreditCardCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$UpdateCreditCardCommandOutputDataOutput$RequestToJson(
  UpdateCreditCardCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': UpdateCreditCardCommandOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages': UpdateCreditCardCommandOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp':
      ?UpdateCreditCardCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
