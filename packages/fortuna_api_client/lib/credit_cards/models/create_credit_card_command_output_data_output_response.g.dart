// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_credit_card_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCreditCardCommandOutputDataOutput$Response
_$CreateCreditCardCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return CreateCreditCardCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : CreateCreditCardCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : CreateCreditCardCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : CreateCreditCardCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp: CreateCreditCardCommandOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$CreateCreditCardCommandOutputDataOutput$ResponseToJson(
  CreateCreditCardCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': CreateCreditCardCommandOutputDataOutput$Response._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages':
        CreateCreditCardCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?CreateCreditCardCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
