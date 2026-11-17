// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_credit_card_command_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCreditCardCommandOutputDataOutput$Response
_$UpdateCreditCardCommandOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return UpdateCreditCardCommandOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : UpdateCreditCardCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : UpdateCreditCardCommandOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : UpdateCreditCardCommandOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
    success: json['success'] as bool?,
    timestamp: UpdateCreditCardCommandOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$UpdateCreditCardCommandOutputDataOutput$ResponseToJson(
  UpdateCreditCardCommandOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': UpdateCreditCardCommandOutputDataOutput$Response._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages':
        UpdateCreditCardCommandOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?UpdateCreditCardCommandOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
