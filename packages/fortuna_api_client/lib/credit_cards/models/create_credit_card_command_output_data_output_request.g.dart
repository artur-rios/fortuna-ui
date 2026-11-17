// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_credit_card_command_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCreditCardCommandOutputDataOutput$Request
_$CreateCreditCardCommandOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['data', 'timestamp'],
  );
  return CreateCreditCardCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : CreateCreditCardCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : CreateCreditCardCommandOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : CreateCreditCardCommandOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: CreateCreditCardCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CreateCreditCardCommandOutputDataOutput$RequestToJson(
  CreateCreditCardCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': CreateCreditCardCommandOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages': CreateCreditCardCommandOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp':
      ?CreateCreditCardCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
