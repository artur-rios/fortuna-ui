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
    disallowNullValues: const ['timestamp'],
  );
  return UpdateCreditCardCommandOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : UpdateCreditCardCommandOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timestamp: UpdateCreditCardCommandOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$UpdateCreditCardCommandOutputDataOutput$RequestToJson(
  UpdateCreditCardCommandOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?UpdateCreditCardCommandOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
